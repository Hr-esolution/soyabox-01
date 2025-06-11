import 'package:flutter/material.dart';
import 'package:soyabox/controllers/category_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:soyabox/screen/foods/product_details_page.dart';
import 'package:soyabox/utils/app_constant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';

class CarouselWidget extends StatefulWidget {
  const CarouselWidget({super.key});

  @override
  State<CarouselWidget> createState() => _CarouselWidgetState();
}

class _CarouselWidgetState extends State<CarouselWidget> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    Get.find<CategoryController>().fetchCategoryAssortiments();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CategoryController>(
      builder: (controller) {
        final themeController = Get.find<ThemeController>();

        if (!controller.isAssortimentLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.assortimentProducts.isEmpty) {
          return const Center(child: Text('No assortiments available'));
        }

        return Column(
          children: [
            CarouselSlider(
              options: CarouselOptions(
                height: 210,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              items: controller.assortimentProducts.map((product) {
                return GestureDetector(
                  onTap: () {
                    Get.to(() => ProductDetailsPage(
                          product: product,
                          page: 'carousel',
                          productName: product.name,
                        ));
                  },
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: themeController.isDarkMode
                                ? Colors.redAccent
                                : Colors.redAccent,
                            width: 2.0,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(7),
                          child: CachedNetworkImage(
                            imageUrl: '${AppConstant.baseUrl}/${product.image}',
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Container(
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, top: 3, bottom: 3),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            product.name
                                .toUpperCase(), // Convertir le texte en majuscules
                            style: TextStyle(
                              color: themeController.isDarkMode
                                  ? Colors.white
                                  : Colors.redAccent,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  List.generate(controller.assortimentProducts.length, (index) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 5.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? (themeController.isDarkMode
                            ? Colors.redAccent
                            : Colors.redAccent)
                        : (themeController.isDarkMode
                            ? Colors.grey
                            : Colors.grey[400]),
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }
}
