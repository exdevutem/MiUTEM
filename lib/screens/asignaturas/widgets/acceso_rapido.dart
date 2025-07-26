import 'package:flutter/material.dart';
import 'package:miutem/styles/styles.dart';
import 'package:miutem/screens/asignaturas/actions/acceso_rapido.dart';

class AccesoRapido extends StatelessWidget {
  const AccesoRapido({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Accesos rápidos", style: Theme.of(context).textTheme.bodyLarge),
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
              onTap: () => visitarHorario(context),
            ),
            const SizedBox(width: 10),
            CardAccesoRapido(
              color: AppTheme.lightSalmonCard,
              colorDark: AppTheme.darkSalmonCard,
              label: 'Malla Histórica',
              icon: AppIcons.historicTimetable,
              fill: 0,
              onTap: () => {},
            ),
            const SizedBox(width: 10),
            CardAccesoRapido(
              color: AppTheme.lightPurpleCard,
              colorDark: AppTheme.darkPurpleCard,
              label: 'Cálculo de Notas',
              icon: AppIcons.calculator,
              fill: 0,
              onTap: () => visitarCalculadoraNotas(context),
            ),
          ],
        ),
      ),
    ],
  );
}
