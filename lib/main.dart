import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:soyabox/controllers/product_controller.dart';
import 'package:soyabox/controllers/category_controller.dart';
import 'package:soyabox/controllers/cart_controller.dart';
import 'package:soyabox/controllers/address_controller.dart';
import 'package:soyabox/controllers/order_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:soyabox/controllers/favorites_controller.dart';
import 'package:soyabox/controllers/reservation_controller.dart';
import 'package:soyabox/controllers/user_controller.dart';
import 'package:soyabox/services/notification_service.dart';
import 'package:soyabox/utils/app_routes.dart';
import 'package:soyabox/utils/app_theme.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:soyabox/helpers/dependencies.dart' as dep;

// Gestion des notifications en arrière-plan
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  
}

// Fonction principale
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Assure que Firebase est prêt avant toute chose
  await dep.init(); // Initialisation des dépendances
  FirebaseNotifications().initialize(); // Initialisation du service de notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialisation des contrôleurs
    Get.put(ProductController(productRepo: Get.find()));
    Get.put(CategoryController(categoryRepo: Get.find()));
    Get.put(CartController(cartRepo: Get.find(), storageItems: []));
    Get.put(AddressController(addressRepo: Get.find()));
    Get.put(OrderController(orderRepo: Get.find()));
    Get.put(ThemeController()); 
    Get.put(FavoritesController());
    Get.put(ReservationController(reservationRepo: Get.find()));
    Get.put(UserController(userRepo: Get.find()));

    // Charger les produits et catégories dès le démarrage
    Get.find<ProductController>().loadProducts();
    Get.find<CategoryController>().loadCategories();

    return GetBuilder<ThemeController>(
      init: Get.find<ThemeController>(),
      builder: (themeController) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'soyabox',
          theme: themeController.isDarkMode
              ? AppTheme.darkTheme
              : AppTheme.lightTheme,
          initialRoute: AppRoutes.splashScreen,
          getPages: AppRoutes.pages,
        );
      },
    );
  }
}
