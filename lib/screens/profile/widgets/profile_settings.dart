import 'package:adaptive_theme/adaptive_theme.dart';
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
        onChanged: (value) async {
          await UserConfig.to.toggleNotifications();

          if(value) {
            // Se habilitan las notificaciones, si no hay permisos, se solicita
            if(context.mounted) showTextSnackbar(context, title: 'Notificaciones', message: 'Se han habilitado las notificaciones de la aplicación');
          }
        },
      ),
      Space.small,
      Text('Pantalla', style: Theme.of(context).textTheme.bodyLarge),
      ListTile(
        title: const Text('Tema de la aplicación'),
        subtitle: Text(_getThemeModeText(UserConfig.to.themeMode.value)),
        onTap: () => _showThemeModeDialog(context, UserConfig.to),
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
        onTap: () => {

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
  String _getThemeModeText(AdaptiveThemeMode mode) {
    switch (mode) {
      case AdaptiveThemeMode.light:
        return 'Claro';
      case AdaptiveThemeMode.dark:
        return 'Oscuro';
      case AdaptiveThemeMode.system:
        return 'Sistema';
    }
  }

  // Muestra el dialogo para cambiar el tema
  void _showThemeModeDialog(BuildContext context, UserConfig userConfig) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Seleccionar Tema'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: AdaptiveThemeMode.values.map((mode) => RadioListTile<AdaptiveThemeMode>(
            title: Text(_getThemeModeText(mode)),
            value: mode,
            groupValue: userConfig.themeMode.value,
            onChanged: (AdaptiveThemeMode? value) {
              if (value == null) {
                return;
              }

              userConfig.changeThemeMode(value);
              AdaptiveTheme.of(context).setThemeMode(mode);
              Navigator.of(context).pop();
            },
          )).toList(),
        ),
      ),
    );
  }
}
