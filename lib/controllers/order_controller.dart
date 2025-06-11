import 'package:soyabox/data/order_repo.dart';
import 'package:soyabox/models/order_model.dart';
import 'package:get/get.dart';

class OrderController extends GetxController {
  final OrderRepo orderRepo;

  OrderController({
    required this.orderRepo,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;


  Future<String> placeOrder(Order order) async {
    _isLoading = true; // Indicate that the order placement is in progress
    Map<String, dynamic> orderData = order.toJson();

    // Remove the address if the order type is "pickup"
    if (order.orderType == 'pickup') {
      orderData.remove('address');
    }

    // Send the order data to the repository for placement
    Response response = await orderRepo.placeOrder(order);

    _isLoading = false; // Reset loading state after the request

    if (response.statusCode == 201) {
      // Check for successful creation (HTTP 201)
      String orderId =
          response.body['id'] ?? 'unknown'; // Use 'id' as per your API
      return orderId; // Return the created order ID
    } else {
      return 'unknown'; // Return 'unknown' on failure
    }
  }

  RxList<Order> orders = <Order>[].obs;

  Future<void> fetchUserOrders() async {
    _isLoading = true;
    update(); // Notify UI about loading state

    try {
      Response response = await orderRepo.fetchUserOrders();

      if (response.statusCode == 200) {
        List<dynamic> orderList = response.body['orders'];
        orders.value = orderList.map((order) => Order.fromJson(order)).toList();
      } else if (response.statusCode == 404) {
        // Handle no orders found case without an error message
      
        orders.value = []; // Ensure orders is an empty list
      } else {
        // Log any other error messages
       
        throw Exception('Failed to fetch orders: ${response.statusCode}');
      }
    } catch (e) {
      // Log the error without using snackbar
     
      throw Exception(
          'An error occurred while fetching orders: $e'); // Optionally, throw an exception
    } finally {
      _isLoading = false;
      update(); // Notify UI about data change
    }
  }

  Order? orderDetails;

  Future<void> fetchOrderDetails(String orderId) async {
    _isLoading = true;
    // Notify UI about loading state
    try {
      final response = await orderRepo.getOrderDetails(orderId);
      if (response.statusCode == 200) {
        if (response.body != null) {
         
          orderDetails = Order.fromJson(response.body);
        } else {
          orderDetails = null;
        }
      } else {
        orderDetails = null;
      }
    } catch (e) {
      orderDetails = null;
     
    } finally {
      _isLoading = false;
      update(); // Notify UI about data change
    }
  }
}
