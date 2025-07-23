import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/config/user_config.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/screens/profile/widgets/profile_logout.dart';
import 'package:miutem/screens/profile/widgets/profile_header.dart';
import 'package:miutem/screens/profile/widgets/profile_settings.dart';
import 'package:miutem/styles/styles.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Estudiante? estudiante;

  @override
  void initState() {
    super.initState();
    Get.find<AuthService>().login().then((value) {
      setState(() => estudiante = value);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: RefreshIndicator(
      onRefresh: () async {
        setState(() => estudiante = null);
        final newEstudiante = await Get.find<AuthService>().login(forceRefresh: true);
        setState(() => estudiante = newEstudiante);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (estudiante != null) ProfileHeader(title: "Perfil", estudiante: estudiante, isMainScreen: true, actions: [],),
            Space.xSmall,
            const LogOutButton(),
            Space.small,
            const Divider(thickness: 0.5),
            Space.small,
            const ProfileSettings(),
            Space.small,
            ListTile(
              titleTextStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              subtitleTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal),
              leading: Image.asset('assets/launcher_icons/prod/icon_splash.png', width: 36),
              title: const Text('Versión de la Aplicación'),
              subtitle: const Text('4.0.0'),
            ),
          ],
        ),
      ),
    ),
  );
}
