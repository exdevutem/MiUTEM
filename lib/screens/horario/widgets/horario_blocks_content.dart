import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:miutem/core/models/horario.dart';
import 'package:miutem/core/utils/theme.dart';
import 'package:miutem/screens/horario/widgets/widgets.dart';

class HorarioBlocksContent extends StatelessWidget {
  final Horario horario;
  final double blockHeight;
  final double blockWidth;
  final double blockInternalMargin;
  final Color borderColor;
  final double borderWidth;

  const HorarioBlocksContent({
    super.key,
    required this.horario,
    required this.blockHeight,
    required this.blockWidth,
    this.blockInternalMargin = 0,
    this.borderColor = AppTheme.dividerColor,
    this.borderWidth = 2,
  });

  List<TableRow> get _children {
    final rows = <TableRow>[];
    for (int blockIndex = 0; blockIndex < horario.horarioEnlazado.length; blockIndex++) {
      final currentRow = <Widget>[];

      if ((blockIndex % 2) == 0) {
        List<BloqueHorario> bloquePorDias = horario.horarioEnlazado[blockIndex];
        for (num dia = 0; dia < bloquePorDias.length; dia++) {
          BloqueHorario block = horario.horarioEnlazado[blockIndex][dia as int];
          currentRow.add(ClassBlockCard(
            block: block,
            height: blockHeight,
            width: blockWidth,
            internalMargin: blockInternalMargin,
          ));
        }
        rows.add(TableRow(children: currentRow));
      }
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) => Table(
    defaultColumnWidth: FixedColumnWidth(blockWidth),
    border: TableBorder(
      horizontalInside: BorderSide(
        color: borderColor,
        style: BorderStyle.solid,
        width: borderWidth,
      ),
      verticalInside: BorderSide(
        color: borderColor,
        style: BorderStyle.solid,
        width: borderWidth,
      ),
    ),
    children: _children,
  );

}
