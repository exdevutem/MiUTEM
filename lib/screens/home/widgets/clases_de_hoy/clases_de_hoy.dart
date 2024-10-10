import 'package:flutter/material.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/screens/home/widgets/clases_de_hoy/card_clase.dart';

class ClasesDeHoy extends StatelessWidget {
  const ClasesDeHoy({super.key});

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

      const CardClase(horaInicio: "9:40", horaFin: "12:50", nombreClase: "Taller de Sistemas de Información", sala: "Lab 3 - M1")
    ],
  );
}
