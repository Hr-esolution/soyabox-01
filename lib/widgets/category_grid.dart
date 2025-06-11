import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:soyabox/controllers/category_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:soyabox/models/category_model.dart';
import 'package:soyabox/screen/foods/category_products_page.dart';
import 'package:soyabox/utils/app_constant.dart';
import 'package:soyabox/widgets/persiste_bottombar.dart';
import 'package:get/get.dart';

class CategoryGridPage extends StatelessWidget {
  final Category? category;
  final CategoryController categoryController = Get.find<CategoryController>();
  final ThemeController themeController = Get.find<ThemeController>();

  CategoryGridPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeController.isDarkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeController.isDarkMode ? Colors.white : Colors.black54,
          ),
          onPressed: () => Get.back(),
        ),
        backgroundColor:
            themeController.isDarkMode ? Colors.black54 : Colors.redAccent,
        title: Text(
          'Menu Soya',
          style: TextStyle(
            color: themeController.isDarkMode ? Colors.white : Colors.black54,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height:10),
          // Liste horizontale des catégories
          GetBuilder<CategoryController>(
            builder: (controller) {
              if (!controller.isLoaded) {
                return const Center(child: CircularProgressIndicator());
              }

              return SizedBox(
                height: 40, // Hauteur de la barre des catégories
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => CategoryProductsPage(
                              initialCategoryId: category.id,
                              initialCategoryName: category.name,
                            ));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode
                              ? Colors.black54
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.redAccent,
                              width: 1), // Bordure rouge
                        ),
                        child: Center(
                          child: Text(
                            category.name,
                            style:  TextStyle(
                               color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black54, // Texte rouge sushi 🍣
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),

          // Espacement entre la barre des catégories et la grille
         // const SizedBox(height: 5),

          // GridView des catégories
          Expanded(
            child: GetBuilder<CategoryController>(
              builder: (controller) {
                if (!controller.isLoaded) {
                  return const Center(child: CircularProgressIndicator());
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    return GestureDetector(
                      onTap: () {
                        Get.to(() => CategoryProductsPage(
                              initialCategoryId: category.id,
                              initialCategoryName: category.name,
                            ));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(
                            color: themeController.isDarkMode
                                ? Colors.redAccent
                                : Colors.transparent,
                            width: 1.0,
                          ),
                        ),
                        child: Card(
                          elevation: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${AppConstant.baseUrl}/${category.image}",
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  category.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: themeController.isDarkMode
                                        ? Colors.redAccent
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: PersistentBottomBar(),
    );
  }
}
