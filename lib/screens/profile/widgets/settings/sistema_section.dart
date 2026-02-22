import 'package:flutter/material.dart';
import 'package:miutem/core/models/config/user_config.dart';
import 'package:miutem/styles/snackbar.dart';
import 'package:miutem/widgets/feature_flag.dart';

class SistemaSection extends StatelessWidget {
  const SistemaSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Sistema', style: Theme.of(context).textTheme.bodyLarge),
      FeatureFlag('perfil.notificaciones', child: SwitchListTile(
        title: const Text('Habilitar Notificaciones'),
        subtitle: const Text('Recibir notificaciones de la aplicación'),
        value: UserConfig.to.notificationsEnabled.value,
        onChanged: (value) async {
          await UserConfig.to.toggleNotifications();

          if (value) {
            // Se habilitan las notificaciones, si no hay permisos, se solicita
            if (context.mounted) showTextSnackbar(context, title: 'Notificaciones', message: 'Se han habilitado las notificaciones de la aplicación');
          }
        },
      ))
    ],
  );
}
