import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/services/controllers/notas_controller.dart';
import 'package:miutem/core/utils/utils.dart';

class NotaPresentacion extends StatelessWidget {

  final NotasController notasController;

  const NotaPresentacion({super.key, required this.notasController});

  @override
  Widget build(BuildContext context) => SizedBox(width: 60, height: 30, child: Obx(() => TextField(
    enabled: false,
    controller: TextEditingController(text: formatoNota(notasController.calculatedPresentationGrade) ?? "--"),
    textAlignVertical: TextAlignVertical.center,
    textAlign: TextAlign.center,
    decoration: InputDecoration(
      filled: true,
      fillColor: Colors.grey.withOpacity(0.2),
      disabledBorder: Theme.of(context).inputDecorationTheme.border,
    ),
  )));
}
