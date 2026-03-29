import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:miutem/core/services/controllers/notas_controller.dart";
import "package:miutem/core/utils/utils.dart";
import "package:miutem/styles/styles.dart";

class FilaNota extends StatelessWidget {
  final NotasController notasController;
  final int index;

  const FilaNota({
    super.key,
    required this.notasController,
    required this.index,
  });

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Expanded(
        child: _buildTextField(
          context: context,
          enabled: true,
          controller: notasController.gradeTextFieldControllers[index],
          textInputAction: TextInputAction.next,
          hintText: formatoNota(notasController.suggestedGrade),
          formatters: [notaInputFormatter],
          onChanged: (value) {
            final grade = notasController.partialGrades[index];
            grade.nota = double.tryParse(value.replaceAll(",", "."));
            notasController.updateGradeAt(index, grade);
          },
        ),
      ),
      HorizontalSpace.small,
      Expanded(
        child: _buildTextField(
          context: context,
          enabled: true,
          controller: notasController.percentageTextFieldControllers[index],
          textInputAction: TextInputAction.done,
          hintText:
              notasController.suggestedPercentage?.toStringAsFixed(0) ?? "--",
          onChanged: (value) {
            final grade = notasController.partialGrades[index];
            grade.porcentaje = double.tryParse(value.replaceAll(",", ".")) ?? 0;
            notasController.updateGradeAt(index, grade);
          },
        ),
      ),
      IconButton(
        onPressed: () => notasController.removeGradeAt(index),
        icon: const Icon(AppIcons.delete, size: 20),
        color: Theme.of(context).textTheme.bodyMedium?.color,
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
    style: Theme.of(context).textTheme.bodyMedium,
    decoration: InputDecoration(hintText: hintText ?? "--", filled: true),
    textAlign: TextAlign.center,
    textAlignVertical: TextAlignVertical.center,
    onChanged: onChanged,
    textInputAction: textInputAction,
    inputFormatters: formatters,
  );
}
