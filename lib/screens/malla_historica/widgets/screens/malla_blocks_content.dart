import "package:flutter/material.dart";
import "package:miutem/core/models/asignaturas/asignatura_malla.dart";
import "package:miutem/screens/malla_historica/widgets/components/asignatura_malla_card.dart";

class MallaBlocksContent extends StatelessWidget {
  final List<List<AsignaturaMalla>> asignaturasPorSemestre;

  const MallaBlocksContent({
    super.key,
    required this.asignaturasPorSemestre,
  });

  int get _maxAsignaturasPorSemestre {
    if (asignaturasPorSemestre.isEmpty) return 0;
    return asignaturasPorSemestre.map((s) => s.length).reduce((a, b) => a > b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final maxRows = _maxAsignaturasPorSemestre;

    if (asignaturasPorSemestre.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRows, (rowIndex) {
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(asignaturasPorSemestre.length, (semestreIndex) {
              final asignaturas = asignaturasPorSemestre[semestreIndex];
              final hasAsignatura = rowIndex < asignaturas.length;

              return Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: semestreIndex < asignaturasPorSemestre.length - 1
                          ? BorderSide(color: Theme.of(context).dividerColor)
                          : BorderSide.none,
                      bottom: BorderSide(color: Theme.of(context).dividerColor),
                    ),
                  ),
                  child: hasAsignatura
                      ? AsignaturaMallaCard(asignatura: asignaturas[rowIndex])
                      : const SizedBox.shrink(),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

