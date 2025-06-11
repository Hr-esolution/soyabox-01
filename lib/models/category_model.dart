import 'package:soyabox/models/product_model.dart';

class Category {
  final int id;
  final String name;
  final String image;
  final List<Product> products;

  Category({
    required this.id,
    required this.name,
    required this.image,
    required this.products,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      image: json['image'],
      products: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'products': products.map((product) => product.toJson()).toList(),
    };
  }
}
