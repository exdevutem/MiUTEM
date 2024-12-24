import 'package:flutter/material.dart';
import 'package:miutem/styles/styles.dart';

/// Widget diseñado para mostrar error y ofrecer recarga
/// de datos. Diseñado para ser utilizado dentro de listas
/// de datos en la pantalla de inicio, asignaturas, etc.
class ErrorRefresh extends StatelessWidget {
  final String title;
  final Function() onTap;

  const ErrorRefresh({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 50),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Text(title, style: const TextStyle(fontSize: 18), textAlign: TextAlign.center),
            const Text("Presiona para refrescar.", style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
            const Icon(AppIcons.refresh, size: 32), // Botón para reintentar
          ],
        ),
      ),
    ),
  );
}
