class OrderDetail {
  int productId;
  int quantity;
  double price;
  String productName;

  OrderDetail({
    required this.productId,
    required this.quantity,
    required this.price,
    required this.productName,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) {
    return OrderDetail(
      productId: json['product_id'],
      quantity: json['quantity'],
      price: (json['price'] is String)
          ? double.tryParse(json['price']) ?? 0.0
          : (json['price'] is num)
              ? json['price'].toDouble()
              : 0.0,
      productName: json['product_name'] ??
          '', // Assuming 'product_name' is available in the response
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'quantity': quantity,
      'price': price,
      'product_name': productName, // Include this if needed
    };
  }
}
