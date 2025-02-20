import 'package:flutter/material.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/styles/styles.dart';
import 'package:flutter/services.dart';

class TopNavigation extends StatelessWidget implements PreferredSizeWidget {

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  final Estudiante? estudiante;
  final bool isMainScreen;
  final String title;

  const TopNavigation({
    super.key,
    this.isMainScreen = false,
    this.title = '',
    this.estudiante
  });

  @override
  Widget build(BuildContext context) => AppBar(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Theme.of(context).appBarTheme.backgroundColor,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
    ),
    leading: isMainScreen ? (estudiante != null ? Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Theme.of(context).colorScheme.primary, // Asegúrate de que se note
        child: Text(estudiante?.primerNombre.substring(0, 1) ?? '',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 24,
            color: Theme.of(context).colorScheme.onPrimary, // Asegúrate de que el texto sea visible
          ),
        ),
      ),
    ) : Container()) : BackButton(color: Theme.of(context).colorScheme.onSurface),
    title: Row(
      children: [
        if (title != '') Text(title,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 20,
          ),
        ),
      ],
    ),
  );
}
