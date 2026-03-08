import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:miutem/core/models/config/user_config.dart';
import 'package:miutem/screens/profile/actions/theme.dart';

class ThemeModeDialog extends StatelessWidget {
  const ThemeModeDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Seleccionar Tema'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      children: AdaptiveThemeMode.values.map((mode) => RadioListTile<AdaptiveThemeMode>(
        title: Text(getThemeModeText(mode)),
        value: mode,
        groupValue: UserConfig.to.themeMode.value,
        onChanged: (AdaptiveThemeMode? value) {
          if (value == null) {
            return;
          }

          UserConfig.to.changeThemeMode(value);
          AdaptiveTheme.of(context).setThemeMode(mode);
          Navigator.of(context).pop();
        },
      )).toList(),
    ),
  );
}
