import 'package:flutter/material.dart';
import 'package:miutem/core/utils/style_text.dart';
import 'package:miutem/core/utils/theme.dart';
import 'package:miutem/widgets/cards/card_acceso_rapido.dart';
import 'package:miutem/widgets/icons.dart';

class AccesoRapido extends StatelessWidget {
  const AccesoRapido({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Accesos rápidos", style: StyleText.description),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CardAccesoRapido(color: AppTheme.lightBlueCard, colorDark: AppTheme.darkBlueCard, label: 'Horario', icon: AppIcons.timetable, onTap: () => {}),
          CardAccesoRapido(color: AppTheme.lightSalmonCard, colorDark: AppTheme.darkSalmonCard, label: 'Malla Histórica', icon: AppIcons.historicTimetable, fill: 0, onTap: () => {}),
          CardAccesoRapido(color: AppTheme.lightPurpleCard, colorDark: AppTheme.darkPurpleCard, label: 'Cálculo de Notas', icon: AppIcons.calculator, fill: 0, onTap: () => {}),
        ],
      )
    ],
  );
}
