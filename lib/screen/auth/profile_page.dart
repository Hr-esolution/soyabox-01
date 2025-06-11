import 'package:flutter/material.dart';
import 'package:soyabox/controllers/address_controller.dart';
import 'package:soyabox/controllers/auth_controller.dart';
import 'package:soyabox/controllers/reservation_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:soyabox/controllers/user_controller.dart';
import 'package:soyabox/models/address_model.dart';
import 'package:soyabox/models/user_model.dart';
import 'package:soyabox/screen/auth/add_address_page.dart';
import 'package:soyabox/screen/cart/order_history_page.dart';
import 'package:soyabox/screen/main_page.dart';
import 'package:soyabox/screen/privacy_policy.dart';
import 'package:soyabox/widgets/persiste_bottombar.dart';
import 'package:get/get.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthController authController = Get.find<AuthController>();
  final ReservationController reservationController =
      Get.find<ReservationController>();
  final UserController userController = Get.find<UserController>();
  final AddressController addressController = Get.find<AddressController>();
  final ThemeController themeController = Get.find<ThemeController>();
  bool userLoggedIn = false;
  UserModel? user;

  @override
  void initState() {
    super.initState();
    userLoggedIn = authController.userLoggedIn();
    if (userLoggedIn) {
      _getUserInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: userLoggedIn
          ? AppBar(
              backgroundColor:
                  themeController.isDarkMode ? Colors.black : Colors.redAccent,
              title: Text(
                'Mon Profile',
                style: TextStyle(
                  color:
                      themeController.isDarkMode ? Colors.white : Colors.white,
                ),
              ),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout,
                      color: themeController.isDarkMode
                          ? Colors.white
                          : Colors.white),
                  onPressed: () {
                    authController.logout();
                    userController.logout();
                    Get.toNamed('/');
                  },
                ),
              ],
            )
          : null,
      body: userLoggedIn
          ? _buildBody()
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Veuillez vous connecter pour poursuivre \nvos commandes!",
                        style: TextStyle(
                            fontSize: 16,
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeController.isDarkMode
                                    ? Colors.redAccent
                                    : Colors.redAccent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              onPressed: () {
                                Get.toNamed('/login');
                              },
                              child: Text(
                                'Se connecter',
                                style: TextStyle(
                                  color: themeController.isDarkMode
                                      ? Colors.white
                                      : Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeController.isDarkMode
                                    ? Colors.redAccent
                                    : Colors.redAccent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              onPressed: () {
                                Get.toNamed(
                                    '/register'); // Adjust route if needed
                              },
                              child: Text(
                                'S\'inscrire',
                                style: TextStyle(
                                  color: themeController.isDarkMode
                                      ? Colors.white
                                      : Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeController.isDarkMode
                                    ? Colors.redAccent
                                    : Colors.redAccent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              onPressed: () {
                                Get.to(MainScreen());
                              },
                              child: Text(
                                'Retour',
                                style: TextStyle(
                                  color: themeController.isDarkMode
                                      ? Colors.white
                                      : Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeController.isDarkMode
                                    ? Colors.redAccent
                                    : Colors.redAccent,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 15),
                              ),
                              onPressed: () {
                                Get.to(() => const PrivacyPolicyPage());
                              },
                              child: Text(
                                'politique de confidentialite',
                                style: TextStyle(
                                  color: themeController.isDarkMode
                                      ? Colors.white
                                      : Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
      bottomNavigationBar: PersistentBottomBar(),
    );
  }

  Widget _buildBody() {
    return GetBuilder<AddressController>(
      builder: (_) => FutureBuilder<UserModel>(
        future: _getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error.toString()}'),
            );
          } else {
            user = snapshot.data;
            if (user!.id == null) {
              return Center(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/login');
                  },
                  child: const Text('Se connecter'),
                ),
              );
            } else {
              return _buildProfileInfo();
            }
          }
        },
      ),
    );
  }

  Widget _buildProfileInfo() {
    final hasAddresses = addressController.addresses.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildUserInfoCard(),
          _buildOrderHistoryCard(),
          _buildReservationHistoryCard(),
          if (hasAddresses) _buildAddressList() else _buildAddAddressButton(),
          SizedBox(
            width: double.infinity, // Largeur infinie
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 12), // Ajuste la hauteur du bouton
                backgroundColor: Colors.redAccent, // Couleur du bouton
              ),
              onPressed: () {
                Get.offAllNamed('/'); // Aller à la page d'accueil
              },
              icon: const Icon(Icons.home,
                  size: 24, color: Colors.white), // Icône home
              label: const Text(
                "Aller à l'Accueil",
                style:
                    TextStyle(fontSize: 16, color: Colors.white), // Texte blanc
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildOrderHistoryCard() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(top: 16),
        child: ListTile(
          leading: const Icon(Icons.history, size: 24, color: Colors.redAccent),
          title: const Text('Historique des commandes',
              style: TextStyle(fontSize: 16)),
          onTap: () {
           WidgetsBinding.instance.addPostFrameCallback((_) {
    Get.to(() => const OrderHistoryPage());
  });
          },
        ),
      ),
    );
  }

  Widget _buildReservationHistoryCard() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(top: 16),
        child: ListTile(
          leading:
              const Icon(Icons.event_note, size: 24, color: Colors.redAccent),
          title: const Text('Historique des réservations',
              style: TextStyle(fontSize: 16)),
          onTap: () {
            // Navigate directly to the ReservationHistoryPage
            Get.toNamed('/reservation-history'); // Ensure this route is defined
          },
        ),
      ),
    );
  }

  Widget _buildAddAddressButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.redAccent, // Text color
        ),
        onPressed: () async {
          final result = await Get.to(
              () => AddAddressPage(userId: user!.id!, previousPage: 'profile'));
          if (result == 'from_profile') {
            _getUserInfo(); // Refresh user info and addresses
          }
        },
        child: const Text('Ajouter une adresse'),
      ),
    );
  }

  Widget _buildAddressList() {
    return Expanded(
      child: ListView.builder(
        itemCount: addressController.addresses.length,
        itemBuilder: (context, index) {
          final address = addressController.addresses[index];
          return SizedBox(
            width: double.infinity,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: const Icon(Icons.pin_drop,
                    size: 24, color: Colors.redAccent),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('adresse : ${index + 1}'),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        bool removed =
                            await addressController.removeAddress(address.id!);
                        if (removed) {
                          Get.snackbar(
                              backgroundColor:
                                  Colors.redAccent, // Fond rougeflo
                              colorText: Colors.white, // Texte blanc
                              borderRadius: 10.0, // Coins arrondis
                              margin: const EdgeInsets.all(
                                  10), // Marge autour du snackbar
                              padding: const EdgeInsets.all(15),
                              'Succès',
                              'Adresse supprimée avec succès');
                        } else {
                          Get.snackbar(
                              backgroundColor: Colors.redAccent, // Fond rouge
                              colorText: Colors.white, // Texte blanc
                              borderRadius: 10.0, // Coins arrondis
                              margin: const EdgeInsets.all(
                                  10), // Marge autour du snackbar
                              padding: const EdgeInsets.all(15),
                              'Erreur',
                              'Échec de la suppression, réessayez.');
                        }
                      },
                    ),
                  ],
                ),
                onTap: () {
                  _showAddressDialog(address);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUserInfoCard() {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.person,
                    size: 24,
                    color: Colors.redAccent,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Nom: ${user!.name ?? ''}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.phone, size: 24, color: Colors.redAccent),
                  const SizedBox(width: 16),
                  Text(
                    'N° Mobile: ${user!.phone ?? ''}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<UserModel> _getUserInfo() async {
    await userController.getUserInfo();
    await addressController.fetchAddressForUser(userController.userModel.id!);
    return userController.userModel;
  }

  void _showAddressDialog(AddressModel address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Adresse de livraison'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('N° et rue: ${address.rue}'),
              Text('Boulevard: ${address.boulevard}'),
              Text('Ville: ${address.ville}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fermer'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
