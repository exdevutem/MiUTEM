import "package:flutter/material.dart";
import "package:miutem/core/models/user/perfil.dart";
import "package:miutem/screens/asignaturas/actions/acceso_rapido.dart";
import "package:miutem/styles/styles.dart";
import "package:miutem/widgets/feature_flag.dart";

class AccesoRapido extends StatelessWidget {
  const AccesoRapido({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Accesos rápidos", style: Theme.of(context).textTheme.bodyLarge),
      Space.extraSmall,
      SizedBox(
        height: 130,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            FeatureFlag.profiles(
              const [Perfil.estudiante],
              showProfileRestrictionMessage: false,
              child: CardAccesoRapido(
                color: AppTheme.lightBlueCard,
                colorDark: AppTheme.darkBlueCard,
                label: "Horario",
                icon: AppIcons.timetable,
                onTap: () => visitarHorario(context),
              ),
            ),
            HorizontalSpace.extraSmall,
            CardAccesoRapido(
              color: AppTheme.lightPurpleCard,
              colorDark: AppTheme.darkPurpleCard,
              label: "Notas",
              icon: AppIcons.calculator,
              fill: 0,
              onTap: () => visitarCalculadoraNotas(context),
            ),
            HorizontalSpace.extraSmall,
            FeatureFlag.profiles(
              const [Perfil.estudiante],
              showProfileRestrictionMessage: false,
              child: CardAccesoRapido(
                color: AppTheme.lightSalmonCard,
                colorDark: AppTheme.darkSalmonCard,
                label: "Malla Histórica",
                icon: AppIcons.historicTimetable,
                fill: 0,
                onTap: () => visitarMallaHistorica(context),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
