import 'package:flutter/material.dart';
import 'package:miutem/core/utils/style_text.dart';
import 'package:miutem/core/utils/theme.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({super.key});

  /**
   *  Card de informacion para la screen de Apuntes
   *  TODO agregar temas, modificar tamaño maximo de la card
   */
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.lightYellowCard,
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                  Icons.lightbulb_circle,
                weight: 700,
                size: 40.0,
                  color: AppTheme.lightGreenCard,
              ),
              const SizedBox(width: 20.0),
              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Organiza tu día a día',
                        style: StyleText.header,
                      ),
                      const SizedBox(height: 2.0),
                      Text(
                        'Crea tareas y recordatorios. Mantén todo bajo control, directo desde tu App Mi UTEM',
                        style: StyleText.description,
                      ),
                    ],
                  ),
              ),
            ],
          ),
      ),
    );
  }
}