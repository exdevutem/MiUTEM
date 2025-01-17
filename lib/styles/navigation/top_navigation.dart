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
    required this.isMainScreen,
    required this.title,
    this.estudiante,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Theme.of(context).appBarTheme.backgroundColor,
        statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      leading: isMainScreen
          ? FractionallySizedBox(
              alignment: Alignment.center,
              widthFactor: 0.7, // 70% del tamaño de su padre (ancho)
              heightFactor: 0.7, // 70% del tamaño de su padre (alto)
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double fontSize = (constraints.maxWidth * 0.6).clamp(
                      0.0,
                      constraints.maxHeight *
                          0.6); // Aseguramos que el texto respete las dimensiones de su contenedor padre (FractionallySizedBox) tanto en ancho como en alto
                  return CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      estudiante?.primerNombre.substring(0, 1) ?? '',
                      style: StyleText.headline.copyWith(
                        fontSize: fontSize,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  );
                },
              ),
            )
          : BackButton(
              color: Theme.of(context).colorScheme.onSurface,
            ),
      title: Row(
        children: [
          if (isMainScreen)
            Text(
              title,
              style: StyleText.label.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
                fontSize: 20,
              ),
            ),
        ],
      ),
    );
  }
}
