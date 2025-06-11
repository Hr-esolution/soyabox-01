import 'package:soyabox/models/category_model.dart';
import 'package:soyabox/screen/auth/login_page.dart';
import 'package:soyabox/screen/auth/register_page.dart';
import 'package:soyabox/screen/cart/checkout_page.dart';
import 'package:soyabox/screen/cart/order_history_page.dart';
import 'package:soyabox/screen/main_page.dart';
import 'package:soyabox/screen/reservation/add_reservation.dart';
import 'package:soyabox/screen/reservation/reservation_history.dart';
import 'package:soyabox/widgets/all_products.dart';
import 'package:get/get.dart';
import 'package:soyabox/screen/home_page.dart';
import 'package:soyabox/screen/splash_screen.dart';
import 'package:soyabox/screen/cart/cart_page.dart';
import 'package:soyabox/screen/auth/profile_page.dart';
import 'package:soyabox/widgets/category_grid.dart';
import 'package:soyabox/widgets/favorites_page.dart';

class AppRoutes {
  static const String mainScreen = '/';
  static const String addReservation = '/add-reservation';
  static const String reservationHistory = '/reservation-history';
  static const String home = '/home';
  static const String categoryGrid = '/categoryGrid';
  static const String cart = '/cart';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String login = '/login';
  static const String register = '/register';
  static const String allProducts = '/allProducts';
  static const String checkout = '/checkout';
  static const String splashScreen = '/splash';
  static const String orderHistory = '/order-history';
  static List<GetPage> pages = [
     GetPage(
      name: splashScreen,
      page: () =>
          const SplashScreen(), // MainScreen should handle null category
      transition: Transition.fadeIn,
    ),
     GetPage(
      name: orderHistory,
      page: () =>
          const OrderHistoryPage(), // MainScreen should handle null category
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: reservationHistory,
      page: () =>
          const ReservationHistoryPage(), // MainScreen should handle null category
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: addReservation,
      page: () =>
          const AddReservationPage(), // MainScreen should handle null category
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: mainScreen,
      page: () => MainScreen(), // MainScreen should handle null category
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: checkout,
      page: () =>
          const CheckoutPage(), // MainScreen should handle null category
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: allProducts,
      page: () => AllProductsPage(), // MainScreen should handle null category
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: home,
      page: () {
        final Category? category = Get.arguments;
        return HomePage(category: category);
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: categoryGrid,
      page: () {
        final Category? category = Get.arguments;
        return CategoryGridPage(category: category);
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: cart,
      page: () => CartPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: login,
      page: () => const LoginPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: register,
      page: () => const RegisterPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: favorites,
      page: () => const FavoritesPage(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: profile,
      page: () => const ProfilePage(),
      transition: Transition.fadeIn,
    ),
  ];
}
