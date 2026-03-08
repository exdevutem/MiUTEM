import 'package:flutter/material.dart';
import 'package:miutem/core/models/evaluacion/grades.dart';
import 'package:miutem/styles/styles.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Promedio extends StatelessWidget {

  final Grades? grades;

  const Promedio({
    super.key,
    required this.grades,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
    children: [
      Text("Promedio", style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: 5),
      SizedBox(
        child: Skeletonizer(
          enabled: grades == null,
          child: Card(
            margin: EdgeInsets.zero,
            color: Theme.of(context).scaffoldBackgroundColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: AppTheme.lightGrey)),
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatoNota(grades?.notaFinal) ?? "--", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppTheme.colorScheme.primary)),
                  const Spacer(),
                  DecoratedBox(decoration: BoxDecoration(color: AppTheme.lightGrey), child: const SizedBox(width: 1, height: 80)),
                  const Spacer(), // Spacer agregado
                  Flexible(
                    flex: 6,
                    fit: FlexFit.tight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Skeleton.keep(child: Text("Presentación", style: Theme.of(context).textTheme.bodyMedium)),
                            const Spacer(),
                            Container(
                              width: 80,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.2),
                                border: Border.all(color: Theme.of(context).dividerColor),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  formatoNota(grades?.notaPresentacion) ?? '--',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Skeleton.keep(child: Text("Examen", style: Theme.of(context).textTheme.bodyMedium)),
                            const Spacer(),
                            Container(
                              width: 80,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.2),
                                border: Border.all(color: Theme.of(context).dividerColor),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Text(
                                  formatoNota(grades?.notaExamen) ?? "--",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      Text(
        "El promedio se calcula con las notas de presentación y examen. Presiona sobre el promedio para ver más detalles.",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
      ),
    ],
  );
}