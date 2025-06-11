import 'package:flutter/material.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:soyabox/models/order_details.dart';
import 'package:soyabox/models/user_model.dart';
import 'package:soyabox/screen/auth/add_address_page.dart';
import 'package:get/get.dart';
import 'package:soyabox/controllers/address_controller.dart';
import 'package:soyabox/controllers/cart_controller.dart';
import 'package:soyabox/controllers/order_controller.dart';
import 'package:soyabox/controllers/user_controller.dart';
import 'package:soyabox/models/address_model.dart';
import 'package:soyabox/models/order_model.dart';
import 'package:soyabox/screen/cart/order_confirmation.dart';
import 'package:intl/intl.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  String _selectedDeliveryOption = 'delivery';
  final TextEditingController _noteController = TextEditingController();
  final CartController cartController = Get.find<CartController>();
  final UserController userController = Get.find<UserController>();
  final AddressController addressController = Get.find<AddressController>();
  final OrderController orderController = Get.find<OrderController>();
  final ThemeController themeController = Get.find<ThemeController>();
  
  UserModel? userModel;
  AddressModel? _currentAddress;
  int? userId;
  String? _selectedPickupCity;

  @override
  void initState() {
    super.initState();
    userModel = Get.arguments?['userModel'];

    if (userModel != null) {
      userController.setUserModel(userModel!);
    } else {
      userController.getUserInfo();
    }

    if (userController.userModel.id != null) {
      userId = userController.userModel.id;
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.snackbar('Erreur', 'Utilisateur non connecté, veuillez vous connecter.');
        Get.offAllNamed('/login');
      });
    }

    if (addressController.addresses.isEmpty) {
      addressController.fetchAddressesForLoggedInUser();
    }
  }

  void _navigateToAddAddressPage(int userId) async {
    final AddressModel? newAddress = await Get.to(() => AddAddressPage(
          userId: userId,
          previousPage: '',
        ));

    if (newAddress != null) {
      await addressController.fetchAddressForUser(userId);
      addressController.update();
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ma commande',
          style: TextStyle(
              color: themeController.isDarkMode ? Colors.white : Colors.black),
        ),
        backgroundColor:
            themeController.isDarkMode ? Colors.black : Colors.white,
      ),
      body: GetBuilder<AddressController>(
        builder: (controller) {
          if (controller.addresses.isEmpty && !controller.isLoading) {
            controller.fetchAddressesForLoggedInUser();
          }

          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  _buildCartDetailsCard(),
                  _buildPaymentMethodSection(),
                  const SizedBox(height: 10),
                  if (userId != null) 
                    _buildAddressSection(context, userId!),
                  const SizedBox(height: 10),
                  _buildNoteSection(),
                  const SizedBox(height: 10),
                  _buildPlaceOrderButton(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildCartDetailsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ma commande',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            DataTable(
              columns: const [
                DataColumn(label: Text('Produit')),
                DataColumn(label: Text('Quantité')),
                DataColumn(label: Text('Total')),
              ],
              rows: cartController.items.values.map((item) {
                return DataRow(cells: [
                  DataCell(Text(item.name ?? "")),
                  DataCell(Text('${item.quantity}')),
                  DataCell(Text(
                      ' ${NumberFormat.currency(locale: 'fr_FR', symbol: '').format(item.price! * item.quantity!)}')),
                ]);
              }).toList(),
            ),
            const Divider(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Total à payer: ${NumberFormat.currency(locale: 'fr_FR', symbol: '').format(cartController.totalAmount)} Dhs',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ajouter une note à la commande', style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal)),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Ajoutez des instructions spéciales...'
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection(BuildContext context, int userId) {
    if (_selectedDeliveryOption != 'delivery') {
      return const SizedBox.shrink();
    }

    return GetBuilder<AddressController>(builder: (controller) {
      if (controller.addresses.isEmpty && !controller.isLoading) {
        controller.fetchAddressForUser(userId);
      }

      if (controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Adresse de livraison',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const Divider(),
                controller.addresses.isEmpty
                    ? Column(
                        children: [
                          const Text('Aucune adresse trouvée'),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: TextButton.icon(
                                onPressed: () {
                                  _navigateToAddAddressPage(userId);
                                },
                                icon: const Icon(Icons.add,
                                    color: Colors.redAccent),
                                label: const Text(
                                  'Ajouter une adresse',
                                  style: TextStyle(
                                      color: Colors.redAccent, fontSize: 16),
                                ),
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          Text(
                            controller.selectedAddress.value?.fullAddress ??
                                'Sélectionner une adresse à utiliser',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ElevatedButton(
                                onPressed: () async {
                                  final selectedAddress =
                                      await showDialog<AddressModel?>(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Choisissez une adresse'),
                                        content: SizedBox(
                                          width: double.maxFinite,
                                          child: ListView.builder(
                                            itemCount:
                                                controller.addresses.length,
                                            itemBuilder: (context, index) {
                                              final address =
                                                  controller.addresses[index];
                                              return ListTile(
                                                title:
                                                    Text(address.fullAddress),
                                                onTap: () {
                                                  Navigator.of(context).pop(address);
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                  if (selectedAddress != null) {
                                    _currentAddress = selectedAddress;
                                    controller.selectAddress(selectedAddress);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'Selectionner l\'adresse',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        );
      }
    });
  }

  Widget _buildPaymentMethodSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedDeliveryOption = 'delivery';
                        _selectedPickupCity = null;
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.home,
                          color: _selectedDeliveryOption == 'delivery'
                              ? Colors.redAccent
                              : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'À Domicile',
                          style: TextStyle(
                            color: _selectedDeliveryOption == 'delivery'
                                ? Colors.redAccent
                                : Colors.grey,
                            fontWeight: _selectedDeliveryOption == 'delivery'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_selectedDeliveryOption == 'delivery')
                          const Icon(
                            Icons.check_circle,
                            color: Colors.redAccent,
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedDeliveryOption = 'pickup';
                      });
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.store,
                          color: _selectedDeliveryOption == 'pickup'
                              ? Colors.redAccent
                              : Colors.grey,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'À Emporter',
                          style: TextStyle(
                            color: _selectedDeliveryOption == 'pickup'
                                ? Colors.redAccent
                                : Colors.grey,
                            fontWeight: _selectedDeliveryOption == 'pickup'
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (_selectedDeliveryOption == 'pickup')
                          const Icon(
                            Icons.check_circle,
                            color: Colors.redAccent,
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (_selectedDeliveryOption == 'pickup') ...[
              const SizedBox(height: 16),
              const Text(
                'Sélectionnez la ville de retrait :',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              RadioListTile<String>(
                title: const Text('Casablanca'),
                value: 'casablanca',
                groupValue: _selectedPickupCity,
                onChanged: (String? value) {
                  setState(() {
                    _selectedPickupCity = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Mohammedia'),
                value: 'mohammedia',
                groupValue: _selectedPickupCity,
                onChanged: (String? value) {
                  setState(() {
                    _selectedPickupCity = value;
                  });
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildPlaceOrderButton() {
    return ElevatedButton(
      onPressed: () async {
      // Validation
      if (_selectedDeliveryOption == 'delivery' && _currentAddress == null) {
        Get.snackbar(
          'Erreur',
          'Veuillez sélectionner une adresse de livraison',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (_selectedDeliveryOption == 'pickup' && _selectedPickupCity == null) {
        Get.snackbar(
          'Erreur',
          'Veuillez sélectionner une ville de retrait',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      try {
        // Préparer les détails de la commande
        cartController.items.values.map((item) {
          return {
            'product_id': item.id,
            'quantity': item.quantity,
            'price': item.price,
          };
        }).toList();

        // Créer l'objet Order pour l'API
       // Lors de la création de la commande
final order = Order(
  userId: userController.userModel.id!,
  totalAmount: cartController.totalAmount.toDouble(),
  orderType: _selectedDeliveryOption,
  addressId: _selectedDeliveryOption == 'delivery' 
      ? _currentAddress?.id 
      : null,
  pickupCity: _selectedDeliveryOption == 'pickup'
      ? _selectedPickupCity?.toLowerCase() // Assurez-vous que c'est en minuscules
      : null,
  note: _noteController.text.isNotEmpty 
      ? _noteController.text 
      : null,
  orderDetails: cartController.items.values.map((item) => OrderDetail(
    productId: item.id!,
    quantity: item.quantity!,
    price: item.price!, productName:item.name!,
  )).toList(),
);
        // Passer la commande
        String orderId = await orderController.placeOrder(order);
        
        // Vider le panier et naviguer vers la confirmation
        cartController.clearCart();
        Get.back();
        Get.off(() => OrderConfirmationPage(
          orderId: orderId,
          message: 'Votre commande a été envoyée avec succès! Merci pour votre confiance.',
        ));
      } catch (e) {
        Get.back();
        Get.snackbar(
          'Erreur',
          'Une erreur est survenue: ${e.toString()}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Passer la commande',
        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}