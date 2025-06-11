import 'package:flutter/material.dart';
import 'package:soyabox/controllers/address_controller.dart';
import 'package:soyabox/controllers/auth_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';

import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = themeController.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Se connecter',
          style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.white,
        iconTheme:
            IconThemeData(color: isDarkMode ? Colors.white : Colors.black),
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () {
            Get.offAllNamed('/');
          },
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(36.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo with Border
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isDarkMode ? Colors.redAccent : Colors.black,
                          width: 3.0,
                        ),
                      ),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage('assets/images/logo.png'),
                        radius: 100,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Phone TextField
                    _buildTextField(
                      controller: phoneController,
                      labelText: 'téléphone',
                      icon: Icons.phone,
                    ),
                    const SizedBox(height: 16),
                    // Password TextField
                    _buildPasswordField(),
                    const SizedBox(height: 24),
                    // Login Button or Loading Indicator
                    SizedBox(
                      width: double.infinity,
                      child: _isLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                isDarkMode ? Colors.redAccent : Colors.black,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isDarkMode
                                    ? Colors.redAccent
                                    : Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Se connecter',
                                style: TextStyle(
                                  color:
                                      isDarkMode ? Colors.black : Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    // Sign Up Option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Je n'ai pas de compte?",
                          style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/register');
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: 'Créer compte',
                              style: TextStyle(
                                color: Colors.redAccent,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.redAccent,
                                decorationThickness: 2,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    final isDarkMode = themeController.isDarkMode;
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 2,
            color: isDarkMode ? Colors.redAccent : Colors.black,
          ),
        ),
        prefixIcon:
            Icon(icon, color: isDarkMode ? Colors.redAccent : Colors.black),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.redAccent : Colors.black,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: isDarkMode ? Colors.redAccent : Colors.black,
            width: 2.0,
          ),
        ),
      ),
      style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
    );
  }

  Widget _buildPasswordField() {
    return Obx(() {
      final isDarkMode = themeController.isDarkMode;
      final isPasswordVisible = authController.passwordVisible.value;
      return TextField(
        controller: passwordController,
        obscureText: !isPasswordVisible,
        decoration: InputDecoration(
          labelText: 'Mot De Passe',
          labelStyle:
              TextStyle(color: isDarkMode ? Colors.white : Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              width: 2,
              color: isDarkMode ? Colors.redAccent : Colors.black,
            ),
          ),
          prefixIcon: Icon(Icons.lock,
              color: isDarkMode ? Colors.redAccent : Colors.black),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: isDarkMode ? Colors.redAccent : Colors.black,
            ),
            onPressed: () {
              authController.togglePasswordVisibility();
            },
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.redAccent : Colors.black,
              width: 2.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.redAccent : Colors.black,
              width: 2.0,
            ),
          ),
        ),
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
      );
    });
  }

  Future<void> _login() async {
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (phone.isEmpty ||
        !RegExp(r'\d+').hasMatch(phone) ||
        password.length < 6) {
      Get.snackbar(
          backgroundColor: Colors.redAccent, // Fond rouge
          colorText: Colors.white, // Texte blanc
          borderRadius: 10.0, // Coins arrondis
          margin: const EdgeInsets.all(10), // Marge autour du snackbar
          padding: const EdgeInsets.all(15),
          'Erreur',
          'Vérifiez vos informations de connexion');
      return;
    }

    setState(() => _isLoading = true);
    final response = await authController.login(phone, password);

    if (response.isSuccess) {
      await Get.find<AddressController>().fetchAddressesForLoggedInUser();
      Get.offAllNamed(
          '/profile'); // Redirection vers la page de profil après connexion réussie
    } else {
      Get.snackbar(backgroundColor: Colors.redAccent, // Fond rouge
      colorText: Colors.white, // Texte blanc
      borderRadius: 10.0, // Coins arrondis
      margin: const EdgeInsets.all(10), // Marge autour du snackbar
      padding: const EdgeInsets.all(15),'Connexion échouée', response.message);
    }

    setState(() => _isLoading = false);
  }
}
