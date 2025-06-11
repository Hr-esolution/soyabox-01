import 'package:flutter/material.dart';
import 'package:soyabox/controllers/address_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:soyabox/models/address_model.dart';
import 'package:get/get.dart';

class AddAddressPage extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();
  final int userId;
  final AddressController addressController = Get.find<AddressController>();
  final TextEditingController rueController = TextEditingController();
  final TextEditingController boulevardController = TextEditingController();
  final String previousPage;

  final List<String> _cities = ['Casablanca', 'Mohammedia'];
  final RxString _selectedCity = ''.obs;

  AddAddressPage({super.key, required this.userId, required this.previousPage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            themeController.isDarkMode ? Colors.black : Colors.white,
        title: Text(
          'Ajouter Adresse',
          style: TextStyle(
            color: themeController.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: themeController.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: IntrinsicHeight(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          children: [
                            const TextSpan(
                              text: 'Veuillez remplir tous les champs!',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: '\n\n'),
                            TextSpan(
                              text:
                                  'Nom complet et téléphone sont pour un autre receveur de commande si vous voulez!!',
                              style: TextStyle(
                                color: themeController.isDarkMode
                                    ? Colors.grey[300]
                                    : Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: themeController.isDarkMode
                              ? Colors.grey[800]
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: themeController.isDarkMode
                                  ? Colors.grey[700]!
                                  : Colors.grey[300]!,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              TextField(
                                controller: rueController,
                                decoration: _buildInputDecoration(
                                  themeController,
                                  'Rue et numéro',
                                  Icons.location_on,
                                ),
                                style: _inputStyle(themeController),
                              ),
                              const SizedBox(height: 16.0),
                              TextField(
                                controller: boulevardController,
                                decoration: _buildInputDecoration(
                                  themeController,
                                  'Boulevard',
                                  Icons.location_city,
                                ),
                                style: _inputStyle(themeController),
                              ),
                              const SizedBox(height: 16.0),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Ville:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: themeController.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ..._cities.map((city) {
                                return Obx(() => CheckboxListTile(
                                      title: Text(
                                        city,
                                        style: TextStyle(
                                          color: themeController.isDarkMode
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      value: _selectedCity.value == city,
                                      onChanged: (value) {
                                        if (value == true) {
                                          _selectedCity.value = city;
                                        }
                                      },
                                      activeColor: Colors.redAccent,
                                    ));
                              }),
                              const SizedBox(height: 16.0),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: themeController.isDarkMode
                                      ? Colors.redAccent
                                      : Colors.black,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () async {
                                  if (_selectedCity.value.isEmpty) {
                                    Get.snackbar('Erreur',
                                        'Veuillez sélectionner une ville');
                                    return;
                                  }

                                  AddressModel newAddress = AddressModel(
                                    userId: userId,
                                    rue: rueController.text,
                                    boulevard: boulevardController.text,
                                    ville: _selectedCity.value,
                                  );
                                  await addressController.addAddress(newAddress);
                                  Get.back(result: newAddress);
                                },
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.app_registration),
                                    SizedBox(width: 8),
                                    Text('Enregistrer'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration _buildInputDecoration(
      ThemeController themeController, String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: themeController.isDarkMode ? Colors.white : Colors.black,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      prefixIcon: Icon(
        icon,
        color: themeController.isDarkMode ? Colors.redAccent : Colors.black,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: themeController.isDarkMode ? Colors.redAccent : Colors.black,
          width: 2.0,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: BorderSide(
          color: themeController.isDarkMode ? Colors.redAccent : Colors.black,
          width: 2.0,
        ),
      ),
    );
  }

  TextStyle _inputStyle(ThemeController themeController) {
    return TextStyle(
      color: themeController.isDarkMode ? Colors.white : Colors.black,
    );
  }
}
