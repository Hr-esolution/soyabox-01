import 'package:flutter/material.dart';
import 'package:soyabox/controllers/category_controller.dart';
import 'package:soyabox/models/product_model.dart';

import 'package:soyabox/widgets/product_card.dart';
import 'package:get/get.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final CategoryController categoryController = Get.find<CategoryController>();
  List<Product> products = [];
  @override
  void initState() {
    super.initState();
    // Load products for the first category by default
    if (categoryController.categories.isNotEmpty) {
      categoryController.selectCategory(categoryController.categories.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54.withOpacity(0.7),
        title: Center(
          child: Text(
            "Menu",
            style: TextStyle(color: Colors.orange.withOpacity(0.7)),
          ),
        ),
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              // List of categories
              SizedBox(
                height: 45,
                child: GetBuilder<CategoryController>(
                  builder: (controller) {
                    if (controller.categories.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.categories.length,
                      itemBuilder: (context, index) {
                        final category = controller.categories[index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              products = category.products;
                            });
                          },
                          child: Container(
                            width: 100,
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 1, color: Colors.black26),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                category.name,
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Products based on selected category
              Expanded(
                child: GetBuilder<CategoryController>(
                  builder: (controller) {
                    final products = controller.products;
                    if (products.isEmpty) {
                      return const Center(child: Text("No products available"));
                    }
                    return GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          product: products[index],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
