import "package:flutter/material.dart";
import "package:miutem/core/models/config/user_config.dart";
import "package:miutem/screens/profile/actions/theme.dart";
import "package:miutem/screens/profile/widgets/modals/theme_mode_dialog.dart";
import "package:miutem/styles/theme/space.dart";

class PantallaSection extends StatelessWidget {
  const PantallaSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Space.small,
      Text("Pantalla", style: Theme.of(context).textTheme.bodyLarge),
      ListTile(
        title: const Text("Tema de la aplicación"),
        subtitle: Text(getThemeModeText(UserConfig.to.themeMode.value)),
        onTap: () => _showThemeModeDialog(context, UserConfig.to),
      ),
    ],
  );

  // Muestra el dialogo para cambiar el tema
  void _showThemeModeDialog(BuildContext context, UserConfig userConfig) {
    showDialog(
      context: context,
      builder: (BuildContext context) => const ThemeModeDialog(),
    );
  }
}
