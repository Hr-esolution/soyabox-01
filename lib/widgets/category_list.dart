import 'package:flutter/material.dart';
import 'package:soyabox/controllers/category_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:soyabox/screen/foods/category_products_page.dart';

import 'package:get/get.dart';

class CategoriesList extends StatelessWidget {
  CategoriesList({super.key});

  final CategoryController categoryController = Get.find<CategoryController>();
  final ThemeController themeController = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100, // Adjust the height as needed
      child: GetBuilder<CategoryController>(
        builder: (controller) {
          if (!controller.isLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          // Use the AppTheme methods for consistent color usage

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];

              return Padding(
                padding: const EdgeInsets.only(left: 5, right: 5),
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => CategoryProductsPage(
                            initialCategoryId: category.id,
                            initialCategoryName: category.name,
                          ));
                    },
                    child: Container(
                      width: 100, // Adjust the width as needed
                      height: 40, // Adjust the height as needed
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: themeController.isDarkMode
                              ? Colors.redAccent
                              : Colors.black, // Use border color from theme
                          width: 1,
                        ),
                        color: Colors.transparent, // Remove background color
                      ),
                      child: Center(
                        child: Text(
                          category.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black54, // Use text color from theme
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
