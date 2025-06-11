import 'package:soyabox/models/category_model.dart';

class Product {
  int id;
  String name;
  num price; // Change type to 'num' to handle both int and double
  String? offer;
  String description;
  int categoryId;
  String image;
  DateTime createdAt;
  DateTime? updatedAt;
  Category? category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.offer,
    required this.description,
    required this.categoryId,
    required this.image,
    required this.createdAt,
    required this.updatedAt,
    this.category,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: json['price'] is String
          ? num.parse(json['price'])
          : json['price'] as num,
      offer: json['offer'] != null ? json['offer'] as String : null,
      description: json['description'] as String,
      categoryId: json['category_id'] as int,
      image: json['image'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null, 
      category: json['category'] != null
          ? Category.fromJson(json['category'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'offer': offer,
      'description': description,
      'category_id': categoryId,
      'image': image,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt!.toIso8601String(),
      'category': category?.toJson(),
    };
  }
}
