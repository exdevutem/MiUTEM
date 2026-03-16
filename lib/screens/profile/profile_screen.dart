import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:miutem/core/models/user/estudiante.dart";
import "package:miutem/core/services/auth_service.dart";
import "package:miutem/screens/profile/widgets/profile_logout.dart";
import "package:miutem/screens/profile/widgets/profile_header.dart";
import "package:miutem/screens/profile/widgets/profile_settings.dart";
import "package:miutem/styles/styles.dart";

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
            if (estudiante != null) ProfileHeader(usuario: estudiante),
            Space.extraSmall,
            const LogOutButton(),
            Space.small,
            const Divider(thickness: 0.5),
            Space.small,
            ProfileSettings(),
          ],
        ),
      ),
    ),
  );
}
