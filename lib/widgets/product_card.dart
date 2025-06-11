import 'package:flutter/material.dart';
import 'package:soyabox/controllers/cart_controller.dart';
import 'package:soyabox/controllers/product_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:soyabox/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:soyabox/screen/foods/product_details_page.dart';
import 'package:soyabox/utils/app_constant.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ThemeController themeController = Get.find<ThemeController>();
  final CartController cartController = Get.find<CartController>();
  final ProductController productController = Get.find<ProductController>();

  ProductCard({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (productController) {
        final isFavorited = productController.isProductFavorite(product);

        return GestureDetector(
          onTap: () {
            Get.to(() => ProductDetailsPage(
                  product: product,
                  page: '',
                  productName: '',
                ));
          },
          child: Container(
            padding: const EdgeInsets.all(1.0),
            margin: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: themeController.isDarkMode
                  ? Colors.transparent
                  : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: themeController.isDarkMode
                      ? Colors.transparent
                      : Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section
                Container(
                  height: 180, // Taille fixe de l'image
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(
                          '${AppConstant.baseUrl}/${product.image}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Badge d'offre (si présente)
                      if (product.offer != null && product.offer!.isNotEmpty)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 4.0),
                            decoration: BoxDecoration(
                              color: themeController.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              product.offer!,
                              style: TextStyle(
                                color: themeController.isDarkMode
                                    ? Colors.redAccent
                                    : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      // Icônes de favoris et panier
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // Favoris
                            GestureDetector(
                              onTap: () {
                                productController.toggleFavorite(product);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isFavorited
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: isFavorited
                                      ? Colors.redAccent
                                      : (themeController.isDarkMode
                                          ? Colors.redAccent
                                          : Colors.white),
                                  size: 18,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Panier
                            GestureDetector(
                              onTap: () {
                                if (productController
                                    .isProductInCart(product)) {
                                  productController.removeItem(product);
                                } else {
                                  productController.addItem(product, 1);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6.0),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  productController.isProductInCart(product)
                                      ? Icons.check_circle
                                      : Icons.shopping_cart,
                                  color:
                                      productController.isProductInCart(product)
                                          ? (themeController.isDarkMode
                                              ? Colors.redAccent
                                              : Colors.redAccent)
                                          : (themeController.isDarkMode
                                              ? Colors.redAccent
                                              : Colors.white),
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Row avec le nom et le prix du produit
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Nom du produit
                      Flexible(
                        child: Text(
                          product.name,
                          style: TextStyle(
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Prix du produit
                      Text(
                        '${NumberFormat.currency(locale: 'fr_FR', symbol: '').format(product.price)} Dhs',
                        style: TextStyle(
                          color: themeController.isDarkMode
                              ? Colors.redAccent
                              : Colors.redAccent,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
