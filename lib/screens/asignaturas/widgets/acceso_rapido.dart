import "package:flutter/material.dart";
import "package:miutem/core/models/user/perfil.dart";
import "package:miutem/screens/asignaturas/actions/acceso_rapido.dart";
import "package:miutem/styles/styles.dart";
import "package:miutem/widgets/feature_flag.dart";

class AccesoRapido extends StatelessWidget {
  const AccesoRapido({super.key});

  @override
  Widget build(BuildContext context) {
    final showEstudianteActions = FeatureFlag.evaluateProfileSync(const [Perfil.estudiante]);
    final cards = <Widget>[
      if (showEstudianteActions)
        CardAccesoRapido(
          color: AppTheme.lightBlueCard,
          colorDark: AppTheme.darkBlueCard,
          label: "Horario",
          icon: AppIcons.timetable,
          onTap: () => visitarHorario(context),
        ),
      CardAccesoRapido(
        color: AppTheme.lightPurpleCard,
        colorDark: AppTheme.darkPurpleCard,
        label: "Notas",
        icon: AppIcons.calculator,
        fill: 0,
        onTap: () => visitarCalculadoraNotas(context),
      ),
      if (showEstudianteActions)
        CardAccesoRapido(
          color: AppTheme.lightSalmonCard,
          colorDark: AppTheme.darkSalmonCard,
          label: "Malla Histórica",
          icon: AppIcons.historicTimetable,
          fill: 0,
          onTap: () => visitarMallaHistorica(context),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Accesos rápidos", style: Theme.of(context).textTheme.bodyLarge),
        Space.extraSmall,
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
