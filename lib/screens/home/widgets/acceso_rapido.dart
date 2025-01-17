import 'package:flutter/material.dart';
import 'package:miutem/screens/home/actions/acceso_rapido.dart';
import 'package:miutem/styles/styles.dart';

class AccesoRapido extends StatelessWidget {
  const AccesoRapido({super.key});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child:
                Text("¿Que quieres hacer hoy?", style: StyleText.description),
          ),
          Space.xSmall,
          SizedBox(
            height: 130,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              physics: const AlwaysScrollableScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                CardAccesoRapido(
                  color: AppTheme.lightBlueCard,
                  colorDark: AppTheme.darkBlueCard,
                  label: 'Horario',
                  icon: AppIcons.timetable,
                  onTap: () => visitarHorario(context),
                ),
                const SizedBox(width: 8),
                CardAccesoRapido(
                  color: AppTheme.lightPurpleCard,
                  colorDark: AppTheme.darkPurpleCard,
                  label: 'Notas',
                  icon: AppIcons.calculator,
                  fill: 0,
                  onTap: () => visitarNotas(context),
                ),
                const SizedBox(width: 8),
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
