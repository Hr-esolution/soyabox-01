import 'package:soyabox/data/auth_repo.dart';
import 'package:soyabox/models/response_model.dart';
import 'package:soyabox/models/signup_model.dart';
import 'package:soyabox/models/user_model.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class AuthController extends GetxController implements GetxService {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  UserModel? _user;
  UserModel? get user => _user;

  var passwordVisible = false.obs;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void onInit() {
    super.onInit();
    initUserSession();
  }

  void togglePasswordVisibility() {
    passwordVisible.value = !passwordVisible.value;
  }

  Future<String?> _getFcmToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      return null;
    }
  }

  // S'abonner aux topics (par ex: notifications de commande)
  Future<void> subscribeToTopics() async {
    _firebaseMessaging.subscribeToTopic('nouvelle_commande');
    await FirebaseMessaging.instance.subscribeToTopic('all_users');
  }

  // Méthode pour envoyer le token FCM au backend Laravel
  Future<void> _sendFcmToken(String fcmToken) async {
    try {
      final response = await authRepo.sendFcmToken(fcmToken);
      if (response.statusCode == 200) {
        subscribeToTopics();
      }
    } catch (e) {
      // Erreur capturée sans affichage
    }
  }

  // Inscription (Register)
  Future<ResponseModel> registration(SignUpBody signUpBody) async {
    _isLoading = true;
    update();

    final ResponseModel responseModel;
    Response response = await authRepo.registration(signUpBody);

    if (response.statusCode == 200) {
      authRepo.saveUserToken(response.body["token"]);
      responseModel = ResponseModel(true, response.body["token"]);
      final fcmToken = await _getFcmToken();
      if (fcmToken != null && fcmToken.isNotEmpty) {
        await _sendFcmToken(fcmToken);
      }
    } else {
      responseModel =
          ResponseModel(false, response.statusText ?? 'Erreur inconnue');
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  // Connexion (Login)
  Future<ResponseModel> login(String phone, String password) async {
    _isLoading = true;
    update();

    Response response = await authRepo.login(phone, password);
    ResponseModel responseModel;

    if (response.statusCode == 200) {
      final responseBody = response.body;

      if (responseBody is Map<String, dynamic>) {
        final token = responseBody["token"];
        final userJson = responseBody["user"];

        if (token != null) {
          authRepo.saveUserToken(token);
        }

        if (userJson != null) {
          _user = UserModel.fromJson(userJson);
        }

        // Récupérer et envoyer le token FCM
        final fcmToken = await _getFcmToken();
        if (fcmToken != null && fcmToken.isNotEmpty) {
          await _sendFcmToken(fcmToken);
        }

        responseModel = ResponseModel(true, "Login successful");
      } else {
        responseModel = ResponseModel(false, "Invalid response format");
      }
    } else {
      responseModel =
          ResponseModel(false, response.statusText ?? "Erreur inconnue");
    }

    _isLoading = false;
    update();
    return responseModel;
  }

  // Déconnexion (Logout)
  Future<void> logout() async {
    await authRepo.clearSharedData();
    _user = null;
    update();
    Get.offAllNamed('/'); // Redirection vers l'écran de connexion
  }

  // Initialiser la session utilisateur
  Future<void> initUserSession() async {
    final user = await authRepo.fetchUserData();
    if (user != null) {
      _user = user;
      update();
    }
  }

  bool userLoggedIn() {
    return authRepo.userLoggedIn();
  }

  UserModel? loggedInUser;

  void setLoggedInUser(UserModel user) {
    loggedInUser = user;
  }

  bool isUserLoggedIn() {
    // Vérification pour éviter l'utilisation d'une valeur null
    // ignore: unnecessary_null_comparison
    return _user != null || authRepo.getUserToken() != null;
  }

  int? getLoggedInUserId() {
    return loggedInUser?.id;
  }
}
