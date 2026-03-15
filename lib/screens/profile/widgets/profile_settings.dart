import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:miutem/screens/profile/controllers/profile_settings_controller.dart";
import "package:miutem/screens/profile/widgets/settings/app_section.dart";
import "package:miutem/screens/profile/widgets/settings/debug_section.dart";
import "package:miutem/screens/profile/widgets/settings/feedback_section.dart";
import "package:miutem/screens/profile/widgets/settings/pantalla_section.dart";
import "package:miutem/screens/profile/widgets/settings/sistema_section.dart";

class ProfileSettings extends StatelessWidget {

  final controller = Get.put(ProfileSettingsController());

  ProfileSettings({super.key});

  @override
  Widget build(BuildContext context) => Obx(() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SistemaSection(),
      const PantallaSection(),
      const FeedbackSection(),
      controller.debugMode() ? const DebugSection() : const SizedBox.shrink(),
      AppSection(profileSettingsController: controller),
    ],
  ));
}
