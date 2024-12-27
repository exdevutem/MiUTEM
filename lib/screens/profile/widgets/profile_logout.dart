import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/config/user_config.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/styles/styles.dart';

class LogOutButton extends StatefulWidget {
  const LogOutButton({super.key});

  @override
  State<LogOutButton> createState() => _LogOutButtonState();
}

class _LogOutButtonState extends State<LogOutButton> {
  bool _showElements = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _showElements = false);
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() => _showElements = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final userTheme = UserConfig.to.themeMode.value;
      final isDarkMode = userTheme == ThemeMode.dark;
      return AnimatedOpacity(
        opacity: _showElements ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor: WidgetStateProperty.all(
                      isDarkMode ? AppTheme.white : const Color.fromARGB(255, 104, 7, 0),
                    ),
                    backgroundColor: WidgetStateProperty.all(
                      isDarkMode ? AppTheme.darkGreenCard : AppTheme.lightSalmonCard,
                    ),
                    elevation: WidgetStateProperty.all(0),
                  ),
                  child: const Text('Cerrar Sesión'),
                  onPressed: () => Get.find<AuthService>().logout(context: context),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}