import 'dart:async';

import 'package:flutter/material.dart';
import 'package:miutem/core/models/horario.dart';
import 'package:miutem/core/utils/utilities.dart';
import 'package:miutem/screens/home/widgets/clases_de_hoy/lista_clases.dart';
import 'package:miutem/styles/styles.dart';

class SeccionClasesDeHoy extends StatefulWidget {
  final String? errorAlCargarHorario;
  final List<BloqueHorario>? bloques;
  final void Function({bool forceRefresh}) cargarHorario;

  const SeccionClasesDeHoy({
    super.key,
    required this.errorAlCargarHorario,
    required this.bloques,
    required this.cargarHorario,
  });

  @override
  State<SeccionClasesDeHoy> createState() => _SeccionClasesDeHoyState();
}

class _SeccionClasesDeHoyState extends State<SeccionClasesDeHoy> {
  String today = getToday();

  @override
  void initState() {
    super.initState();
    // Se actualiza la tarjeta cada minuto.
    Timer.periodic(const Duration(seconds: 60), (timer) {
      final today = getToday();

      // Se verifica que sea la hora de inicio (o la de fin) para actualizar la tarjeta.
      if (today != this.today) {
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
          Text("Clases de Hoy", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
          Text(today, style: Theme.of(context).textTheme.bodySmall)
        ],
      ),
      Space.xSmall,
      ListaClases(error: widget.errorAlCargarHorario,
        bloques: widget.bloques,
        onRefresh: () => widget.cargarHorario(forceRefresh: true),
      ),
    ],
  );
}
