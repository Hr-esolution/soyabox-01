import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:soyabox/api/api_client.dart';
import 'package:soyabox/models/signup_model.dart';
import 'package:soyabox/models/user_model.dart';
import 'package:soyabox/utils/app_constant.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  AuthRepo({
    required this.apiClient,
    required this.sharedPreferences,
  });

  Future<Response> registration(SignUpBody signUpBody) async {
    return await apiClient.postData(
        AppConstant.registrationUrl, signUpBody.toJson());
  }

  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeaders(token);
    return await sharedPreferences.setString(AppConstant.token, token);
  }

  Future<Response> login(String phone, String password) async {
    return await apiClient
        .postData(AppConstant.loginUrl, {"phone": phone, "password": password});
  }

  Future<String?> getFcmToken() async {
    try {
      String? token = await firebaseMessaging.getToken();
     
      return token;
    } catch (e) {
     
      return null;
    }
  }

 Future<Response> sendFcmToken(String fcmToken) async {


  final response = await apiClient.postData(
    AppConstant.updateFcmTokenUrl,
    {'fcm_token': fcmToken},
  );



  return response;
}

  Future<String> getUserToken() async {
    return sharedPreferences.getString(AppConstant.token) ?? "none";
  }

  bool userLoggedIn() {
    return sharedPreferences.containsKey(AppConstant.token);
  }

  Future<void> saveUserNumberAndPassword(String phone, String password) async {
    try {
      await sharedPreferences.setString(AppConstant.phone, phone);
      await sharedPreferences.setString(AppConstant.password, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> clearSharedData() async {
    await Future.delayed(const Duration(seconds: 1));
    await sharedPreferences.remove(AppConstant.token);
    await sharedPreferences.remove(AppConstant.phone);
    await sharedPreferences.remove(AppConstant.password);
    apiClient.token = '';
    apiClient.updateHeaders('');
  }

  int? loggedInUserId;

  void setLoggedInUserId(int? userId) {
    loggedInUserId = userId;
  }

  int? getLoggedInUserId() {
    return loggedInUserId;
  }

  // Nouvelle méthode pour récupérer les données de l'utilisateur
  Future<UserModel?> fetchUserData() async {
    final token = await getUserToken();
    if (token != "none" && token.isNotEmpty) {
      apiClient.updateHeaders(token);
      final response = await apiClient.getData(AppConstant.userInfoUrl);

      if (response.statusCode == 200) {
        try {
          final Map<String, dynamic> responseData = json.decode(response.body);
          return UserModel.fromJson(responseData);
        } catch (e) {
          
          return null;
        }
      }
    }
    return null;
  }
}
