import 'package:flutter/material.dart';
import 'package:soyabox/controllers/category_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:soyabox/models/product_model.dart';
import 'package:soyabox/widgets/persiste_bottombar.dart';
import 'package:soyabox/widgets/product_card.dart';
import 'package:get/get.dart';

class CategoryProductsPage extends StatefulWidget {
  final int initialCategoryId;
  final String initialCategoryName;

  const CategoryProductsPage({
    super.key,
    required this.initialCategoryId,
    required this.initialCategoryName,
  });

  @override
  // ignore: library_private_types_in_public_api
  _CategoryProductsPageState createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  final ThemeController themeController = Get.find<ThemeController>();
  final CategoryController categoryController = Get.find<CategoryController>();

  late int selectedCategoryId;
  late String selectedCategoryName;
  late Future<List<Product>> productsFuture;

  @override
  void initState() {
    super.initState();
    selectedCategoryId = widget.initialCategoryId;
    selectedCategoryName = widget.initialCategoryName;
    productsFuture = categoryController.fetchProductsForCategory(selectedCategoryId);
  }

  void _changeCategory(int categoryId, String categoryName) {
    setState(() {
      selectedCategoryId = categoryId;
      selectedCategoryName = categoryName;
      productsFuture = categoryController.fetchProductsForCategory(categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: themeController.isDarkMode ? Colors.white : Colors.black54,
          ),
          onPressed: () => Get.back(),
        ),
        elevation: 1,
        backgroundColor: themeController.isDarkMode ? Colors.black : Colors.white,
        title: Text(
          selectedCategoryName, // Affichage du nom de la catégorie sélectionnée
          style: TextStyle(
            color: themeController.isDarkMode ? Colors.white : Colors.black54,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Liste horizontale des catégories
          GetBuilder<CategoryController>(
            builder: (controller) {
              if (!controller.isLoaded) {
                return const Center(child: CircularProgressIndicator());
              }

              return SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.categories.length,
                  itemBuilder: (context, index) {
                    final category = controller.categories[index];
                    final isSelected = category.id == selectedCategoryId;

                    return GestureDetector(
                      onTap: () {
                        _changeCategory(category.id, category.name);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        margin: const EdgeInsets.symmetric(horizontal: 6),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.redAccent : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.redAccent, width: 1),
                        ),
                        child: Center(
                          child: Text(
                            category.name,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.redAccent,
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

          const SizedBox(height: 10),

          // Affichage des produits de la catégorie sélectionnée
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Aucun produit disponible pour cette catégorie.'));
                } else {
                  return GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final product = snapshot.data![index];
                      return ProductCard(product: product);
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
       bottomNavigationBar: PersistentBottomBar(),
    );
  }
}
