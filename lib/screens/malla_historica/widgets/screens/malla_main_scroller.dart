import 'package:flutter/material.dart';
import 'package:miutem/core/models/asignaturas/asignatura_malla.dart';
import 'package:miutem/screens/malla_historica/widgets/components/asignatura_malla_card.dart';
import 'package:miutem/screens/malla_historica/widgets/components/semestre_header_card.dart';

class MallaMainScroller extends StatelessWidget {
  final List<AsignaturaMalla> asignaturas;
  final bool forScreenshot;

  const MallaMainScroller({
    super.key,
    required this.asignaturas,
    this.forScreenshot = false,
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

  @override
  Widget build(BuildContext context) {
    if (asignaturas.isEmpty) {
      return const Center(
        child: Text('No hay asignaturas para mostrar'),
      );
    }

    final semestres = _asignaturasPorSemestre;

    if (forScreenshot) {
      return _buildTableViewForScreenshot(context, semestres);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isLandscape = constraints.maxWidth > constraints.maxHeight;
        final isLargeScreen = constraints.maxWidth > 600;

        // En pantallas grandes o landscape, mostrar vista de tabla scrolleable
        if (isLargeScreen || isLandscape) {
          return _buildTableView(context, semestres);
        }

        // En pantallas pequeñas, mostrar vista de lista vertical por semestre
        return _buildListView(context, semestres);
      },
    );
  }

  /// Vista de tabla horizontal para pantallas grandes
  Widget _buildTableView(BuildContext context, List<List<AsignaturaMalla>> semestres) {
    return InteractiveViewer(
      constrained: false,
      minScale: 0.5,
      maxScale: 2.0,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: MediaQuery.of(context).size.width,
            ),
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Header de semestres
                  Row(
                    children: List.generate(
                      semestres.length,
                      (index) => Expanded(
                        child: SemestreHeaderCard(semestre: index + 1),
                      ),
                    ),
                  ),
                  const Divider(height: 1),
                  // Contenido de asignaturas
                  _buildAsignaturasTable(context, semestres),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAsignaturasTable(BuildContext context, List<List<AsignaturaMalla>> semestres) {
    final maxRows = semestres.map((s) => s.length).reduce((a, b) => a > b ? a : b);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRows, (rowIndex) {
        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: List.generate(semestres.length, (semestreIndex) {
              final asignaturas = semestres[semestreIndex];
              final hasAsignatura = rowIndex < asignaturas.length;

              return Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      right: semestreIndex < semestres.length - 1
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

  /// Vista de lista vertical para pantallas pequeñas
  Widget _buildListView(BuildContext context, List<List<AsignaturaMalla>> semestres) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: semestres.length,
      itemBuilder: (context, semestreIndex) {
        final asignaturasSemestre = semestres[semestreIndex];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header del semestre
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'Semestre ${semestreIndex + 1}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Asignaturas del semestre usando GridView flexible
            LayoutBuilder(
              builder: (context, constraints) {
                // Calcular cuántas columnas caben basándose en el ancho disponible
                final crossAxisCount = (constraints.maxWidth / 160).floor().clamp(1, 4);

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: asignaturasSemestre.length,
                  itemBuilder: (context, index) {
                    return AsignaturaMallaCard(asignatura: asignaturasSemestre[index]);
                  },
                );
              },
            ),
            if (semestreIndex < semestres.length - 1)
              const Divider(height: 32),
          ],
        );
      },
    );
  }

  /// Vista de tabla para impresión o captura de pantalla (sin scroll)
  Widget _buildTableViewForScreenshot(BuildContext context, List<List<AsignaturaMalla>> semestres) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header de semestres
            Row(
              children: List.generate(
                semestres.length,
                (index) => Expanded(
                  child: SemestreHeaderCard(semestre: index + 1),
                ),
              ),
            ),
            const Divider(height: 1),
            // Contenido de asignaturas
            _buildAsignaturasTable(context, semestres),
          ],
        ),
      ),
    );
  }
}
