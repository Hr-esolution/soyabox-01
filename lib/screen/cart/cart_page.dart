import 'package:flutter/material.dart';
import 'package:soyabox/controllers/address_controller.dart';
import 'package:soyabox/controllers/cart_controller.dart';
import 'package:soyabox/controllers/auth_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:soyabox/controllers/user_controller.dart';
import 'package:soyabox/utils/app_constant.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CartPage extends StatelessWidget {
  final CartController cartController = Get.find<CartController>();
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final AddressController addressController = Get.find<AddressController>();
  final UserController userController = Get.find<UserController>();

  String formatTotalPrice(double price, int quantity) {
    return '${NumberFormat.currency(locale: 'fr_FR', symbol: '').format(price * quantity)}Dhs';
  }

  CartPage({super.key}) {
    authController.initUserSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            themeController.isDarkMode ? Colors.black : Colors.redAccent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeController.isDarkMode ? Colors.white : Colors.black54,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Mon Panier',
          style: TextStyle(
            color: themeController.isDarkMode ? Colors.white : Colors.black54,
          ),
        ),
        elevation: 0,
      ),
      body: GetBuilder<CartController>(
        builder: (controller) {
          if (controller.isCartEmpty()) {
            return _buildEmptyCart();
          } else {
            return _buildCartItems(controller);
          }
        },
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircleAvatar(
            backgroundImage:
                AssetImage('assets/images/Empty_shopping_cart.png'),
            radius: 100,
          ),
          const SizedBox(height: 10),
          Text(
            'Votre panier est vide, aucun produit ajouté',
            style: TextStyle(
              fontSize: 18,
              color: themeController.isDarkMode ? Colors.white : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItems(CartController controller) {
    return ListView.builder(
      itemCount: controller.getItems.length,
      itemBuilder: (context, index) {
        final cartItem = controller.getItems[index];
        return _buildCartItem(cartItem, controller);
      },
    );
  }

  Widget _buildCartItem(cartItem, CartController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 6.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: themeController.isDarkMode ? Colors.black54 : Colors.white,
        border: Border.all(
            color:
                themeController.isDarkMode ? Colors.redAccent : Colors.black54,
            width: 1.0),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            margin: const EdgeInsets.only(right:10),
            child: CircleAvatar(
              radius: 50,
              backgroundImage:
                  NetworkImage("${AppConstant.baseUrl}/${cartItem.image}"),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cartItem.name ?? "",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black54,
                  ),
                ),
                Text('Prix: ${cartItem.price}Dhs',style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black54,
                  ),),
                Text(
                    'Total: ${formatTotalPrice(cartItem.price!, cartItem.quantity!)}',style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black54,
                  ),),
              ],
            ),
          ),
          _buildQuantityControls(cartItem, controller),
        ],
      ),
    );
  }

  Widget _buildQuantityControls(cartItem, CartController controller) {
    return Column(
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove, color: Colors.redAccent),
              onPressed: () => controller.decreaseQuantity(cartItem.product!),
            ),
            Text(
              '${cartItem.quantity}',
              style: TextStyle(
                fontSize: 14, // Réduire la taille de la police
                fontWeight: FontWeight.normal,
                color:
                    themeController.isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add, color: Colors.redAccent),
              onPressed: () => controller.increaseQuantity(cartItem.product!),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () => controller.removeItem(cartItem.product!),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return BottomAppBar(
      color: themeController.isDarkMode ? Colors.black : Colors.white,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        child: GetBuilder<CartController>(
          builder: (controller) {
            if (controller.isCartEmpty()) return const SizedBox.shrink();
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ${controller.totalAmount}Dhs',
                  style: TextStyle(
                    fontSize: 14, // Réduire la taille de la police
                    fontWeight: FontWeight.normal,
                    color: themeController.isDarkMode
                        ? Colors.white
                        : Colors.black87,
                  ),
                ),
                ElevatedButton(
                  onPressed: _onCheckoutPressed,
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
                  child: const Text('Commander'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onCheckoutPressed() async {
    if (authController.userLoggedIn()) {
      Get.toNamed('/checkout', arguments: {
        'user': authController.user,
        'addresses': await addressController
            .fetchAddressForUser(userController.userModel.id!),
      });
    } else {
      Get.toNamed('/login', arguments: {'redirectTo': '/checkout'})
          ?.then((_) => Get.back());
    }
  }
}
