import 'package:flutter/material.dart';
import 'package:soyabox/screen/cart/order_details_page.dart';
import 'package:get/get.dart';
import 'package:soyabox/controllers/order_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:intl/intl.dart';
class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> {
  final OrderController orderController = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();
    orderController.fetchUserOrders();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor:
                themeController.isDarkMode ? Colors.black : Colors.white,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color:
                    themeController.isDarkMode ? Colors.white : Colors.black54,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            title: Text(
              'Mon Historique',
              style: TextStyle(
                color:
                    themeController.isDarkMode ? Colors.white : Colors.black54,
              ),
            ),
            elevation: 0,
          ),
          body: GetBuilder<OrderController>(
            builder: (controller) {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.orders.isEmpty) {
                return Center(
                  child: Text(
                    "vous n'avez aucun commande",
                    style: TextStyle(
                      fontSize: 18,
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.black54,
                    ),
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.orders.length,
                itemBuilder: (context, index) {
                  final order = controller.orders[index];
                  final formattedDate =
                      DateFormat('d/M/y  H:m');

                  return Card(
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    color: themeController.isDarkMode
                        ? Colors.black54
                        : Colors.white,
                    elevation: 4.0,
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(
                          left: 10, right: 10, top: 6, bottom: 6),
                      title: Text(
                        'Date: $formattedDate',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: themeController.isDarkMode
                              ? Colors.white
                              : Colors.black54,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Montant total: ${order.totalAmount.toStringAsFixed(2)} Dhs',
                            style: TextStyle(
                              fontSize: 16,
                              color: themeController.isDarkMode
                                  ? Colors.white70
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4.0),
                          // Display the order type
                          Row(
                            children: [
                              Text(
                                ' ${order.orderType == 'delivery' ? 'À Domicile' : 'À Emporter'}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: themeController.isDarkMode
                                      ? Colors.redAccent
                                      : Colors.green,
                                ),
                              ),
                              const SizedBox(width: 20.0),
                              // Display the order confirmation or refusal status
                              Text(
                                order.status == 'confirmed'
                                    ? 'Confirmé'
                                    : order.status == 'refused'
                                        ? 'Refusé'
                                        : order.status == 'pending'
                                            ? 'En attente'
                                            : 'Statut inconnu',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: order.status == 'confirmed'
                                      ? Colors.green
                                      : order.status == 'refused'
                                          ? Colors.red
                                          : order.status == 'pending'
                                              ? Colors.yellow
                                              : Colors
                                                  .grey, // Default color for unknown status
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Icon(
                        Icons.remove_red_eye, // Icon for "Watch Details"
                        color: themeController.isDarkMode
                            ? Colors.redAccent
                            : const Color.fromARGB(255, 100, 45, 41),
                      ),
                      onTap: () {
                        // Navigate to order details page
                        Get.to(() =>
                            OrderDetailsPage(orderId: order.id.toString()));
                      },
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
