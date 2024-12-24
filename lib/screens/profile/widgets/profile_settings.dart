import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/config/user_config.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final userConfig = UserConfig.to;
      return Column(
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: userConfig.notificationsEnabled.value,
            onChanged: (value) => userConfig.toggleNotifications(),
          ),
          ListTile(
            title: const Text('Theme Mode'),
            trailing: DropdownButton<ThemeMode>(
              value: userConfig.themeMode.value,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Light'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Dark'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
              ],
              onChanged: (newMode) => userConfig.themeMode.value = newMode!,
            ),
          ),
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: userConfig.language.value,
              items: const [
                DropdownMenuItem(
                  value: 'en',
                  child: Text('English'),
                ),
                DropdownMenuItem(
                  value: 'es',
                  child: Text('Spanish'),
                ),
              ],
              onChanged: (newLanguage) => userConfig.changeLanguage(newLanguage!),
            ),
          ),
        ],
      );
    });
  }
}
