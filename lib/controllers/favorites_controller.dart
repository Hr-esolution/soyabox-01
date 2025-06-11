import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soyabox/models/product_model.dart';

class FavoritesController extends GetxController {
  static const String _favoritesKey = 'favorites';

  final _favorites = <int>[].obs;
  List<int> get favorites => _favorites;

  var favoriteProducts = <Product>[].obs;
  List<Product> allProducts = []; // Initialize this list with products

  @override
  void onInit() {
    super.onInit();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList(_favoritesKey) ?? [];
    _favorites.value = favoriteIds.map((id) => int.parse(id)).toList();

    updateFavoriteProducts();
  }

  void updateFavoriteProducts() {
    if (allProducts.isEmpty) {
      return;
    }
    favoriteProducts.value = allProducts
        .where((product) => _favorites.contains(product.id))
        .toList();
  }

  Future<void> addFavorite(Product product) async {
    if (!_favorites.contains(product.id)) {
      _favorites.add(product.id);
      await _saveFavorites();
      updateFavoriteProducts();
      update(); // Notify listeners to rebuild widgets
    }
  }

  Future<void> removeFavorite(Product product) async {
    if (_favorites.contains(product.id)) {
      _favorites.remove(product.id);
      await _saveFavorites();
      updateFavoriteProducts();
      update(); // Notify listeners to rebuild widgets
    }
  }

  bool isFavorite(Product product) {
    return _favorites.contains(product.id);
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = _favorites.map((id) => id.toString()).toList();
    await prefs.setStringList(_favoritesKey, favoriteIds);
  }

  int get totalFavorites => favoriteProducts.length;
}
