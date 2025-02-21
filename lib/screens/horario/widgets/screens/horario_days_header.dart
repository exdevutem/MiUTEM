import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/styles/styles.dart';
import 'package:miutem/core/models/horario.dart';
import 'package:miutem/core/services/controllers/horario_controller.dart';
import 'package:miutem/screens/horario/widgets/widgets.dart';

class HorarioDaysHeader extends StatelessWidget {
  final Horario horario;
  final double height;
  final double dayWidth;
  final double borderWidth;
  final bool showActiveDay;

  const HorarioDaysHeader({
    super.key,
    required this.horario,
    required this.height,
    required this.dayWidth,
    this.showActiveDay = true,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) => Table(
    defaultColumnWidth: FixedColumnWidth(dayWidth),
    border: TableBorder(
      verticalInside: BorderSide(
        color: Theme.of(context).dividerColor,
        style: BorderStyle.solid,
        width: borderWidth,
      ),
      bottom: BorderSide(
        color: Theme.of(context).dividerColor,
        style: BorderStyle.solid,
        width: borderWidth,
      ),
    ),
    children: [
      TableRow(
        children: horario.diasHorario.asMap().entries.map((entry) => BloqueDiasCard(
          day: entry.value,
          height: height,
          width: dayWidth,
          active: showActiveDay && entry.key == Get.find<HorarioController>().indexOfCurrentDayStartingAtMonday,
        )).toList(),
      ),
    ],
  );
}
