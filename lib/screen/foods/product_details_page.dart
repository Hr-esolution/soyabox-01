import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:soyabox/controllers/cart_controller.dart';
import 'package:soyabox/controllers/favorites_controller.dart'; // Import for favorites controller
import 'package:soyabox/controllers/product_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:soyabox/models/product_model.dart';
import 'package:soyabox/screen/cart/cart_page.dart'; // Import for favorites page
import 'package:soyabox/utils/app_constant.dart';
import 'package:soyabox/utils/dimensions.dart';
import 'package:soyabox/widgets/favorites_page.dart';
import 'package:get/get.dart';

class ProductDetailsPage extends StatelessWidget {
  final String productName;
  final Product product;
  final String page;
  final ProductController productController = Get.find<ProductController>();

  ProductDetailsPage({
    super.key,
    required this.productName,
    required this.product,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    // Initialize product quantity in the controller
    productController.initProduct(product);

    return GetBuilder<ThemeController>(
      init: Get.find<ThemeController>(),
      builder: (themeController) {
        final isDarkMode = themeController.isDarkMode;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: isDarkMode ? Colors.black : Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            actions: [
              GetBuilder<FavoritesController>(builder: (favoritesController) {
                return Stack(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.favorite,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      onPressed: () {
                        Get.to(() => const FavoritesPage());
                      },
                    ),
                    if (favoritesController.totalFavorites > 0)
                      Positioned(
                        right: 4,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            favoritesController.totalFavorites.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
              GetBuilder<CartController>(builder: (cartController) {
                return Stack(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      onPressed: () {
                        Get.to(() => CartPage());
                      },
                    ),
                    if (cartController.totalItems > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            cartController.totalItems.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ],
          ),
          body: Padding(
            padding: EdgeInsets.all(Dimensions.height10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          10), // Adjust for rounded corners
                      child: CachedNetworkImage(
                        imageUrl: "${AppConstant.baseUrl}/${product.image}",
                        width: double.infinity, // Full width
                        height: 400, // Adjust height as needed
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: double.infinity,
                          height: 180,
                          color: isDarkMode
                              ? Colors.grey[800]
                              : Colors.grey.shade200,
                          child: Icon(
                            Icons.image,
                            size: 80,
                            color: isDarkMode
                                ? Colors.white70
                                : Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: SingleChildScrollView(
                        child: Container(
                          width: 80.0, // Set the width of the circle
                          height: 80.0, // Set the height of the circle
                          decoration: BoxDecoration(
                            color:
                                isDarkMode ? Colors.redAccent : Colors.redAccent,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: Padding(
                            padding: const EdgeInsets.all(
                                8.0), // Adjust the padding as needed
                            child: Text(
                              '${product.price} Dhs',
                              style: const TextStyle(
                                fontSize:
                                    20, // Adjust font size to fit the container
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Dimensions.height20),
                Padding(
                  padding: const EdgeInsets.only(left: 2, right: 2),
                  child: Text(
                    product.name,
                    style: TextStyle(
                      fontSize: Dimensions.font20,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height20),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: Dimensions.width10),
                      child: Text(
                        product.description,
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          color: isDarkMode ? Colors.white70 : Colors.black54,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GetBuilder<ProductController>(builder: (productController) {
                  final int productQuantity =
                      productController.getProductQuantity(product.id);

                  return Container(
                    padding: const EdgeInsets.only(top: 10, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.remove,
                                color: isDarkMode
                                    ? Colors.redAccent
                                    : Colors.redAccent,
                              ),
                              onPressed: () {
                                if (productQuantity > 0) {
                                  productController.setProductQuantity(
                                      product.id, productQuantity - 1);
                                }
                              },
                            ),
                            Container(
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.redAccent
                                    : Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                productQuantity.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.add,
                                color: isDarkMode
                                    ? Colors.redAccent
                                    : Colors.redAccent,
                              ),
                              onPressed: () {
                                if (productQuantity < 20) {
                                  productController.setProductQuantity(
                                      product.id, productQuantity + 1);
                                } else {
                                  Get.snackbar(
                                    "Quantité Maximale",
                                    "Vous ne pouvez pas ajouter plus de 20 articles de ce produit.",
                                    backgroundColor: Colors.redAccent,
                                    colorText: Colors.white,
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        SizedBox(
                          width: Dimensions.width30 * 3,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                isDarkMode
                                    ? Colors.redAccent
                                    : Colors.redAccent,
                              ),
                              foregroundColor: WidgetStateProperty.all(
                                Colors.white,
                              ),
                              padding: WidgetStateProperty.all(
                                EdgeInsets.symmetric(
                                    vertical: Dimensions.height15),
                              ),
                              shape: WidgetStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                            onPressed: () {
                              if (productQuantity > 0) {
                                productController.addItem(
                                    product, productQuantity);
                              } else {
                                Get.snackbar(
                                  "Erreur de Quantité",
                                  "Veuillez ajouter au moins un article.",
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                );
                              }
                            },
                            child: const Text(
                              "Ajouter au panier",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
            
          ),
          
        );
      },
    );
  }
}
