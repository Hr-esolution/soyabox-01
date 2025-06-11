import 'dart:async';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class NetworkService {
  bool isConnected = true;
  Timer? _timer;

  // Method to start periodic network checks
  void startMonitoringConnection(Function onConnectionRestored) {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      bool previousConnectionStatus = isConnected;
      isConnected = await _checkInternetConnection();

      if (!isConnected && previousConnectionStatus) {
        // Lost connection
        _showNoInternetSnackBar();
      } else if (isConnected && !previousConnectionStatus) {
        // Internet restored
        _dismissNoInternetSnackBar();
        onConnectionRestored(); // Trigger necessary data reloads
      }
    });
  }

  // Method to stop the periodic checks when not needed
  void stopMonitoringConnection() {
    _timer?.cancel();
  }

  // Check for internet connection by pinging an external server
  Future<bool> _checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }

  // Show a persistent snackbar for no internet connection
  void _showNoInternetSnackBar() {
    Get.snackbar(
      "No Internet Connection",
      "Please check your internet settings.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      isDismissible: false, // Keep it displayed until connection is restored
      duration: const Duration(days: 365), // Keep showing the message
    );
  }

  // Dismiss the snackbar when the internet is back
  void _dismissNoInternetSnackBar() {
    Get.closeAllSnackbars(); // Dismiss any snackbar currently being shown
    Get.snackbar(
      "Internet Restored",
      "You are now connected.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2), // Show confirmation for 2 seconds
    );
  }
}
