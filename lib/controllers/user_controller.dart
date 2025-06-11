// ignore_for_file: prefer_final_fields

import 'dart:convert';
import 'package:soyabox/data/user_repo.dart';
import 'package:soyabox/models/response_model.dart';
import 'package:soyabox/models/user_model.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController implements GetxService {
  final UserRepo userRepo;
  UserController({
    required this.userRepo,
  });
  @override
  void onInit() {
    super.onInit();
    getUserInfo(); // Automatically load user data when controller is initialized
  }

  var _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  var _userModel = UserModel().obs;
  UserModel get userModel => _userModel.value;

  // New method to update user model
  void setUserModel(UserModel userModel) {
    _userModel.value = userModel;
    update(); // Notify UI of the change
  }

  // Fetch User Information
  Future<ResponseModel> getUserInfo() async {
    try {
      _isLoading.value = true;

      // Check if user info is stored locally in SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userData = prefs.getString('user_data');

      if (userData != null) {
        // Load user info from local storage
        _userModel.value = UserModel.fromJson(jsonDecode(userData));
        return ResponseModel(true, "User data loaded from local storage");
      } else {
        // Fetch user info from the backend (API)
        final response = await userRepo.getUserInfo();
        if (response.statusCode == 200) {
          _userModel.value = UserModel.fromJson(response.body);

          // Save the fetched user info to local storage
          prefs.setString('user_data', jsonEncode(_userModel.value.toJson()));

          return ResponseModel(
              true, "User data loaded from API and saved locally");
        } else {
          return ResponseModel(
              false, response.statusText ?? "Unknown error occurred");
        }
      }
    } catch (e) {
      return ResponseModel(false, "Error: $e");
    } finally {
      _isLoading.value = false;
      update(); // Notify the UI about the state change
    }
  }

  // Method to check if the user is logged in
  bool isLoggedIn() {
    return _userModel.value.id != null;
  }

  // Clear user data from local storage (logout functionality)
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all data in SharedPreferences
    _userModel.value = UserModel(); // Reset user model
    update(); // Notify the UI about the state change
  }

  // Manually save the user data to local storage (useful after login or updates)
  Future<void> saveUserToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_data', jsonEncode(_userModel.value.toJson()));
  }

  // Manually load the user data from local storage (if necessary)
  Future<void> loadUserFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString('user_data');
    if (userData != null) {
      _userModel.value = UserModel.fromJson(jsonDecode(userData));
      update(); // Notify the UI about the state change
    }
  }




}
