import 'package:soyabox/controllers/auth_controller.dart';
import 'package:soyabox/data/address_repo.dart';
import 'package:soyabox/models/address_model.dart';
import 'package:soyabox/models/response_model.dart';
import 'package:get/get.dart';

class AddressController extends GetxController {
  final RxList<AddressModel> addresses = <AddressModel>[].obs;
  final AddressRepo addressRepo;

  AddressController({
    required this.addressRepo,
  });

  bool _loading = false;
  bool get isLoading => _loading;
AddressModel? get orderAddress => _orderAddress.value;
final Rx<AddressModel?> _orderAddress = Rx<AddressModel?>(null);
  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _loading = true;
    update();
    Response response;
    ResponseModel responseModel;

    try {
      response = await addressRepo.addAddress(addressModel);
      if (response.statusCode == 200) {
        String message = response.body["message"];
        responseModel = ResponseModel(true, message);
      } else {
        responseModel = ResponseModel(false, response.statusText!);
      }
    } catch (e) {
      responseModel = ResponseModel(false, "An error occurred");
    }
    _loading = false;
    update();
    return responseModel;
  }

  Future<List<AddressModel>> fetchAddressForUser(int userId) async {
    try {
      final response = await addressRepo.getAddresses(userId);
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.body;
        List<AddressModel> addressList = jsonData
            .map((addressJson) => AddressModel.fromJson(addressJson))
            .toList();

        addresses.assignAll(addressList);
        return addresses;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Change selectedAddress to Rx<AddressModel?>
  Rx<AddressModel?> selectedAddress = Rx<AddressModel?>(null);

  void selectAddress(AddressModel address) {
    selectedAddress.value = address;
    update();
  }

  Future<bool> removeAddress(int addressId) async {
    try {
      Response response = await addressRepo.removeAddress(addressId);
      update();
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  void refreshPage() {
    update();
  }

  Future<void> fetchAddressesForLoggedInUser() async {
    final AuthController authController = Get.find<AuthController>();
    if (authController.isUserLoggedIn()) {
      int? userId = authController.getLoggedInUserId();
      if (userId != null) {
        try {
          _loading = true;
          update();
          final response = await addressRepo.getAddresses(userId);
          if (response.statusCode == 200) {
            final List<dynamic> jsonData = response.body;
            List<AddressModel> addressList = jsonData
                .map((addressJson) => AddressModel.fromJson(addressJson))
                .toList();
            addresses.assignAll(addressList);

            // Set the selected address to the first one if available
            if (addresses.isNotEmpty) {
              selectedAddress.value = addresses.first;
            } else {
              selectedAddress.value = null;
            }
          } else {
            addresses.clear();
            selectedAddress.value = null;
          }
        } catch (e) {
          addresses.clear();
          selectedAddress.value = null;
        } finally {
          _loading = false;
          update();
        }
      }
    } else {
      addresses.clear();
      selectedAddress.value = null;
    }
  }

  // Dans AddressController


Future<void> fetchAddressById(int addressId) async {
  try {
    _loading= true;
    final response = await addressRepo.getAddressById(addressId);
    
    if (response.statusCode == 200) {
      _orderAddress.value = AddressModel.fromJson(response.body);
    } else {
      _orderAddress.value = null;
    }
  } catch (e) {
    _orderAddress.value = null;
  } finally {
    _loading= false;
  }
}
}
