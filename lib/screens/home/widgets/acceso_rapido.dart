import "package:flutter/material.dart";
import "package:miutem/core/models/user/estudiante.dart";
import "package:miutem/core/models/user/perfil.dart";
import "package:miutem/screens/home/actions/acceso_rapido.dart";
import "package:miutem/styles/styles.dart";

class AccesoRapido extends StatelessWidget {
  final Estudiante? estudiante;

  const AccesoRapido({super.key, this.estudiante});

  @override
Widget build(BuildContext context) {
  final isEstudiante = estudiante?.perfiles.contains(Perfil.estudiante) ?? false;

  // Definimos las tarjetas siguiendo la lógica de dev
  final cards = <Widget>[
    if (isEstudiante)
      CardAccesoRapido(
        color: AppTheme.lightBlueCard,
        colorDark: AppTheme.darkBlueCard,
        label: "Horario",
        icon: AppIcons.timetable,
        flagKey: "horario",
        onTap: () => visitarHorario(context),
      ),
    CardAccesoRapido(
      color: AppTheme.lightPurpleCard,
      colorDark: AppTheme.darkPurpleCard,
      label: "Notas",
      icon: AppIcons.calculator,
      fill: 0,
      flagKey: "calculadora",
      onTap: () => visitarNotas(context),
    ),
    CardAccesoRapido(
      color: AppTheme.lightGreenCard,
      colorDark: AppTheme.darkGreenCard,
      label: "Novedades",
      icon: AppIcons.updates,
      fill: 0,
      flagKey: "novedades",
      onTap: () => visitarNovedades(context),
    ),
  ];

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("¿Qué quieres hacer hoy?", style: Theme.of(context).textTheme.bodyMedium),
      Space.extraSmall,
      // Usamos Row con Expanded para el ajuste de pantalla (Fix de la rama antigua)
      Row(
        children: [
          for (int i = 0; i < cards.length; i++) ...[
            if (i > 0) const SizedBox(width: 8),
            Expanded(child: cards[i]),
          ]
        ],
      ),
    ],
  );
}
}