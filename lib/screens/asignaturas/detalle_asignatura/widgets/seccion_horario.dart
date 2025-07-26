import 'package:flutter/material.dart';
import 'package:miutem/core/models/asignaturas/asignatura.dart';
import 'package:miutem/screens/asignaturas/detalle_asignatura/models/horario_bloque.dart';
import 'package:miutem/screens/asignaturas/detalle_asignatura/widgets/card_horario.dart';
import 'package:miutem/screens/horario/horario_screen.dart';
import 'package:miutem/styles/styles.dart';

class SeccionHorario extends StatelessWidget {
  final Asignatura asignatura;

  const SeccionHorario({
    super.key,
    required this.asignatura,
  });

  List<HorarioBloque> _parseHorario() {
    final List<HorarioBloque> bloques = [];

    if (asignatura.horario == null || asignatura.horario!.isEmpty) {
      return bloques;
    }

    // Parse horario string: "lunes | 13:00 - 13:45 / 13:45 - 14:30 || martes | 9:40 - 10:25 / 10:25 - 11:10 || jueves | 11:20 - 12:05 / 12:05 - 12:50"
    final dias = asignatura.horario!.split(' || ');
    final salas = asignatura.sala?.split(', ') ?? [];

    for (int i = 0; i < dias.length; i++) {
      final partes = dias[i].split(' | ');
      if (partes.length != 2) continue;

      final dia = partes[0].trim();
      final horariosDelDia = partes[1].trim();
      final bloquesDeTiempo = horariosDelDia.split(' / ');

      if (bloquesDeTiempo.length >= 2) {
        final primerBloque = bloquesDeTiempo[0].split(' - ');
        final ultimoBloque = bloquesDeTiempo.last.split(' - ');

        if (primerBloque.length == 2 && ultimoBloque.length == 2) {
          final horaInicio = primerBloque[0].trim();
          final horaFin = ultimoBloque[1].trim();
          final sala = i < salas.length ? salas[i].trim() : 'Sin sala';

          bloques.add(HorarioBloque(
            dia: dia,
            horaInicio: horaInicio,
            horaFin: horaFin,
            nombreAsignatura: asignatura.nombre,
            sala: sala,
          ));
        }
      }
    }

    return bloques;
  }

  @override
  Widget build(BuildContext context) {
    final bloques = _parseHorario();

    if (bloques.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Horario',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            GestureDetector(
              child: Text(
                'Ver más',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
              ),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const HorarioScreen())),
            ),
          ],
        ),
        Space.xSmall,
        ...bloques.map((bloque) => CardHorario(bloque: bloque)),
      ],
    );
  }
}
