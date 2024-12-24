import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/services/controllers/notas_controller.dart';
import 'package:miutem/core/utils/utils.dart';

class NotaExamen extends StatelessWidget {

  final NotasController notasController;

  const NotaExamen({super.key, required this.notasController});

  @override
  Widget build(BuildContext context) => SizedBox(width: 60, height: 30, child: Obx(() => TextField(
    enabled: notasController.canTakeExam,
    controller: notasController.examGradeTextFieldController,
    textAlignVertical: TextAlignVertical.center,
    textAlign: TextAlign.center,
    keyboardType: const TextInputType.numberWithOptions(decimal: true),
    onChanged: (value) => notasController.setExamGrade(double.tryParse(value.replaceAll(",", ".")), updateTextController: false),
    decoration: InputDecoration(
      hintText: formatoNota(notasController.minimumRequiredExamGrade) ?? "--",
      filled: !notasController.canTakeExam,
      fillColor: Colors.grey.withOpacity(0.2),
      disabledBorder: Theme.of(context).inputDecorationTheme.border?.copyWith(
        borderSide: BorderSide(
          color: Colors.grey[300]!,
        ),
      ),
    ),
    inputFormatters: [notaInputFormatter],
  )));
}
