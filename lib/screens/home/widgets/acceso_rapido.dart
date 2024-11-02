import 'package:flutter/material.dart';
import 'package:miutem/core/utils/style_text.dart';
import 'package:miutem/core/utils/theme.dart';
import 'package:miutem/screens/home/actions/acceso_rapido.dart';
import 'package:miutem/widgets/cards/card_acceso_rapido.dart';
import 'package:miutem/widgets/icons.dart';

class AccesoRapido extends StatelessWidget {

  const AccesoRapido({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("¿Que quieres hacer hoy?", style: StyleText.description),
      const SizedBox(height: 10),
      SizedBox(
        height: 130,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            CardAccesoRapido(
              color: AppTheme.lightBlueCard,
              colorDark: AppTheme.darkBlueCard,
              label: 'Horario',
              icon: AppIcons.timetable,
              onTap: () => {},
            ),
            const SizedBox(width: 10), // Add space between cards
            CardAccesoRapido(
              color: AppTheme.lightPurpleCard,
              colorDark: AppTheme.darkPurpleCard,
              label: 'Notas',
              icon: AppIcons.calculator,
              fill: 0,
              onTap: () => {},
            ),
            const SizedBox(width: 10), // Add space between cards
            CardAccesoRapido(
              color: AppTheme.lightGreenCard,
              colorDark: AppTheme.darkGreenCard,
              label: 'Novedades',
              icon: AppIcons.updates,
              fill: 0,
              onTap: () => visitarApuntes(context),
            ),
          ],
        ),
      ),
    ],
  );
}