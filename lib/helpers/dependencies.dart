import 'package:soyabox/api/api_client.dart';
import 'package:soyabox/controllers/address_controller.dart';
import 'package:soyabox/controllers/auth_controller.dart';
import 'package:soyabox/controllers/cart_controller.dart';
import 'package:soyabox/controllers/category_controller.dart';
import 'package:soyabox/controllers/favorites_controller.dart';
import 'package:soyabox/controllers/order_controller.dart';
import 'package:soyabox/controllers/product_controller.dart';
import 'package:soyabox/controllers/reservation_controller.dart';
import 'package:soyabox/controllers/user_controller.dart';
import 'package:soyabox/data/address_repo.dart';
import 'package:soyabox/data/auth_repo.dart';
import 'package:soyabox/data/cart_repo.dart';
import 'package:soyabox/data/category_repo.dart';
import 'package:soyabox/data/order_repo.dart';
import 'package:soyabox/data/product_repo.dart';
import 'package:soyabox/data/reservation_repo.dart';
import 'package:soyabox/data/user_repo.dart';
import 'package:soyabox/utils/app_constant.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  Get.put<SharedPreferences>(sharedPreferences);
  Get.lazyPut(() =>
      FavoritesController()); // Change from lazyPut to put for eager initialization
  Get.lazyPut(() => ApiClient(
      appBaseUrl: AppConstant.baseUrl, sharedPreferences: Get.find()));

//repository injection
  Get.lazyPut(() => OrderRepo(apiClient: Get.find()));
  Get.put(() => OrderController(orderRepo: Get.find()));

  Get.lazyPut(() => CartRepo(sharedPreferences: Get.find()));
  Get.lazyPut(() => CartController(cartRepo: Get.find(), storageItems: []));
  //
  Get.lazyPut(() => ProductRepo(apiClient: Get.find()));
  Get.lazyPut(() => ProductController(productRepo: Get.find()));
  //
  Get.lazyPut(() => CategoryRepo(apiClient: Get.find()));
  Get.lazyPut(() => CategoryController(categoryRepo: Get.find()));
  //
  Get.lazyPut(() => UserRepo(apiClient: Get.find()));
  Get.lazyPut(() => UserController(userRepo: Get.find()));

  //
  Get.lazyPut(() => AddressController(addressRepo: Get.find()));
  Get.lazyPut(() => AddressRepo(apiClient: Get.find()));
//
  Get.lazyPut(
      () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()));
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  //

  Get.lazyPut(() => ReservationRepo(apiClient: Get.find()));
  Get.lazyPut(() => ReservationController(reservationRepo: Get.find()));
}
