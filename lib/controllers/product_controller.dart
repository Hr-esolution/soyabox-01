import 'dart:convert';

import 'package:soyabox/controllers/cart_controller.dart';
import 'package:soyabox/controllers/favorites_controller.dart';
import 'package:soyabox/data/product_repo.dart';
import 'package:soyabox/models/cart_model.dart';
import 'package:soyabox/models/product_model.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  final ProductRepo productRepo;
  final FavoritesController favoritesController =
      Get.find<FavoritesController>();
  // ignore: prefer_final_fields
  RxList<Product> _productList = <Product>[].obs;
  final RxList<Product> _mostOrderedProducts = <Product >[].obs;
  // ignore: prefer_final_fields
  RxBool _isLoaded = false.obs;

  // Accessor for the UI
  List<Product> get productList => _productList;
  List<Product> get mostOrderedProducts => _mostOrderedProducts;
  bool get isLoaded => _isLoaded.value;

  late CartController _cart;
  RxMap<int, int> productQuantities = RxMap<int, int>();
  int _quantity = 0;

  int get quantity => _quantity;
  int _inCartItems = 0;
  int get inCartItems => _inCartItems + _quantity;
 

  ProductController({required this.productRepo});

  @override
  void onInit() {
    super.onInit();
    loadProducts();
    fetchMostOrderedProducts();
    _cart = Get.find<CartController>();
   
    favoritesController.allProducts = _productList;
  }


// Import nécessaire pour jsonDecode

Future<void> fetchMostOrderedProducts() async {
  try {
    final response = await productRepo.getMostselled();
    
    final Map<String, dynamic> responseData = response.body is String
        ? jsonDecode(response.body)
        : response.body;

    if (responseData.containsKey('data') && responseData['data'] is List) {
      final List<dynamic> mostOrderedProductsJson = responseData['data'];
      _mostOrderedProducts.value = mostOrderedProductsJson
          .map((data) => Product.fromJson(data))
          .toList();
    } else {
   
      _mostOrderedProducts.value = [];
    }

    _isLoaded.value = true;
  } catch (e) {
   
    _isLoaded.value = false;
  }

  update();
}



  Future<void> loadProducts() async {
    try {
      final response = await productRepo.getProductsList();
      if (response.statusCode == 200) {
        final List<dynamic> productListJson = response.body;
        _productList.value =
            productListJson.map((data) => Product.fromJson(data)).toList();

        _isLoaded.value = true;
    
        update();
      } else {
        _isLoaded.value = false;
      }
    } catch (e) {
      _isLoaded.value = false;
    }
  }

  // Other methods (setProductQuantity, setQuantity, addItem, etc.) remain the same...
  void setProductQuantity(int productId, int quantity) {
    productQuantities[productId] = quantity;
    update();
  }

  int getProductQuantity(int productId) {
    return productQuantities[productId] ?? 0;
  }

  void setQuantity(bool isIncrement) {
    if (isIncrement) {
      _quantity = checkQuantity(_quantity + 1);
    } else {
      _quantity = checkQuantity(_quantity - 1);
    }
    update();
  }

  int checkQuantity(int quantity) {
    if (quantity < 0) {
      return 0;
    } else if (quantity > 20) {
      // Assuming max quantity is 20
      return 20;
    } else {
      return quantity;
    }
  }

  void addItem(Product product, int quantity) {
    _cart.addItem(product, quantity);
    _inCartItems = _cart.getQuantity(product);

    if (quantity == 0) {
      // If the quantity is 0, remove the item from the cart.
    }

    update();
  }

  int get totalItems {
    return _cart.totalItems;
  }

  List<CartModel> get getItems {
    return _cart.getItems;
  }

  void initProduct(Product product) {
    _quantity = 0;
    _inCartItems = _cart.getQuantity(product);
    _quantity = _inCartItems; // Set the quantity to the value in the cart
  }

  bool isProductInCart(Product product) {
    return _cart.existInCart(product);
  }

  void removeItem(Product product) {
    _cart.removeItem(product);
    _inCartItems = _cart.getQuantity(product);
    update();
  }

  void toggleFavorite(Product product) {
    if (favoritesController.isFavorite(product)) {
      favoritesController.removeFavorite(product);
    } else {
      favoritesController.addFavorite(product);
    }
    update();
  }

  bool isProductFavorite(Product product) {
    return favoritesController.isFavorite(product);
  }
}
