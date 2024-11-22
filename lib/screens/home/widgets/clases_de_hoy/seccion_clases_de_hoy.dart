import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miutem/core/models/horario.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/screens/home/widgets/clases_de_hoy/lista_clases.dart';

class SeccionClasesDeHoy extends StatefulWidget {

  final String? errorAlCargarHorario;
  final List<BloqueHorario>? bloques;
  final void Function({bool forceRefresh}) cargarHorario;

  const SeccionClasesDeHoy({super.key, required this.errorAlCargarHorario, required this.bloques, required this.cargarHorario});

  @override
  State<SeccionClasesDeHoy> createState() => _SeccionClasesDeHoyState();
}

class _SeccionClasesDeHoyState extends State<SeccionClasesDeHoy> {

  String today = getToday();

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 30), (timer) {
      final today = getToday();

      // Se verifica que sea la hora de inicio (o la de fin) para actualizar la tarjeta.
      if(today != this.today) {
        widget.cargarHorario();
      }
    });
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Clases de Hoy", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(today, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
        ],
      ),
      const SizedBox(height: 10),
      ListaClases(error: widget.errorAlCargarHorario, bloques: widget.bloques, onRefresh: () => widget.cargarHorario(forceRefresh: true)),
    ],
  );
}
