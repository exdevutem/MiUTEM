import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:miutem/screens/profile/controllers/profile_settings_controller.dart';
import 'package:miutem/styles/styles.dart';
import 'package:miutem/widgets/feature_flag.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class AppSection extends StatefulWidget {

  final ProfileSettingsController profileSettingsController;

  const AppSection({
    super.key,
    required this.profileSettingsController,
  });

  @override
  State<AppSection> createState() => _AppSectionState();
}

class _AppSectionState extends State<AppSection> {

  int tapCount = 0;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Space.small,
      Text('Aplicación', style: Theme.of(context).textTheme.bodyLarge),
      FeatureFlag('perfil.desarrolladores', child: ListTile(
        title: const Text('Desarrolladores de la App'),
        subtitle: const Text('Vé al equipo que desarrolla Mi UTEM'),
        onTap: () {
          // Implementar lógica para ver los desarrolladores de la app
          launchUrl(Uri.parse('https://github.com/exdevutem/miutem/contributors'), mode: LaunchMode.externalApplication);
        },
      )),
      ListTile(
        titleTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        subtitleTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal),
        leading: Image.asset('assets/launcher_icons/prod/icon_splash.png', width: 36),
        title: const Text('Versión de la Aplicación'),
        subtitle: FutureBuilder(
          future: PackageInfo.fromPlatform(),
          builder: (ctx, snapshot) {
            return Skeletonizer(
              enabled: snapshot.connectionState == ConnectionState.waiting,
              child: Text(snapshot.data?.version ?? 'Desconocida'),
            );
          },
        ),
        onTap: () {
          if (dotenv.env['APP_ENV'] == 'prod') {
            return;
          }

          if(tapCount >= 5 && widget.profileSettingsController.debugMode.value) {
            if (context.mounted) {
              removeSnackbar(context);
              showTextSnackbar(context, title: 'Modo de depuración ya habilitado', message: 'El modo de depuración ya está habilitado', duration: const Duration(seconds: 5));
            }
            return;
          }

          if((5-tapCount) <= 3 && (5-tapCount) > 0) {
            if (context.mounted) {
              removeSnackbar(context);
              showTextSnackbar(context, title: '¡Casi lo logras!', message: 'Toca ${5-(tapCount+1)} veces más para habilitar el modo de depuración', duration: const Duration(seconds: 2));
            }
          }

          tapCount++;
          if (tapCount >= 5) {
            widget.profileSettingsController.setDebugMode(true);
            if (context.mounted) {
              removeSnackbar(context);
              showTextSnackbar(context, title: 'Modo de depuración habilitado', message: 'Has habilitado el modo de depuración al tocar varias veces la versión de la aplicación', duration: const Duration(seconds: 5));
            }
          }
        },
      ),
    ],
  );
}
