import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:soyabox/controllers/auth_controller.dart';
import 'package:soyabox/controllers/product_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:soyabox/models/category_model.dart';
import 'package:soyabox/widgets/all_products.dart';
import 'package:soyabox/widgets/caroussel_widget.dart';
import 'package:soyabox/widgets/category_list.dart';
import 'package:soyabox/widgets/most_selled_widget.dart';
import 'package:soyabox/widgets/persiste_bottombar.dart';
import 'package:soyabox/widgets/product_card.dart';
import 'package:get/get.dart';
import 'package:soyabox/api/Network_service.dart'; // Import the NetworkService

class HomePage extends StatefulWidget {
  final Category? category;

  const HomePage({super.key, this.category}); // Handle nullable category

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProductController productController = Get.find<ProductController>();
  final AuthController authController = Get.find<AuthController>();
  final NetworkService networkService =
      NetworkService(); // Initialize NetworkService

  @override
  void initState() {
    super.initState();
    // Start monitoring connection and trigger reload on restoration
    networkService.startMonitoringConnection(() {
      setState(() {
        // Optionally reload data
        productController.loadProducts();
      });
    });
  }

  @override
  void dispose() {
    // Stop monitoring connection when the widget is disposed
    networkService.stopMonitoringConnection();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      init: Get.find<ThemeController>(),
      builder: (themeController) {
        final isDarkMode = themeController.isDarkMode;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                // AppBar equivalent in body
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.black : Colors.white,
                    
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Navigate to the home page or wherever you want when logo is tapped
                          Get.toNamed('/home'); // Adjust the route as necessary
                        },
                        child: ClipOval(
                          child: Container(
                            color: Colors.transparent,
                            child: Image.asset(
                              'assets/images/logo.png', // Replace with your logo asset path
                              height: 60, // Set height as necessary
                              width:
                                  60, // Ensure width matches height for a circle
                              fit: BoxFit
                                  .cover, // Scale the image to cover the circle
                            ),
                          ),
                        ),
                      ),
                      FlutterSwitch(
                        value: themeController.isDarkMode,
                        onToggle: (value) {
                          themeController.toggleTheme();
                        },
                        activeColor: Colors.redAccent,
                        inactiveColor: Colors.black,
                        activeText: 'Dark',
                        inactiveText: 'Clair',
                        showOnOff: false,
                        width: 80.0,
                        height: 35.0,
                        borderRadius: 20.0,
                        toggleSize: 30.0,
                        activeTextColor: Colors.white,
                        inactiveTextColor: Colors.white,
                        // Add custom icons instead of text
                        activeIcon: const Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Icon(
                            Icons.dark_mode,
                            color: Colors.black,
                            size: 60,
                          ),
                        ),
                        inactiveIcon: const Padding(
                          padding: EdgeInsets.all(1.0),
                          child: Icon(
                            Icons.wb_sunny,
                            color: Colors.black,
                            size: 60,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          // Navigate to the add reservation page
                          Get.toNamed(
                              '/add-reservation'); // Change this route as necessary
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDarkMode
                              ? Colors.redAccent
                              : Colors.black, // Button background color
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8), // Optional: Adjust padding
                        ),
                        child: Text(
                          'Reserver une table', // Button text
                          style: TextStyle(
                            fontSize: 14, // Font size
                            fontWeight: FontWeight.normal, // Font weight
                            color: isDarkMode
                                ? Colors.white
                                : Colors.white, // Text color based on theme
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
               
                Expanded(
                  child: CustomScrollView(
                    slivers: [
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 240,
                          child: CarouselWidget(),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Categories",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.toNamed('/categoryGrid',
                                      arguments: widget.category);
                                },
                                child: Text(
                                  "voir tous",
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height:35,
                          child: CategoriesList(),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Les plus demandés",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.normal,
                                  color:
                                      isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.to(() => AllProductsPage());
                                },
                                child: Text(
                                  "voir tous",
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        
                          child: MostOrderedProductsWidget(),
                      
                      ),

                      GetBuilder<ProductController>(
                        builder: (controller) {
                          if (!controller.isLoaded) {
                            return const SliverToBoxAdapter(
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }

                          return SliverPadding(
                            padding: const EdgeInsets.only(left:8.0,right:8,),
                            sliver: SliverGrid(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 6.0,
                                mainAxisSpacing: 6.0,
                                childAspectRatio: 0.75,
                              ),
                              delegate: SliverChildBuilderDelegate(
                                (context, index) {
                                  final product = controller.productList[index];
                                  return ProductCard(product: product);
                                },
                                childCount: controller.productList.length,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: PersistentBottomBar(),
        );
      },
    );
  }
}
