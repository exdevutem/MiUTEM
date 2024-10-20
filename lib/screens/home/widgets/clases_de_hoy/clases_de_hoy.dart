import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:miutem/core/models/horario.dart';
import 'package:miutem/core/services/horario_service.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/screens/home/widgets/clases_de_hoy/card_clase.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ClasesDeHoy extends StatefulWidget {
  const ClasesDeHoy({super.key});

  @override
  State<ClasesDeHoy> createState() => _ClasesDeHoyState();
}

class _ClasesDeHoyState extends State<ClasesDeHoy> {

  bool forceRefresh = false;

  final List<String> timeSlots = [
    "8:00 - 8:45",
    "8:45 - 9:30",
    "9:40 - 10:25",
    "10:25 - 11:10",
    "11:20 - 12:05",
    "12:05 - 12:50",
    "13:00 - 13:45",
    "13:45 - 14:30",
    "14:40 - 15:25",
    "15:25 - 16:10",
    "16:20 - 17:05",
    "17:05 - 17:50",
    "18:00 - 18:45",
    "18:45 - 19:30",
    "19:40 - 20:25",
    "20:25 - 21:10",
    "21:20 - 21:05",
    "22:05 - 22:50",
  ];

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Skeleton.keep(child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Clases de Hoy", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(getToday(), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
        ],
      )),
      const SizedBox(height: 10),

      FutureBuilder<Horario>(
        future: () async {
          final horario = await Get.find<HorarioService>().getHorario(forceRefresh: forceRefresh);
          forceRefresh = false;
          return horario;
        }(),
        builder: (ctx, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return const Skeletonizer(
              enabled: true,
              child: Column(
                children: [
                  CardClase(horaInicio: "8:00", horaFin: "9:30", nombreClase: "Club de Desarrollo Experimental", sala: "M8 - 103"),
                  CardClase(horaInicio: "9:40", horaFin: "11:10", nombreClase: "Club de Desarrollo Experimental", sala: "M8 - 103"),
                  CardClase(horaInicio: "11:20", horaFin: "12:50", nombreClase: "Club de Desarrollo Experimental", sala: "M8 - 103"),
                  CardClase(horaInicio: "13:00", horaFin: "14:30", nombreClase: "Club de Desarrollo Experimental", sala: "M8 - 103"),
                  CardClase(horaInicio: "14:40", horaFin: "16:10", nombreClase: "Club de Desarrollo Experimental", sala: "M8 - 103"),
                ],
              ),
            );
          }

          final horario = snapshot.data;

          if(snapshot.hasError || horario == null) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: GestureDetector(
                onTap: () => setState(() => forceRefresh = true),
                child: const Column(
                  children: [
                    Text("Error al cargar las clases de hoy.", style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                    Text("Presiona para reintentar.", style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                    Icon(Symbols.refresh_rounded, size: 32), // Botón para reintentar
                  ],
                ),
              ),
            );
          }

          final diaIdx = DateTime.now().weekday - 1;
          if(diaIdx < 0 || diaIdx >= (horario.horario?.first.length ?? 0)) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: GestureDetector(
                onTap: () => setState(() => forceRefresh = true),
                child: const Column(
                  children: [
                    Text("No tienes clases hoy.", style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                    Text("Presiona para refrescar.", style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                    Icon(Symbols.refresh_rounded, size: 32), // Botón para reintentar
                  ],
                ),
              ),
            );
          }

          final clasesDeHoy = horario.horario?.map((row) => row[diaIdx]).toList();
          final filteredClasesDeHoy = (clasesDeHoy?.asMap().entries.where((entry) => entry.key % 2 == 0).map((entry) => entry.value).toList() ?? []).toList();
          if (clasesDeHoy == null || filteredClasesDeHoy.where((bloque) => bloque.asignatura != null).isEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: GestureDetector(
                onTap: () => setState(() => forceRefresh = true),
                child: const Column(
                  children: [
                    Text("No tienes clases hoy.", style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                    Text("Presiona para refrescar.", style: TextStyle(fontSize: 18), textAlign: TextAlign.center),
                    Icon(Symbols.refresh_rounded, size: 32), // Botón para reintentar
                  ],
                ),
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => setState(() => forceRefresh = true),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: filteredClasesDeHoy.asMap().entries.where((entry) => entry.value.asignatura != null).map((entry) {
                  final index = entry.key * 2; // Adjust index to match the original timeSlots
                  final bloque = entry.value;
                  final startTimeSlot = timeSlots[index];
                  logger.d('Idx: $index. TimeSlot: $startTimeSlot');
                  final endTimeSlot = timeSlots[index + 1];
                  final startTimes = startTimeSlot.split(" - ");
                  final endTimes = endTimeSlot.split(" - ");
                  return CardClase(
                    horaInicio: startTimes[0],
                    horaFin: endTimes[1],
                    nombreClase: bloque.asignatura?.nombre ?? "Sin asignatura",
                    sala: bloque.sala ?? "Sin sala",
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
    ],
  );
}