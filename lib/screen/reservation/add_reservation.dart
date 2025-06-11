import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soyabox/controllers/reservation_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:soyabox/models/reservation_model.dart';

class AddReservationPage extends StatefulWidget {
  const AddReservationPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddReservationPageState createState() => _AddReservationPageState();
}

class _AddReservationPageState extends State<AddReservationPage> {
  final ReservationController reservationController =
      Get.find<ReservationController>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _name;
  String? _phone;
  DateTime? _reservationDate;
  TimeOfDay? _reservationTime;
  int? _numberOfPersons;
  String? _selectedCity; // Variable pour stocker la ville sélectionnée
  final List<String> _cities = ['Casablanca', 'Mohammedia'];

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    final isDarkMode = themeController.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Reserver Une Table',
          style: TextStyle(
            color: themeController.isDarkMode ? Colors.white : Colors.white,
          ),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.redAccent,
      ),
      body: SingleChildScrollView(
        // Make the body scrollable
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Merci pour votre réservation !',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    'Nous vous appellerons plus tard pour confirmer votre réservation.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16.0),
                  // Form to add reservation
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Name Field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Nom',
                            labelStyle: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    isDarkMode ? Colors.redAccent : Colors.black,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Svp entrer votre nom complet';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _name = value;
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Phone Field
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Téléphone',
                            labelStyle: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    isDarkMode ? Colors.redAccent : Colors.black,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Svp entrer votre numéro mobile';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _phone = value;
                          },
                        ),
                        const SizedBox(height: 16.0),

                        // Number of Persons Field
                        TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Nombre de personnes',
                            labelStyle: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color:
                                    isDarkMode ? Colors.redAccent : Colors.black,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Svp entrer le nombre de personnes';
                            }
                            if (int.tryParse(value) == null ||
                                int.parse(value) <= 0) {
                              return 'Veuillez entrer un nombre valide';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _numberOfPersons = int.tryParse(value);
                          },
                        ),
                        const SizedBox(height: 16.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            
                            Wrap(
                              spacing: 20.0, // Espacement entre les options
                              children: _cities.map((city) {
                                return Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Radio<String>(
                                      value: city,
                                      groupValue: _selectedCity,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedCity = value;
                                        });
                                      },
                                    ),
                                    Text(
                                      city,
                                      style: TextStyle(
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                            if (_selectedCity ==
                                null) // Afficher un message d'erreur si aucune ville n'est sélectionnée
                              const Padding(
                                padding: EdgeInsets.only(left: 16.0),
                                child: Text(
                                  'Veuillez sélectionner une ville',
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14),
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 16.0),
                        GestureDetector(
                          onTap: () async {
                            final DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: _reservationDate ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null &&
                                pickedDate != _reservationDate) {
                              setState(() {
                                _reservationDate = pickedDate;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Date de réservation',
                              labelStyle: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            child: Text(
                              _reservationDate == null
                                  ? 'Sélectionner la date'
                                  : '${_reservationDate!.toLocal()}'
                                      .split(' ')[0],
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // Time Picker
                        GestureDetector(
                          onTap: () async {
                            final TimeOfDay? pickedTime = await showTimePicker(
                              context: context,
                              initialTime: _reservationTime ?? TimeOfDay.now(),
                            );
                            if (pickedTime != null) {
                              setState(() {
                                _reservationTime = pickedTime;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              labelText: 'Sélectionner l\'heure',
                              labelStyle: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                              border: const OutlineInputBorder(),
                            ),
                            child: Text(
                              _reservationTime == null
                                  ? 'Sélectionner l\'heure'
                                  : _reservationTime!.format(context),
                              style: TextStyle(
                                color: isDarkMode ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // Add Reservation Button
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // Create ReservationModel
                              ReservationModel reservation = ReservationModel(
                                name: _name,
                                phone: _phone,
                                city: _selectedCity, // Ajout de la ville
                                reservationDate: _reservationDate,
                                reservationTime:
                                    _reservationTime?.format(context),
                                status: 'pending',
                                numberOfPersons: _numberOfPersons,
                              );

                              // Call controller to place reservation
                              reservationController
                                  .placeReservation(reservation)
                                  .then((result) {
                                Get.snackbar('Succès',
                                    'Réservation ajoutée avec succès.',
                                    backgroundColor: Colors.green);
                                Get.offAllNamed(
                                    '/'); // Navigate to homepage directly
                              }).catchError((error) {
                                Get.snackbar('Erreur',
                                    'Échec de l\'ajout de la réservation: $error',
                                    backgroundColor: Colors.red);
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                isDarkMode ? Colors.redAccent : Colors.black,
                          ),
                          child: const Text(
                            'Réserver votre Table',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
