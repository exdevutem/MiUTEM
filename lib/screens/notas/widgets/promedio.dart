import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/services/controllers/notas_controller.dart';
import 'package:miutem/core/utils/style_text.dart';
import 'package:miutem/core/utils/theme.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/screens/notas/widgets/nota_examen.dart';
import 'package:miutem/screens/notas/widgets/nota_presentacion.dart';

class Promedio extends StatelessWidget {

  final NotasController notasController;

  const Promedio({
    super.key,
    required this.notasController,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
    children: [
      Text("Promedio", style: StyleText.description),
      const SizedBox(height: 5),
      SizedBox(
        width: double.infinity,
        child: Card(
          margin: EdgeInsets.zero,
          color: Theme.of(context).scaffoldBackgroundColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: AppTheme.lightGrey)),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(formatoNota(notasController.calculatedFinalGrade) ?? "--", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w700, color: AppTheme.colorScheme.primary))),
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
                          Text("Presentación", style: StyleText.description),
                          const Spacer(),
                          NotaPresentacion(notasController: notasController),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text("Examen", style: StyleText.description),
                          const Spacer(),
                          NotaExamen(notasController: notasController),
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
    ],
  );
}