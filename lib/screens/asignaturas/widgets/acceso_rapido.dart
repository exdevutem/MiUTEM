import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miutem/core/utils/theme.dart';
import 'package:miutem/widgets/cards/card_acceso_rapido.dart';
import 'package:miutem/widgets/icons.dart';

class AccesoRapido extends StatelessWidget {
  const AccesoRapido({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      //todo: Formatear los textos y transformarlos en un theme
      Text("Accesos rápidos", style: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.01,
      )),
      const SizedBox(height: 10),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CardAccesoRapido(color: AppTheme.lightBlueCard, colorDark: AppTheme.darkBlueCard, label: 'Horario', icon: AppIcons.timetable, onTap: () => {}),
          CardAccesoRapido(color: AppTheme.lightSalmonCard, colorDark: AppTheme.darkSalmonCard, label: 'Malla Histórica', icon: AppIcons.historicTimetable, fill: 0, onTap: () => {}),
          CardAccesoRapido(color: AppTheme.lightPurpleCard, colorDark: AppTheme.darkPurpleCard, label: 'Calculadora', icon: AppIcons.calculator, fill: 0, onTap: () => {}),
        ],
      )
    ],
  );
}
