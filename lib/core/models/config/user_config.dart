import 'package:adaptive_theme/adaptive_theme.dart' show AdaptiveThemeMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserConfig extends GetxController {
  static UserConfig get to => Get.find();

  final RxBool notificationsEnabled = true.obs;
  final Rx<AdaptiveThemeMode> themeMode = AdaptiveThemeMode.system.obs;
  final RxString language = 'en'.obs;

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  @override
  void onInit() {
    super.onInit();
    initialize();
  }

  Future<void> initialize() async {
    notificationsEnabled.value = (await _storage.read(key: 'notificationsEnabled')) == 'true';
    String userTheme = await _storage.read(key: 'themeMode') ?? ThemeMode.system.toString();
    themeMode.value = AdaptiveThemeMode.values.firstWhere((e) => e.toString() == userTheme);
    language.value = await _storage.read(key: 'language') ?? 'en';
  }

  Future<void> toggleNotifications() async {
    notificationsEnabled.value = !notificationsEnabled.value;
    await _storage.write(key: 'notificationsEnabled', value: notificationsEnabled.value.toString());
  }

  Future<void> changeThemeMode(AdaptiveThemeMode mode) async {
    themeMode.value = mode;
    await _storage.write(key: 'themeMode', value: mode.toString());
  }

}