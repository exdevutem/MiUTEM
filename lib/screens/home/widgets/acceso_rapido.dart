import "package:flutter/material.dart";
import "package:miutem/core/models/user/estudiante.dart";
import "package:miutem/core/models/user/perfil.dart";
import "package:miutem/screens/home/actions/acceso_rapido.dart";
import "package:miutem/styles/styles.dart";

class AccesoRapido extends StatelessWidget {
  final Estudiante? estudiante;

  const AccesoRapido({super.key, this.estudiante});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("¿Que quieres hacer hoy?", style: Theme.of(context).textTheme.bodyMedium),
      Space.extraSmall,
      SizedBox(
        height: 130,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          children: [
            if (estudiante?.perfiles.contains(Perfil.estudiante) ?? false)
              CardAccesoRapido(
                color: AppTheme.lightBlueCard,
                colorDark: AppTheme.darkBlueCard,
                label: "Horario",
                icon: AppIcons.timetable,
                onTap: () => visitarHorario(context),
              ),
            if (estudiante?.perfiles.contains(Perfil.estudiante) ?? false)
              HorizontalSpace.extraSmall,
            CardAccesoRapido(
              color: AppTheme.lightPurpleCard,
              colorDark: AppTheme.darkPurpleCard,
              label: "Notas",
              icon: AppIcons.calculator,
              fill: 0,
              onTap: () => visitarNotas(context),
            ),
            HorizontalSpace.extraSmall,
            CardAccesoRapido(
              color: AppTheme.lightGreenCard,
              colorDark: AppTheme.darkGreenCard,
              label: "Novedades",
              icon: AppIcons.updates,
              fill: 0,
              onTap: () => visitarNovedades(context),
            ),
          ],
        ),
      ),
    ],
  );
}
