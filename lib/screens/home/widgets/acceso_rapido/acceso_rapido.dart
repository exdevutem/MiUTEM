import 'package:flutter/material.dart';
import 'package:miutem/core/utils/style_text.dart';
import 'package:miutem/core/utils/theme.dart';
import 'package:miutem/screens/home/widgets/acceso_rapido/card_acceso_rapido.dart';
import 'package:miutem/widgets/icons.dart';

class AccesoRapido extends StatelessWidget {
  const AccesoRapido({super.key});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //todo: Formatear los textos y transformarlos en un theme
          Text(
            "¿Que quieres hacer hoy?",
            style: StyleText.description,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardAccesoRapido(
                  color: AppTheme.lightBlueCard,
                  colorDark: AppTheme.darkBlueCard,
                  label: 'Horario',
                  icon: AppIcons.timetable,
                  onTap: () => {}),
              CardAccesoRapido(
                  color: AppTheme.lightPurpleCard,
                  colorDark: AppTheme.darkPurpleCard,
                  label: 'Notas',
                  icon: AppIcons.calculator,
                  fill: 0,
                  onTap: () => {}),
              CardAccesoRapido(
                  color: AppTheme.lightYellowCard,
                  colorDark: AppTheme.darkYellowCard,
                  label: 'Apuntes',
                  icon: AppIcons.subjectsMarker,
                  fill: 0,
                  onTap: () => {}),
            ],
          )
        ],
      );
}
