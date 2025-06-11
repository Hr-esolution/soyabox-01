import 'package:flutter/material.dart';
import 'package:soyabox/utils/app_constant.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:soyabox/controllers/product_controller.dart';
import 'package:soyabox/screen/foods/product_details_page.dart';

class MostOrderedProductsWidget extends StatelessWidget {
  const MostOrderedProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
  // Ajout du ThemeController

    return GetBuilder<ProductController>(builder: (controller) {
      return !controller.isLoaded
          ? const Center(child: CircularProgressIndicator())
          : SizedBox(
              height: 115,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.mostOrderedProducts.length,
                itemBuilder: (context, index) {
                  final product = controller.mostOrderedProducts[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => ProductDetailsPage(
                          product: product,
                          page: '',
                          productName: product.name,
                        ),
                        transition: Transition.fadeIn,
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6.0),
                      child: Column(
                        children: [
                          ClipOval(
                            child: CachedNetworkImage(
                              imageUrl:
                                  '${AppConstant.baseUrl}/${product.image}',
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(
                                  Icons.image_not_supported,
                                  size: 80),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            product.name,
                            style: const TextStyle(
                              color:  Colors.redAccent, // Utilisation du mode sombre
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
    });
  }
}
