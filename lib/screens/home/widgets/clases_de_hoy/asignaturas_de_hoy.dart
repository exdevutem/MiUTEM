import 'package:flutter/material.dart';
import 'package:miutem/core/models/horario.dart';
import 'package:miutem/screens/home/widgets/clases_de_hoy/card_clase.dart';
import 'package:miutem/widgets/error/error_refresh.dart';
import 'package:skeletonizer/skeletonizer.dart';

const List<String> timeSlots = [
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

class AsignaturasDeHoy extends StatelessWidget {

  final String? error;
  final List<BloqueHorario>? bloques;
  final Function() onRefresh;

  const AsignaturasDeHoy({super.key, required this.error, required this.bloques, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    if(error != null) {
      return ErrorRefresh(title: error!, onTap: onRefresh);
    }

    return Skeletonizer(
      enabled: bloques == null,
      child: Column(
        children: bloques != null ? bloques!.asMap().entries.where((entry) => entry.value.asignatura != null).map((entry) {
          final index = entry.key * 2; // Adjust index to match the original timeSlots
          final bloque = entry.value;
          final startTimeSlot = timeSlots[index];
          final endTimeSlot = timeSlots[index + 1];
          final startTimes = startTimeSlot.split(" - ");
          final endTimes = endTimeSlot.split(" - ");
          return CardClase(
            horaInicio: startTimes[0],
            horaFin: endTimes[1],
            nombreClase: bloque.asignatura?.nombre ?? "Sin asignatura",
            sala: bloque.sala ?? "Sin sala",
          );
        }).toList() : const [
          CardClase(horaInicio: "8:00", horaFin: "9:30", nombreClase: "Club de Desarrollo Experimental", sala: "M8 - 103"),
          CardClase(horaInicio: "9:40", horaFin: "11:10", nombreClase: "Club de Desarrollo Experimental", sala: "M8 - 103"),
          CardClase(horaInicio: "11:20", horaFin: "12:50", nombreClase: "Club de Desarrollo Experimental", sala: "M8 - 103"),
          CardClase(horaInicio: "13:00", horaFin: "14:30", nombreClase: "Club de Desarrollo Experimental", sala: "M8 - 103"),
          CardClase(horaInicio: "14:40", horaFin: "16:10", nombreClase: "Club de Desarrollo Experimental", sala: "M8 - 103"),
        ],
      ),
    );
  }
}
