import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/config/user_config.dart';
import 'package:miutem/styles/styles.dart';

class ProfileSettings extends StatelessWidget {
  const ProfileSettings({super.key});

  @override
  Widget build(BuildContext context) => Obx(() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Sistema', style: Theme.of(context).textTheme.bodyLarge),
      SwitchListTile(
        title: const Text('Habilitar Notificaciones'),
        subtitle: const Text('Recibir notificaciones de la aplicación'),
        value: UserConfig.to.notificationsEnabled.value,
        onChanged: (value) => UserConfig.to.toggleNotifications(),
      ),
      Space.small,
      Text('Pantalla', style: Theme.of(context).textTheme.bodyLarge),
      ListTile(
        title: const Text('Tema de la aplicación'),
        subtitle: Text(_getThemeModeText(UserConfig.to.themeMode.value), style: Theme.of(context).textTheme.bodyMedium),
        onTap: () => _showThemeModeDialog(context, UserConfig.to),
      ),
      ListTile(
        title: const Text('Color de la aplicación'),
        subtitle: const Text('Selecciona el color de la aplicación'),
        trailing: DropdownButton<ThemeMode>(
          value: UserConfig.to.themeMode.value,
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
          onChanged: (newMode) => UserConfig.to.themeMode.value = newMode!,
        ),
      ),
      Space.small,
      Text('Feedback', style: Theme.of(context).textTheme.bodyLarge),
      ListTile(
        title: const Text('Reportar un Bug'),
        subtitle: const Text('Reportar un bug en la aplicación'),
        onTap: () {
          // Implementar lógica para reportar un bug
        },
      ),
      ListTile(
        title: const Text('Sugerencias'),
        subtitle: const Text('Déjanos tus opiniones sobre la App'),
        onTap: () {
          // Implementar lógica para sugerencias
        },
      ),
      ListTile(
        title: const Text('Desarrolladores de la App'),
        subtitle: const Text('Vé al equipo que desarrolla Mi UTEM'),
        onTap: () {
          // Implementar lógica para ver los desarrolladores de la app
        },
      ),
    ],
  ));

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
