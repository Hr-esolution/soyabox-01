import 'package:flutter/material.dart';
import 'package:soyabox/controllers/theme_controller.dart';
import 'package:get/get.dart';

class OrderConfirmationPage extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();
  final String orderId;
  final String message;

  OrderConfirmationPage({
    required this.orderId,
    required this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Automatically navigate to home page after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed('/'); // Navigate to the home page
    });

    // Determine theme mode
    bool isDarkMode = themeController.isDarkMode;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: isDarkMode ? Colors.greenAccent : Colors.green,
                size: 100,
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black87,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
