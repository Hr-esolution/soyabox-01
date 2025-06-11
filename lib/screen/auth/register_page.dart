import 'package:flutter/material.dart';
import 'package:soyabox/controllers/auth_controller.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:soyabox/models/signup_model.dart';
import 'package:soyabox/screen/auth/login_page.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Créer un compte',
          style: TextStyle(
            color: themeController.isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor:
            themeController.isDarkMode ? Colors.black : Colors.white,
        iconTheme: IconThemeData(
          color: themeController.isDarkMode ? Colors.white : Colors.black,
        ),
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
                          color: themeController.isDarkMode
                              ? Colors.redAccent
                              : Colors.black,
                          width: 3.0,
                        ),
                      ),
                      child: const CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/images/logo.png',
                        ),
                        radius: 100,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: nameController,
                      labelText: 'nom complet',
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    // Phone TextField
                    _buildTextField(
                      controller: phoneController,
                      labelText: 'téléphone',
                      icon: Icons.phone,
                    ),
                    const SizedBox(height: 16),
                    // Password TextField
                    _buildPasswordField(
                      controller: passwordController,
                    ),
                    const SizedBox(height: 24),
                    // Register Button or Loading Indicator
                    SizedBox(
                      width: double.infinity,
                      child: _isLoading
                          ? CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                themeController.isDarkMode
                                    ? Colors.redAccent
                                    : Colors.black,
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () async {
                                final name = nameController.text.trim();
                                final phone = phoneController.text.trim();
                                final password = passwordController.text.trim();

                                // Phone number validation (only digits)
                                if (phone.isEmpty ||
                                    !RegExp(r'^[0-9]+$').hasMatch(phone)) {
                                  Get.snackbar(
                                      backgroundColor:
                                          Colors.redAccent, // Fond rouge
                                      colorText: Colors.white, // Texte blanc
                                      borderRadius: 10.0, // Coins arrondis
                                      margin: const EdgeInsets.all(
                                          10), // Marge autour du snackbar
                                      padding: const EdgeInsets.all(15),
                                      'Erreur',
                                      'Le numéro de téléphone ne doit contenir que des chiffres.');
                                  return;
                                }

                                // Password validation (minimum 6 characters)
                                if (password.length < 6) {
                                  Get.snackbar(
                                      backgroundColor:
                                          Colors.redAccent, // Fond rouge
                                      colorText: Colors.white, // Texte blanc
                                      borderRadius: 10.0, // Coins arrondis
                                      margin: const EdgeInsets.all(
                                          10), // Marge autour du snackbar
                                      padding: const EdgeInsets.all(15),
                                      'Erreur',
                                      'Le mot de passe doit contenir au moins 6 caractères.');
                                  return;
                                }

                                // Proceed to register if validations pass
                                final signUpBody = SignUpBody(
                                  name: name,
                                  phone: phone,
                                  password: password,
                                );

                                setState(() {
                                  _isLoading = true;
                                });

                                final response = await authController
                                    .registration(signUpBody);

                                setState(() {
                                  _isLoading = false;
                                });

                                if (response.isSuccess) {
                                  Get.snackbar('success', response.message);
                                } else {
                                  Get.to(() => const LoginPage());
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: themeController.isDarkMode
                                    ? Colors.redAccent
                                    : Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 15,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Créer un compte',
                                style: TextStyle(
                                  color: themeController.isDarkMode
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 16),
                    // Login Option
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "J'ai déjà un compte?",
                          style: TextStyle(
                            color: themeController.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed('/login');
                          },
                          child: RichText(
                            text: const TextSpan(
                              text: 'Se connecter',
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
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(
          color: Get.find<ThemeController>().isDarkMode
              ? Colors.white
              : Colors.black,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            width: 2,
            color: Get.find<ThemeController>().isDarkMode
                ? Colors.redAccent
                : Colors.black,
          ),
        ),
        prefixIcon: Icon(
          icon,
          color: Get.find<ThemeController>().isDarkMode
              ? Colors.redAccent
              : Colors.black,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Get.find<ThemeController>().isDarkMode
                ? Colors.redAccent
                : Colors.black,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
            color: Get.find<ThemeController>().isDarkMode
                ? Colors.redAccent
                : Colors.black,
            width: 2.0,
          ),
        ),
      ),
      style: TextStyle(
        color: Get.find<ThemeController>().isDarkMode
            ? Colors.white
            : Colors.black,
      ),
    );
  }

  Widget _buildPasswordField({required TextEditingController controller}) {
    return Obx(() {
      final isDarkMode = Get.find<ThemeController>().isDarkMode;
      final isPasswordVisible =
          Get.find<AuthController>().passwordVisible.value;
      return TextField(
        controller: controller,
        obscureText: !isPasswordVisible,
        decoration: InputDecoration(
          labelText: 'Mot De Passe',
          labelStyle: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: BorderSide(
              width: 2,
              color: isDarkMode ? Colors.redAccent : Colors.black,
            ),
          ),
          prefixIcon: Icon(
            Icons.lock,
            color: isDarkMode ? Colors.redAccent : Colors.black,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: isDarkMode ? Colors.redAccent : Colors.black,
            ),
            onPressed: () {
              Get.find<AuthController>().togglePasswordVisibility();
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
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
      );
    });
  }
}
