import 'package:flutter/material.dart';
import 'package:soyabox/controllers/address_controller.dart';
import 'package:soyabox/controllers/auth_controller.dart';
import 'package:soyabox/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:soyabox/controllers/cart_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';

class PersistentBottomBar extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final ThemeController themeController = Get.find<ThemeController>();

  PersistentBottomBar({super.key});

  String formatTotalPrice(double price, int quantity) {
    return '${NumberFormat.currency(locale: 'fr_FR', symbol: '').format(price * quantity)} Dhs';
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CartController>(
      builder: (controller) {
        if (controller.isCartEmpty()) {
          return const SizedBox.shrink(); // Cacher si le panier est vide
        }

        // Si le panier n'est pas vide, afficher la barre avec le total et bouton "Commander"
        return BottomAppBar(
          shape: const CircularNotchedRectangle(), // Découpe pour le FloatingActionButton
          color: themeController.isDarkMode ? Colors.black : Colors.white, // Couleur de fond
          elevation: 8,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ), // Bordure arrondie
            child: Container(
              color: themeController.isDarkMode ? Colors.black : Colors.white, // Définir la couleur de fond
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16), // Réduire la hauteur
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: ${NumberFormat.currency(locale: 'fr_FR', symbol: '').format(controller.totalAmount)} Dhs',
                    style: TextStyle(
                      fontSize: 14, // Réduire la taille de la police
                      fontWeight: FontWeight.normal,
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.black87,
                    ),
                  ),
                  controller.isProcessingOrder
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            bool isLoggedIn = Get.find<AuthController>().userLoggedIn();
                            if (isLoggedIn) {
                              controller.startProcessingOrder();
                              final user = Get.find<AuthController>().user;

                              // Vérification de la présence de l'utilisateur et de son ID
                              if (Get.find<UserController>().userModel.id != null) {
                                final addresses = await Get.find<AddressController>()
                                    .fetchAddressForUser(Get.find<UserController>().userModel.id!);

                                Get.toNamed('/checkout', arguments: {
                                  'user': user,
                                  'addresses': addresses,
                                });
                              } else {
                                // Gérer le cas où l'utilisateur n'a pas d'ID
                                Get.snackbar('Erreur', 'Utilisateur non valide. Veuillez vous reconnecter.');
                              }

                              controller.stopProcessingOrder();
                            } else {
                              Get.toNamed('/login', arguments: {
                                'redirectTo': '/checkout',
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            elevation: 4,
                            foregroundColor: themeController.isDarkMode
                                ? Colors.white
                                : Colors.white,
                            backgroundColor: themeController.isDarkMode
                                ? Colors.redAccent
                                : Colors.redAccent,
                            textStyle: const TextStyle(
                              fontSize: 14, // Réduire la taille du texte du bouton
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: const Text(
                            'Commander',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
