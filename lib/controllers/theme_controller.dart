import 'package:soyabox/utils/app_theme.dart';
import 'package:get/get.dart';
// Import your theme file

class ThemeController extends GetxController {
  bool isDarkMode = false;

  void toggleTheme() {
    isDarkMode = !isDarkMode;
    Get.changeTheme(isDarkMode ? AppTheme.darkTheme : AppTheme.lightTheme);
    update(); // Rebuilds widgets listening to this controller
  }
}
