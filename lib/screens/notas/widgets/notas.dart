import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/evaluacion/evaluacion.dart';
import 'package:miutem/core/services/controllers/notas_controller.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/core/utils/style_text.dart';
import 'package:miutem/core/utils/theme.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/widgets/icons.dart';
import 'package:miutem/widgets/snackbar.dart';

class Notas extends StatelessWidget {

  final bool canAddNotas;
  final NotasController notasController;

  const Notas({
    super.key,
    required this.notasController,
    required this.canAddNotas,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.max,
    children: [
      Text("Notas", style: StyleText.description),
      const SizedBox(height: 12),
      SizedBox(
        width: double.infinity,
        child: Card(
          color: Theme.of(context).scaffoldBackgroundColor,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: BorderSide(color: AppTheme.lightGrey)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Obx(() => GridView(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  children: [
                    const Center(child: Text("Notas")),
                    const Center(child: Text("Porcentaje")),
                    const SizedBox.shrink(),
                    for (int i = 0; i < notasController.percentageTextFieldControllers.length; i++) ...[
                      _buildTextField(context: context, enabled: true, controller: notasController.gradeTextFieldControllers[i], textInputAction: TextInputAction.next, hintText: formatoNota(notasController.suggestedGrade), formatters: [notaInputFormatter], onChanged: (value) {
                        final grade = notasController.partialGrades[i];
                        grade.nota = double.tryParse(value.replaceAll(",", "."));
                        notasController.updateGradeAt(i, grade);
                      }),
                      _buildTextField(context: context,enabled: true, controller: notasController.percentageTextFieldControllers[i], textInputAction: TextInputAction.done, hintText: notasController.suggestedPercentage?.toStringAsFixed(0) ?? "--", onChanged: (value) {
                        final grade = notasController.partialGrades[i];
                        grade.porcentaje = double.tryParse(value.replaceAll(",", ".")) ?? 0;
                        notasController.updateGradeAt(i, grade);
                      }),
                      IconButton(onPressed: () => notasController.removeGradeAt(i), icon: const Icon(AppIcons.delete, size: 20)),
                    ],
                    const SizedBox.shrink(),
                    SizedBox.expand(child: Center(child: FilledButton.tonalIcon(icon: const Icon(AppIcons.add), label: const Text("Nota"), onPressed: () {
                      if(!canAddNotas) {
                        showErrorSnackbar(context, "Las notas están cargando... Intenta más tarde.");
                        return;
                      }

                      notasController.addGrade(IEvaluacion());
                    }))),
                    const SizedBox.shrink(),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  Widget _buildTextField({
    required BuildContext context,
    required bool enabled,
    required TextEditingController controller,
    required TextInputAction textInputAction,
    required String? hintText,
    Function(String)? onChanged,
    List<TextInputFormatter>? formatters,
  }) => TextField(
    enabled: enabled,
    controller: controller,
    style: StyleText.body,
    decoration: InputDecoration(
      hintText: hintText ?? "--",
      filled: true,
    ),
    textAlign: TextAlign.center,
    textAlignVertical: TextAlignVertical.center,
    onChanged: onChanged,
    textInputAction: textInputAction,
    inputFormatters: formatters,

  );
}