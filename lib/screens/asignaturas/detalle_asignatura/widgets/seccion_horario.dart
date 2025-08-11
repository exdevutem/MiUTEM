import 'package:flutter/material.dart';
import 'package:miutem/screens/asignaturas/detalle_asignatura/models/horario_bloque.dart';
import 'package:miutem/screens/asignaturas/detalle_asignatura/widgets/card_horario.dart';
import 'package:miutem/screens/horario/horario_screen.dart';
import 'package:miutem/styles/styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

final dummyBloques = [
  HorarioBloque(dia: 'Lunes', horaInicio: '8:00', horaFin: '20:00', nombreAsignatura: 'Club de Desarrollo Experimental', sala: 'M8-103'),
  HorarioBloque(dia: 'Martes', horaInicio: '8:00', horaFin: '20:00', nombreAsignatura: 'Club de Desarrollo Experimental', sala: 'M8-103'),
  HorarioBloque(dia: 'Miércoles', horaInicio: '8:00', horaFin: '20:00', nombreAsignatura: 'Club de Desarrollo Experimental', sala: 'M8-103'),
  HorarioBloque(dia: 'Jueves', horaInicio: '8:00', horaFin: '20:00', nombreAsignatura: 'Club de Desarrollo Experimental', sala: 'M8-103'),
];

class SeccionHorario extends StatelessWidget {

  final List<HorarioBloque> bloques;

  const SeccionHorario({
    super.key,
    required this.bloques,
  });

  @override
  Widget build(BuildContext context) => Skeletonizer(
    enabled: bloques.isEmpty,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Skeleton.keep(child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Horario',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            GestureDetector(
              child: Text(
                'Ver más',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const HorarioScreen())),
            ),
          ],
        )),
        const Skeleton.keep(child: Space.xSmall),
        ...(bloques.isEmpty ? dummyBloques : bloques).map((bloque) => CardHorario(bloque: bloque))
      ],
    ),
  );
}

