import 'package:soyabox/models/product_model.dart';

class CartModel {
  int? id;
  String? name;
  double? price;
  String? image;
  int? quantity;
  bool? isExist;
  String? time;
  Product? product;

  CartModel({
    this.id,
    this.name,
    this.price,
    this.image,
    this.isExist,
    this.quantity,
    this.time,
    this.product,
    required Map productData,
  });

  CartModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price =
        json['price'] != null ? double.parse(json['price'].toString()) : null;
    image = json['image'];
    quantity = json['quantity'];
    isExist = json['isExist'];
    time = json['time'];
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price?.toString(),
      "image": image,
      "quantity": quantity,
      "isExist": isExist,
      "time": time,
      "product": product?.toJson(),
    };
  }

  CartModel copyWith({
    int? id,
    String? name,
    double? price,
    String? image,
    int? quantity,
    bool? isExist,
    String? time,
    Product? product,
  }) {
    return CartModel(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      quantity: quantity ?? this.quantity,
      isExist: isExist ?? this.isExist,
      time: time ?? this.time,
      product: product ?? this.product,
      productData: {},
    );
  }
}
