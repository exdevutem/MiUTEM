import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/horario.dart';
import 'package:miutem/core/services/asignaturas_service.dart';
import 'package:miutem/core/services/carrera_service.dart';
import 'package:miutem/core/services/grades_service.dart';
import 'package:miutem/core/utils/utilities.dart';
import 'package:miutem/screens/asignaturas/lista_asignaturas_screen.dart';
import 'package:miutem/screens/horario/widgets/modals/vista_previa_asignatura_modal.dart';
import 'package:miutem/screens/tasklist/task_list_screen.dart';
import 'package:miutem/styles/loading/loading_dialog.dart';
import 'package:miutem/styles/styles.dart';

class ClassBlockCard extends StatelessWidget {
  final BloqueHorario? block;
  final double width;
  final double height;
  final double internalMargin;

  const ClassBlockCard({
    super.key,
    required this.block,
    required this.width,
    required this.height,
    this.internalMargin = 0,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: width,
    child: Padding(
      padding: EdgeInsets.all(internalMargin),
      child: block?.asignatura == null ? const SizedBox() : GestureDetector(
        onTap: () => _onTap(block!, context),
        onLongPress: () => _onLongPress(block!, context),
        child: SizedBox(
          width: width,
          height: height,
          child: ValueListenableBuilder<AdaptiveThemeMode>(
            valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
            builder: (ctx, mode, child) => DecoratedBox(
              decoration: BoxDecoration(
                color: themedColor(context, light: AppTheme.lightBlueCard, dark: AppTheme.darkBlueCard),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('${block!.asignatura!.codigo}/${block!.asignatura!.seccion}', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal)),
                    Space.medium,
                    Text(block!.asignatura!.nombre, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
                    Space.medium,
                    Text(block!.sala ?? 'SIN SALA', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.normal)),
                  ],
                ),
              ),
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
        .firstWhereOrNull((asignatura) => asignatura.id == block.asignatura?.id || asignatura.codigo == block.asignatura?.codigo);
    final grades = await Get.find<GradesService>().getGrades(asignatura!);
    if (carrera == null || asignatura == null) {
      if(context.mounted) Navigator.pop(context);
      return;
    }

    if(context.mounted) Navigator.pop(context);
    // if(context.mounted) Navigator.push(context, MaterialPageRoute(builder: (ctx) => AsignaturaScreen(asignatura)));
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
        .firstWhereOrNull((asignatura) => asignatura.id == block.asignatura?.id || asignatura.codigo == block.asignatura?.codigo);
    if (carrera == null || asignatura == null) {
      if(context.mounted) Navigator.pop(context);
      return;
    }

    if(context.mounted) {
      Navigator.pop(context);
      showModalBottomSheet(
        context: context,
        builder: (ctx) => VistaPreviaAsignaturaModal(asignatura: asignatura, bloque: block),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      );
    }
  }
}