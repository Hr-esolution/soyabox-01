import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:soyabox/controllers/cart_controller.dart';
import 'package:soyabox/controllers/category_controller.dart';
import 'package:soyabox/controllers/favorites_controller.dart';
import 'package:soyabox/controllers/product_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:soyabox/models/category_model.dart';
import 'package:soyabox/models/product_model.dart';
import 'package:soyabox/screen/auth/profile_page.dart';
import 'package:soyabox/screen/cart/cart_page.dart';
import 'package:soyabox/screen/home_page.dart';
import 'package:soyabox/utils/app_constant.dart';
import 'package:soyabox/widgets/category_grid.dart';
import 'package:soyabox/widgets/favorites_page.dart';
import 'package:get/get.dart';

class MainScreen extends StatefulWidget {
  final ThemeController themeController = Get.find<ThemeController>();
  MainScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final ThemeController themeController = Get.find<ThemeController>();
  final CategoryController categoryController = Get.find<CategoryController>();
  bool _isPopupShown = false;

  final List<Widget> _pages = [
    HomePage(category: Get.arguments as Category?),
    CategoryGridPage(category: Get.arguments as Category?),
    CartPage(),
    const FavoritesPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _fetchAndShowDailyOffer();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Logique pour gérer les notifications en arrière-plan
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      // Logique pour gérer les notifications quand l'app est ouverte via une notif
    });
  }

  Future<void> _fetchAndShowDailyOffer() async {
    await categoryController.fetchDailyOffer();

    if (categoryController.assortimentProducts.isNotEmpty && !_isPopupShown) {
      _isPopupShown = true;
      _showDailyOfferPopup(categoryController.assortimentProducts.first);
    }
  }

  void _showDailyOfferPopup(Product product) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Stack(
            children: [
              // Conteneur principal avec l'image en fond
              Container(
                width: 400,
                height: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      '${AppConstant.baseUrl}/${product.image}',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Prix affiché en haut
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "${product.price} Dhs",
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    // Détails du produit
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.7),
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            product.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(color: Colors.white70),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          // Boutons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                label: const Text(
                                  "Passer", // Texte du bouton
                                  style: TextStyle(
                                      color: Colors.white), // Couleur du texte
                                ),
                                style: TextButton.styleFrom(
                                  backgroundColor:
                                      Colors.redAccent, // Couleur de fond
                                ),
                              ),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                ),
                                onPressed: () {
                                  Get.find<ProductController>()
                                      .addItem(product, 1);
                                  Navigator.of(context).pop();
                                  Get.snackbar(
                                    "Succès", // Titre du snack
                                    "${product.name} ajouté au panier !", // Message du snack
                                    snackPosition: SnackPosition
                                        .BOTTOM, // Position du snack (en bas)
                                    backgroundColor: Colors
                                        .redAccent, // Couleur de fond du snack
                                    colorText: Colors.white, // Couleur du texte
                                    borderRadius: 10.0, // Bord arrondi
                                    margin: const EdgeInsets.all(
                                        10), // Marge autour du snack
                                    padding: const EdgeInsets.all(
                                        15), // Padding interne
                                    icon: const Icon(
                                      Icons.check_circle, // Icône de validation
                                      color: Colors.white, // Couleur de l'icône
                                    ),
                                  );
                                },
                                label: const Text(
                                  "Ajouter au panier", // Texte du bouton
                                  style: TextStyle(
                                      color: Colors.white), // Couleur du texte
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Bouton de fermeture en haut à gauche
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: GetBuilder<ThemeController>(
        builder: (themeController) {
          final borderColor = themeController.isDarkMode
              ? Colors.redAccent
              : Colors.redAccent[800] ?? Colors.redAccent;

          return Container(
            
            decoration: BoxDecoration(
            
              border: Border.all(color: borderColor, width: 0.5),
            ),
            child: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: _buildIcon(Icons.home, isSelected: _selectedIndex == 0,themeController: themeController),
                  label: 'Accueil',
                ),
                BottomNavigationBarItem(
                  icon: _buildIcon(Icons.list, isSelected: _selectedIndex == 1,themeController: themeController),
                  label: 'Menu',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _buildIcon(Icons.shopping_cart,
                          isSelected: _selectedIndex == 2,themeController: themeController),
                      if (_selectedIndex != 2)
                        GetBuilder<CartController>(
                          builder: (cartController) {
                            return cartController.totalItems > 0
                                ? Positioned(
                                    left: 15,
                                    bottom: 10,
                                    child:
                                        _buildBadge(cartController.totalItems),
                                  )
                                : const SizedBox();
                          },
                        ),
                    ],
                  ),
                  label: 'Panier',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _buildIcon(Icons.favorite,
                          isSelected: _selectedIndex == 3,themeController: themeController),
                      if (_selectedIndex != 3)
                        GetBuilder<FavoritesController>(
                          builder: (favoritesController) {
                            return favoritesController.totalFavorites > 0
                                ? Positioned(
                                    left: 15,
                                    bottom: 10,
                                    child: _buildBadge(
                                        favoritesController.totalFavorites),
                                  )
                                : const SizedBox();
                          },
                        ),
                    ],
                  ),
                  label: 'Favoris',
                ),
                BottomNavigationBarItem(
                  icon:
                      _buildIcon(Icons.person, isSelected: _selectedIndex == 4,themeController: themeController,),
                  label: 'Profil',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: themeController.isDarkMode
                  ? Colors.redAccent
                  : Colors.redAccent[800] ?? Colors.redAccent,
              unselectedItemColor:
                  themeController.isDarkMode ? Colors.white70 : Colors.black38,
              backgroundColor:
                  themeController.isDarkMode ? Colors.black : Colors.white,
              type: BottomNavigationBarType.fixed,
              elevation: 8,
              onTap: _onItemTapped,
            ),
          );
        },
      ),
    );
  }

  Widget _buildIcon(IconData iconData,
      {required bool isSelected, required ThemeController themeController}) {
    return Container(
      padding: EdgeInsets.all(isSelected
          ? 8
          : 0), // Adjust the padding to make the icon bigger when selected
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isSelected
            ? (themeController.isDarkMode
                ? Colors.redAccent
                    .withOpacity(0.2) // Light background for selected item
                : Colors.redAccent[800]?.withOpacity(0.2) ??
                    Colors.redAccent.withOpacity(0.2))
            : Colors.transparent,
      ),
      child: Icon(
        iconData,
        size: isSelected ? 30 : 22, // Bigger size for selected icon
        color: isSelected
            ? (themeController.isDarkMode
                ? Colors.redAccent
                : Colors.redAccent[800] ?? Colors.redAccent)
            : (themeController.isDarkMode ? Colors.white54 : Colors.black38),
      ),
    );
  }

  Widget _buildBadge(int count) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child: Text(
        '$count',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
