import 'package:soyabox/models/order_details.dart';

class Order {
  int? id;
  int userId;
  double totalAmount;
  String orderType; // 'delivery' or 'pickup'
  int? addressId;   // Only for delivery
  String? pickupCity; // Only for pickup
  String? note;
  String status;
  List<OrderDetail> orderDetails;

  Order({
    this.id,
    required this.userId,
    required this.totalAmount,
    required this.orderType,
    this.addressId,
    this.pickupCity,
    this.note,
    this.status = 'pending',
    required this.orderDetails,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      totalAmount: json['total_amount']?.toDouble() ?? 0.0,
      orderType: json['order_type'],
      addressId: json['address_id'],
      pickupCity: json['pickup_city'], // Note: vérifiez l'orthographe côté API
      note: json['note'],
      status: json['status'] ?? 'pending',
      orderDetails: (json['order_details'] as List?)
              ?.map((detail) => OrderDetail.fromJson(detail))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'user_id': userId,
      'total_amount': totalAmount,
      'order_type': orderType,
      'status': status,
      'note': note,
      'order_details': orderDetails.map((detail) => detail.toJson()).toList(),
    };

    // Champs conditionnels selon le type de commande
    if (orderType == 'delivery') {
      data['address_id'] = addressId;
    } else if (orderType == 'pickup') {
      data['pickup_city'] = pickupCity;
    }

    return data;
  }
}