import 'package:flutter/material.dart';
import 'package:miutem/core/models/asignaturas/asignatura_malla.dart';
import 'package:miutem/screens/malla_historica/widgets/components/asignatura_malla_card.dart';

class MallaBlocksContent extends StatelessWidget {
  final List<List<AsignaturaMalla>> asignaturasPorSemestre;
  final double blockHeight;
  final double blockWidth;
  final double blockInternalMargin;
  final double borderWidth;

  const MallaBlocksContent({
    super.key,
    required this.asignaturasPorSemestre,
    required this.blockHeight,
    required this.blockWidth,
    this.blockInternalMargin = 8,
    this.borderWidth = 2,
  });

  int get _maxAsignaturasPorSemestre {
    if (asignaturasPorSemestre.isEmpty) return 0;
    return asignaturasPorSemestre.map((s) => s.length).reduce((a, b) => a > b ? a : b);
  }

  List<TableRow> get _children {
    final rows = <TableRow>[];
    final maxRows = _maxAsignaturasPorSemestre;

    for (int rowIndex = 0; rowIndex < maxRows; rowIndex++) {
      final currentRow = <Widget>[];

      for (int semestreIndex = 0; semestreIndex < asignaturasPorSemestre.length; semestreIndex++) {
        final asignaturas = asignaturasPorSemestre[semestreIndex];

        if (rowIndex < asignaturas.length) {
          currentRow.add(AsignaturaMallaCard(
            asignatura: asignaturas[rowIndex],
            height: blockHeight,
            width: blockWidth,
            internalMargin: blockInternalMargin,
          ));
        } else {
          // Celda vacía
          currentRow.add(SizedBox(
            height: blockHeight,
            width: blockWidth,
          ));
        }
      }
      rows.add(TableRow(children: currentRow));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) => Table(
    defaultColumnWidth: FixedColumnWidth(blockWidth),
    border: TableBorder(
      horizontalInside: BorderSide(
        color: Theme.of(context).dividerColor,
        style: BorderStyle.solid,
        width: borderWidth,
      ),
      verticalInside: BorderSide(
        color: Theme.of(context).dividerColor,
        style: BorderStyle.solid,
        width: borderWidth,
      ),
    ),
    children: _children,
  );
}

