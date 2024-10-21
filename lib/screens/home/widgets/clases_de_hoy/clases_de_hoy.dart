import 'package:flutter/material.dart';
import 'package:miutem/core/models/horario.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/screens/home/widgets/clases_de_hoy/asignaturas_de_hoy.dart';

class ClasesDeHoy extends StatelessWidget {
  final String? error;
  final List<BloqueHorario>? bloques;
  final Function() onRefresh;

  const ClasesDeHoy({super.key, required this.error, required this.bloques, required this.onRefresh});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Clases de Hoy", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(getToday(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
        ],
      ),
      const SizedBox(height: 10),
      AsignaturasDeHoy(error: error, bloques: bloques, onRefresh: onRefresh),
    ],
  );
}