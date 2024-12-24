import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/horario.dart';
import 'package:miutem/core/services/asignaturas_service.dart';
import 'package:miutem/core/services/carrera_service.dart';
import 'package:miutem/core/services/grades_service.dart';
import 'package:miutem/screens/tasklist/task_list_screen.dart';
import 'package:miutem/styles/loading/loading_dialog.dart';

class ClassBlockCard extends StatelessWidget {
  final BloqueHorario? block;
  final double width;
  final double height;
  final double internalMargin;
  final Color textColor;

  const ClassBlockCard({
    super.key,
    required this.block,
    required this.width,
    required this.height,
    this.internalMargin = 0,
    this.textColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
        height: height,
        width: width,
        child: Padding(
          padding: EdgeInsets.all(internalMargin),
          child: block?.asignatura == null
              ? const SizedBox()
              : GestureDetector(
                  onTap: () => _onTap(block!, context),
                  onLongPress: () => _onLongPress(block!, context),
                  child: Container(
                    width: width,
                    height: height,
                    color: Colors.blue, // Example color
                    child: Center(
                      child: Text(
                        block!.asignatura!.nombre,
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),
                ),
        ),
      );

  _onTap(BloqueHorario block, BuildContext context) async {
    showLoadingDialog(context);
    final carrera = await Get.find<CarreraService>().getCarrera();
    final asignatura = (await Get.find<AsignaturasService>()
            .getAsignaturas(forceRefresh: true))
        .firstWhereOrNull((asignatura) =>
            asignatura.id == block.asignatura?.id ||
            asignatura.codigo == block.asignatura?.codigo);
    final grades = await Get.find<GradesService>().getGrades(asignatura!);
    if (carrera == null || asignatura == null) {
      Navigator.pop(context);
      return;
    }

    // Get.find<AnalyticsService>().logEvent("horario_class_block_tap", parameters: {
    //   "asignatura": asignatura.nombre,
    //   "codigo": asignatura.codigo,
    // });

    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (ctx) => TaskListScreen()));
    // Navigator.push(context, MaterialPageRoute(builder: (ctx) => AsignaturaDetalleScreen(
    //   carrera: carrera,
    //   asignatura: asignatura.copyWith(grades: grades),
    // )));
  }

  _onLongPress(BloqueHorario block, BuildContext context) async {
    showLoadingDialog(context);
    final carrera = await Get.find<CarreraService>().getCarrera();
    final asignatura = (await Get.find<AsignaturasService>()
            .getAsignaturas(forceRefresh: true))
        .firstWhereOrNull((asignatura) =>
            asignatura.id == block.asignatura?.id ||
            asignatura.codigo == block.asignatura?.codigo);
    if (carrera == null || asignatura == null) {
      Navigator.pop(context);
      return;
    }

    // Get.find<AnalyticsService>().logEvent("horario_class_block_long_press", parameters: {
    //   "asignatura": block.asignatura?.nombre,
    //   "codigo": block.asignatura?.codigo,
    // });
    Navigator.pop(context);
    /// TODO
    // showModalBottomSheet(context: context, builder: (ctx) => AsignaturaVistaPreviaModal(asignatura: asignatura, bloque: block), shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))));
  }
}