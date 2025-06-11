import 'package:soyabox/data/category_repo.dart';
import 'package:soyabox/models/category_model.dart';
import 'package:soyabox/models/product_model.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  final CategoryRepo categoryRepo;

  // List of categories and products
  final RxList<Category> categories = <Category>[].obs;
  final RxList<Product> assortimentProducts = <Product>[].obs;
  bool _isAssortimentLoaded = false;
  bool get isAssortimentLoaded => _isAssortimentLoaded;
  // Selected category
  Rx<Category?> selectedCategory = Rx<Category?>(null);

  // To check if the data is loaded
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  CategoryController({required this.categoryRepo});

  @override
  void onInit() {
    super.onInit();
    loadCategories();
    fetchCategoryAssortiments();
  }

  Future<void> fetchCategoryAssortiments() async {
    try {
      final response = await categoryRepo.getCategoryAssortiments();
      if (response.statusCode == 200 && response.body != null) {
        final List<dynamic> jsonData = response.body;
        List<Product> productList = jsonData
            .map((productJson) =>
                Product.fromJson(productJson as Map<String, dynamic>))
            .toList();
        assortimentProducts.assignAll(productList);
        _isAssortimentLoaded = true;
        update();
      } else {
       
      }
    // ignore: empty_catches
    } catch (e) {
      
    }
  }
  Future<void> fetchDailyOffer() async {
    try {
      final response = await categoryRepo.getDailyOffer();
      if (response.statusCode == 200 && response.body != null) {
        final List<dynamic> jsonData = response.body;
        List<Product> productList = jsonData
            .map((productJson) =>
                Product.fromJson(productJson as Map<String, dynamic>))
            .toList();
        assortimentProducts.assignAll(productList);
        _isAssortimentLoaded = true;
        update();
      } else {
       
      }
    // ignore: empty_catches
    } catch (e) {
      
    }
  }


  Future<void> loadCategories() async {
    try {
      final response = await categoryRepo.getCategoriesList();
      if (response.statusCode == 200 && response.body != null) {
        final List<dynamic> jsonData = response.body;
        List<Category> categoryList = jsonData
            .map((categoryJson) => Category.fromJson(categoryJson))
            .toList();
        categories.assignAll(categoryList);
        _isLoaded = true;
        update();
      } 
    // ignore: empty_catches
    } catch (e) {
      
    }
  }

  final RxList<Product> products = <Product>[].obs;
  Future<List<Product>> fetchProductsForCategory(int categoryId) async {
    try {
      final response = await categoryRepo.getProductsForCategory(categoryId);

      // Debugging: Print the raw response
    

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = response.body;

        // ignore: unnecessary_type_check
        if (jsonData is List) {
          List<Product> productList = jsonData
              .map((productJson) =>
                  Product.fromJson(productJson as Map<String, dynamic>))
              .toList();
          products.assignAll(productList);
          return productList; // Return the fetched products
        } else {
         
          products.clear();
          return []; // Return an empty list in case of incorrect data
        }
      } else {
       
        products.clear();
        return []; // Return an empty list in case of API error
      }
    } catch (e) {
    
      products.clear();
      return []; // Return an empty list in case of an exception
    }
  }

  // Selects a category and fetches its products
  void selectCategory(Category category) {
    selectedCategory.value = category;
    fetchProductsForCategory(
        category.id); // Fetch products for the selected category
  }
}
