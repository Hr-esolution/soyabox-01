import 'package:soyabox/api/api_client.dart';
import 'package:soyabox/models/order_model.dart';
import 'package:get/get.dart';

class OrderRepo {
  ApiClient apiClient;
  OrderRepo({required this.apiClient});
  Future<Response> placeOrder(Order order) async {
    return await apiClient.postData('/api/orders', order.toJson());
  }

  Future<Response> fetchUserOrders() async {
    return await apiClient
        .getData('/api/user/orders'); // Adjust URL based on your API
  }

  Future<Response> getOrderDetails(String orderId) async {
    return await apiClient
        .getData('/api/orders/$orderId'); // Corrected URL with interpolation
  }
}
