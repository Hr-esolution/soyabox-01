import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soyabox/controllers/reservation_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:intl/intl.dart'; // For date formatting

class ReservationHistoryPage extends StatefulWidget {
  const ReservationHistoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReservationHistoryPageState createState() => _ReservationHistoryPageState();
}

class _ReservationHistoryPageState extends State<ReservationHistoryPage> {
  final ReservationController reservationController =
      Get.find<ReservationController>();
  bool isLoading = true; // State variable to manage loading

  @override
  void initState() {
    super.initState();
    // Fetch reservations when the page is initialized
    fetchReservations();
  }

  Future<void> fetchReservations() async {
    try {
      await reservationController.fetchUserReservations();
      setState(() {
        isLoading = false; // Set loading to false when data is fetched
      });
    } catch (error) {
      setState(() {
        isLoading = false; // Set loading to false in case of error
      });
      Get.snackbar('Error', 'Failed to fetch reservations: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Historique des Réservations'),
            backgroundColor: themeController.isDarkMode
                ? Colors.black
                : Colors.orange, // AppBar color based on theme
          ),
          body: isLoading
              ? const Center(child: CircularProgressIndicator())
              : reservationController.reservations.isEmpty
                  ? Center(
                      child: Text(
                        'Aucune réservation trouvée.',
                        style: TextStyle(
                          color: themeController.isDarkMode
                              ? Colors.white
                              : Colors.black,
                          fontSize: 18,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: reservationController.reservations.length,
                      itemBuilder: (context, index) {
                        final reservation =
                            reservationController.reservations[index];
                        final formattedDate = DateFormat('d/M/y').format(
                            reservation.reservationDate ?? DateTime.now());

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: themeController.isDarkMode
                              ? Colors.black54
                              : Colors.white, // Card background color
                          elevation: 4,
                          child: ListTile(
                            contentPadding: const EdgeInsets.all(16.0),
                            title: Text(
                              reservation.name ?? 'Nom inconnu',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: themeController.isDarkMode
                                    ? Colors.white
                                    : Colors.black, // Title text color
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Téléphone: ${reservation.phone ?? 'Non fourni'}',
                                  style: TextStyle(
                                    color: themeController.isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                                Text(
                                  'Date: $formattedDate',
                                  style: TextStyle(
                                    color: themeController.isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                                Text(
                                  'Heure: ${reservation.reservationTime ?? 'Non fournie'}',
                                  style: TextStyle(
                                    color: themeController.isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                                Text(
                                  'Nombre de Personnes: ${reservation.numberOfPersons ?? 'Non fournie'}',
                                  style: TextStyle(
                                    color: themeController.isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                                Text(
                                  'ville: ${reservation.city}',
                                  style: TextStyle(
                                    color: themeController.isDarkMode
                                        ? Colors.white70
                                        : Colors.black54,
                                  ),
                                ),
                                // Add status with color coding
                                Text(
                                  'Statut: ${_getReservationStatus(reservation.status)}',
                                  style: TextStyle(
                                    color: _getReservationStatusColor(
                                        reservation.status),
                                  ),
                                ),
                              ],
                            ),
                            trailing: const Icon(Icons.event_note,
                                color: Colors.orange), // Icon for reservation
                          ),
                        );
                      },
                    ),
        );
      },
    );
  }

  // Method to return the formatted status string
  String _getReservationStatus(String? status) {
    switch (status) {
      case 'confirmed':
        return 'Confirmé';
      case 'refused':
        return 'Refusé';
      case 'pending':
        return 'En attente';
      default:
        return 'Statut inconnu';
    }
  }

  // Method to return the color based on status
  Color _getReservationStatusColor(String? status) {
    switch (status) {
      case 'confirmed':
        return Colors.green; // Color for confirmed
      case 'refused':
        return Colors.red; // Color for refused
      case 'pending':
        return Colors.yellow; // Color for pending
      default:
        return Colors.grey; // Default color for unknown status
    }
  }
}
