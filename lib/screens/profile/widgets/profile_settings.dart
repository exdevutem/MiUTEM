import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/config/user_config.dart';
import 'package:miutem/styles/styles.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final userConfig = UserConfig.to;
      final textColor = Theme.of(context).textTheme.bodyMedium?.color;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sistema',
              style: StyleText.description.copyWith(color: textColor)),
          SwitchListTile(
            title: Text('Habilitar Notificaciones',
                style: StyleText.header.copyWith(color: textColor)),
            subtitle: Text('Recibir notificaciones de la aplicación',
                style: StyleText.body.copyWith(color: textColor)),
            value: userConfig.notificationsEnabled.value,
            onChanged: (value) => userConfig.toggleNotifications(),
          ),
          Space.small,
          Text('Pantalla',
              style: StyleText.description.copyWith(color: textColor)),
          ListTile(
            title: Text('Tema de la aplicación',
                style: StyleText.header.copyWith(color: textColor)),
            subtitle: Text(_getThemeModeText(userConfig.themeMode.value),
                style: StyleText.body.copyWith(color: textColor)),
            onTap: () => _showThemeModeDialog(context, userConfig),
          ),
          ListTile(
            title: Text('Color de la aplicación',
                style: StyleText.header.copyWith(color: textColor)),
            subtitle: Text('Selecciona el color de la aplicación',
                style: StyleText.body.copyWith(color: textColor)),
            trailing: DropdownButton<ThemeMode>(
              value: userConfig.themeMode.value,
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('Sistema'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Claro'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Oscuro'),
                ),
              ],
              onChanged: (newMode) => userConfig.themeMode.value = newMode!,
            ),
          ),
          Space.small,
          Text('Feedback', style: StyleText.description.copyWith(color: textColor)),
          ListTile(
            title: Text('Reportar un Bug', style: StyleText.header.copyWith(color: textColor)),
            subtitle: Text('Reportar un bug en la aplicación', style: StyleText.body.copyWith(color: textColor)),
            onTap: () {
              // Implementar lógica para reportar un bug
            },
          ),
          ListTile(
            title: Text('Sugerencias', style: StyleText.header.copyWith(color: textColor)),
            subtitle: Text('Déjanos tus opiniones sobre la App', style: StyleText.body.copyWith(color: textColor)),
            onTap: () {
              // Implementar lógica para sugerencias
            },
          ),
          ListTile(
            title: Text('Desarrolladores de la App', style: StyleText.header.copyWith(color: textColor)),
            subtitle: Text('Vé al equipo que desarrolla Mi UTEM', style: StyleText.body.copyWith(color: textColor)),
            onTap: () {
              // Implementar lógica para ver los desarrolladores de la app
            },
          ),
        ],
      );
    });
  }
// Cambia el tema del sistema
  String _getThemeModeText(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Claro';
      case ThemeMode.dark:
        return 'Oscuro';
      case ThemeMode.system:
      default:
        return 'Sistema';
    }
  }
// Muestra el dialogo para cambiar el tema
  void _showThemeModeDialog(BuildContext context, UserConfig userConfig) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final textColor = Theme.of(context).textTheme.bodySmall?.color;
        return AlertDialog(
          title: const Text('Seleccionar Tema'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ThemeMode.values.map((mode) {
              return RadioListTile<ThemeMode>(
                title: Text(_getThemeModeText(mode),
                    style: TextStyle(color: textColor)),
                value: mode,
                groupValue: userConfig.themeMode.value,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    userConfig.changeThemeMode(value);
                    Navigator.of(context).pop();
                  }
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
