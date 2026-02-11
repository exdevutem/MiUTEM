import 'package:flutter/material.dart';
import 'package:miutem/core/models/asignaturas/asignatura_malla.dart';
import 'package:miutem/screens/malla_historica/widgets/screens/malla_blocks_content.dart';
import 'package:miutem/screens/malla_historica/widgets/screens/malla_semestres_header.dart';

class MallaMainScroller extends StatelessWidget {
  static const double blockWidth = 180.0;
  static const double blockHeight = 140.0;
  static const double blockInternalMargin = 6.0;
  static const double semestreHeaderHeight = 60.0;
  static const double borderWidth = 2.0;

  final List<AsignaturaMalla> asignaturas;

  const MallaMainScroller({
    super.key,
    required this.asignaturas,
  });

  /// Agrupa las asignaturas por nivel (semestre)
  List<List<AsignaturaMalla>> get _asignaturasPorSemestre {
    if (asignaturas.isEmpty) return [];

    final maxNivel = asignaturas.map((a) => a.nivel).reduce((a, b) => a > b ? a : b);
    final result = List<List<AsignaturaMalla>>.generate(maxNivel, (_) => []);

    for (final asignatura in asignaturas) {
      if (asignatura.nivel > 0 && asignatura.nivel <= maxNivel) {
        result[asignatura.nivel - 1].add(asignatura);
      }
    }

    return result;
  }

  int get _cantidadSemestres => _asignaturasPorSemestre.length;

  int get _maxAsignaturasPorSemestre {
    final porSemestre = _asignaturasPorSemestre;
    if (porSemestre.isEmpty) return 0;
    return porSemestre.map((s) => s.length).reduce((a, b) => a > b ? a : b);
  }

  double get totalWidth => blockWidth * _cantidadSemestres;
  double get totalHeight => semestreHeaderHeight + (blockHeight * _maxAsignaturasPorSemestre);

  Widget get _mallaSemestresHeader => MallaSemestresHeader(
    cantidadSemestres: _cantidadSemestres,
    height: semestreHeaderHeight,
    semestreWidth: blockWidth,
  );

  Widget get _mallaBlocksContent => MallaBlocksContent(
    asignaturasPorSemestre: _asignaturasPorSemestre,
    blockHeight: blockHeight,
    blockWidth: blockWidth,
    blockInternalMargin: blockInternalMargin,
  );

  @override
  Widget build(BuildContext context) {
    if (asignaturas.isEmpty) {
      return const Center(
        child: Text('No hay asignaturas para mostrar'),
      );
    }

    return InteractiveViewer(
      constrained: false,
      minScale: 0.3,
      maxScale: 2.0,
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _mallaSemestresHeader,
            _mallaBlocksContent,
          ],
        ),
      ),
    );
  }
}

