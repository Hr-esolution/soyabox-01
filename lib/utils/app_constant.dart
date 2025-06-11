import 'package:flutter/material.dart';

class AppConstant {
  static const String baseUrl = "https://soyabox.ma";
  static const String token = "";
  static const String password = "";
  static const String phone = "";
  static const String registrationUrl = "/api/register";
  static const String loginUrl = "/api/login";
  static const String cartHistoryList = "cart-history-list";
  static const String cartList = "cart-list";
  static const String userInfoUrl = "/api/getuserinfo";
  static const String addAddressUrl = "/api/addresses";
  static const String getAddressUrl = "/api/addresses";
  static const String removeAddress = '/api/addresses';
  static const String addReservation = "/api/reservations";
  static const String reservationHistory = "/api/reservations/history";
  static const String updateFcmTokenUrl = "/api/update-fcm-token";
}

class AppColors {
  // Light theme colors
  static const Color primaryLight = Color(0xFFFFC107); // Amber
  static const Color accentLight = Color(0xFF607D8B); // Blue Grey
  static const Color backgroundLight = Color(0xFFFFFFFF); // White
  static const Color borderLight = Color(0xFFBDBDBD); // Grey

  // Dark theme colors
  static const Color primaryDark = Color(0xFFBF360C); // Dark Orange
  static const Color accentDark = Color(0xFF263238); // Dark Blue Grey
  static const Color backgroundDark = Color(0xFF212121); // Dark Grey
  static const Color borderDark = Color(0xFF37474F); // Blue Grey
}

class DarkThemeColor {
  static const primaryDark = Color(0xFF18172B);
  static const primaryLight = Color(0xFF1F1F30);
}

class LightThemeColor {
  static const primaryDark = Color(0xFFFFFFFF);
  static const primaryLight = Color(0xFFf3f6fa);
  static const accent = Color(0xFFFD8629);
  static const yellow = Color(0xFFFFBA49);
}

const h1Style = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const h2Style = TextStyle(
  fontSize: 19,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const h3Style = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.bold,
  color: Colors.black,
);

const h4StyleLight = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w500,
  color: Colors.black,
);

const h5StyleLight = TextStyle(
  fontSize: 17,
  fontWeight: FontWeight.w400,
  color: Colors.black87,
);

const bodyTextLight = TextStyle(
  fontSize: 13,
  fontWeight: FontWeight.w600,
  color: Colors.black45,
);

const subtitleLight = TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.bold,
  color: Colors.black45,
);

final textFieldStyle = OutlineInputBorder(
  borderRadius: BorderRadius.circular(25),
  borderSide: const BorderSide(color: Colors.transparent),
);
