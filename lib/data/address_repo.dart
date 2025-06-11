import 'package:soyabox/api/api_client.dart';
import 'package:soyabox/models/address_model.dart';
import 'package:soyabox/utils/app_constant.dart';
import 'package:get/get.dart';

class AddressRepo {
  final ApiClient apiClient;

  AddressRepo({
    required this.apiClient,
  });

  Future<Response> getAddresses(int userId) async {
    return await apiClient.getData('${AppConstant.getAddressUrl}/$userId');
  }

  Future<Response> addAddress(AddressModel addressModel) async {
   
    return await apiClient.postData(
        AppConstant.addAddressUrl, addressModel.toJson());
  }

  Future<Response> removeAddress(int addressId) async {
    String uri = '${AppConstant.removeAddress}/$addressId';
    return await apiClient.removeAddress(uri);
  }

  // Dans AddressRepo
Future<Response> getAddressById(int addressId) async {
  return await apiClient.getData('/api/addresses/$addressId');
}
}
