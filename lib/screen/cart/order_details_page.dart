import 'package:flutter/material.dart';
import 'package:soyabox/controllers/order_controller.dart';
import 'package:soyabox/models/order_model.dart';
import 'package:get/get.dart';




class OrderDetailsPage extends StatelessWidget {
  final String orderId;

  const OrderDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    final OrderController orderController = Get.find<OrderController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Détails de la Commande'),
      ),
      body: FutureBuilder<void>(
        future: orderController.fetchOrderDetails(orderId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          if (orderController.orderDetails == null) {
            return const Center(child: Text('Aucun détail de commande trouvé.'));
          }

          final Order order = orderController.orderDetails!;

          return SingleChildScrollView(
            // Make the body scrollable
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                        const Text(
                          'Produits commandés:',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        DataTable(
                          columns: const [
                            DataColumn(label: Text('Produit')),
                            DataColumn(label: Text('Quantité')),
                            DataColumn(label: Text('Prix')),
                          ],
                          rows: order.orderDetails.map((detail) {
                            return DataRow(cells: [
                              DataCell(Text(detail.productName)),
                              DataCell(Text(detail.quantity.toString())),
                              DataCell(Text('${detail.price} Dhs')),
                            ]);
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
                // Total amount
                const SizedBox(height: 10),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 4.0,
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Text(
                      'Montant Total: ${order.totalAmount} Dhs',
                      style:
                          const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
