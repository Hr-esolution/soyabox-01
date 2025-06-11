import 'package:flutter/material.dart';
import 'package:soyabox/controllers/cart_controller.dart';
import 'package:soyabox/controllers/favorites_controller.dart';
import 'package:soyabox/controllers/product_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:soyabox/utils/app_constant.dart';
import 'package:soyabox/widgets/persiste_bottombar.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<FavoritesController>(
      builder: (favoritesController) {
        final ThemeController themeController = Get.find<ThemeController>();
        final CartController cartController = Get.find<CartController>();
        final ProductController productController =
            Get.find<ProductController>();

        // Ensure favorite products are being updated
        favoritesController.updateFavoriteProducts();

        return Scaffold(
          appBar: AppBar(
            backgroundColor:
                 themeController.isDarkMode ? Colors.black : Colors.redAccent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color:
                    themeController.isDarkMode ? Colors.white : Colors.black54,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            title: Text(
              'Mes Favoris',
              style: TextStyle(
                color:
                    themeController.isDarkMode ? Colors.white : Colors.black54,
              ),
            ),
            elevation: 0,
          ),
          body: favoritesController.favoriteProducts.isEmpty
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: themeController.isDarkMode
                              ? Colors.redAccent
                              : Colors.black,
                          width: 3.0,
                        ),
                      ),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/favoris.png',
                        ),
                        radius: 100,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Aucun Produit Favoris !',
                        style: TextStyle(
                          fontSize: 18,
                          color: themeController.isDarkMode
                              ? Colors.white
                              : Colors.black54,
                        ),
                      ),
                    ),
                  ],
                )
              : ListView.builder(
                  itemCount: favoritesController.favoriteProducts.length,
                  itemBuilder: (context, index) {
                    final product = favoritesController.favoriteProducts[index];
                    bool isInCart = productController.isProductInCart(product);

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 6.0, horizontal: 6.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: themeController.isDarkMode
                            ? Colors.black54
                            : Colors.white,
                        border: Border.all(
                          color: themeController.isDarkMode
                              ? Colors.redAccent
                              : Colors.black54,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: themeController.isDarkMode
                                        ? Colors.redAccent
                                        : Colors.black54,
                                    width: 1.0,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                    "${AppConstant.baseUrl}/${product.image}",
                                  ),
                                ),
                              ),
                              if (isInCart)
                                Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4.0, horizontal: 8.0),
                                    decoration: const BoxDecoration(
                                      color: Colors.redAccent,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(8.0),
                                      ),
                                    ),
                                    child: const Text(
                                      'ajouté',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 3.0, vertical: 3.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: themeController.isDarkMode
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                  ),
                                  Text(
                                    '${NumberFormat.currency(locale: 'fr_FR', symbol: '').format(product.price)} Dhs',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: themeController.isDarkMode
                                          ? Colors.white
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  if (isInCart) {
                                    // Handle the case when the product is already in the cart, if needed
                                  } else {
                                    cartController.addItem(product, 1);
                                    favoritesController
                                        .update(); // Notify FavoritesController of the change
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    themeController.isDarkMode
                                        ? Colors.redAccent
                                        : Colors.black54,
                                  ),
                                  foregroundColor: WidgetStateProperty.all(
                                    themeController.isDarkMode
                                        ? Colors.white
                                        : Colors.redAccent,
                                  ),
                                  padding: WidgetStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        horizontal: 16.0, vertical: 12.0),
                                  ),
                                  shape: WidgetStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  elevation: WidgetStateProperty.all(4.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      isInCart
                                          ? Icons.check
                                          : Icons.shopping_cart,
                                      color: themeController.isDarkMode
                                          ? Colors.white
                                          : Colors.redAccent,
                                    ),
                                    const SizedBox(width: 8.0),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  favoritesController.removeFavorite(product);
                                },
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                   bottomNavigationBar: PersistentBottomBar(),
        );
      },
    );
  }
}
