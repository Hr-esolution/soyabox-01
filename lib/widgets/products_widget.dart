import 'package:flutter/material.dart';
import 'package:soyabox/controllers/product_controller.dart';
import 'package:soyabox/widgets/product_card.dart';
import 'package:get/get.dart';

class ProductsWidget extends StatelessWidget {
  ProductsWidget({super.key});

  final ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductController>(
      builder: (controller) {
        if (!controller.isLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.7, // Adjust as needed
          ),
          itemCount: controller.productList.length,
          itemBuilder: (context, index) {
            final product = controller.productList[index];
            return ProductCard(product: product);
          },
        );
      },
    );
  }
}
