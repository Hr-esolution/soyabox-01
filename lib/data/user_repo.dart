import 'package:soyabox/api/api_client.dart';
import 'package:soyabox/utils/app_constant.dart';
import 'package:get/get.dart';

class UserRepo {
  final ApiClient apiClient;
  UserRepo({required this.apiClient});
  Future<Response> getUserInfo() async {
    return await apiClient.getData(AppConstant.userInfoUrl);
  }
}
