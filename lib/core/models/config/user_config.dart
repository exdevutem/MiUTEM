import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserConfig extends GetxController {
  static UserConfig get to => Get.find();

  // Theme mode (light or dark)
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  // Other configurations can be added here
  final RxBool notificationsEnabled = true.obs;
  final RxString language = 'en'.obs;

  // Method to toggle theme mode
  void toggleThemeMode() {
    if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.light;
    }
  }

  // Method to enable/disable notifications
  void toggleNotifications() {
    notificationsEnabled.value = !notificationsEnabled.value;
  }

  // Method to change language
  void changeLanguage(String newLanguage) {
    language.value = newLanguage;
  }
}
