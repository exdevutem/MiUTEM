import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:get/get.dart";
import "package:miutem/core/models/evaluacion/evaluacion.dart";
import "package:miutem/core/services/controllers/notas_controller.dart";
import "package:miutem/core/utils/utils.dart";
import "package:miutem/styles/styles.dart";

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
    children: [
      Text("Notas", style: Theme.of(context).textTheme.bodyMedium),
      const SizedBox(height: 12),
      Card(
        margin: EdgeInsets.zero,
        color: Theme.of(context).scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppTheme.lightGrey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Usamos Obx solo para la parte que cambia
              Obx(() => Column(
                children: [
                  // Encabezados manuales para evitar el GridView rígido
                  const Row(
                    children: [
                      Expanded(child: Center(child: Text("Notas"))),
                      SizedBox(width: 12),
                      Expanded(child: Center(child: Text("Porcentaje"))),
                      SizedBox(width: 48), // Espacio para el icono de borrar
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Filas de Notas
                  for (int i = 0; i < notasController.percentageTextFieldControllers.length; i++) ...[
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            context: context, 
                            enabled: true, 
                            controller: notasController.gradeTextFieldControllers[i], 
                            textInputAction: TextInputAction.next, 
                            hintText: formatoNota(notasController.suggestedGrade), 
                            formatters: [notaInputFormatter], 
                            onChanged: (value) {
                              final grade = notasController.partialGrades[i];
                              grade.nota = double.tryParse(value.replaceAll(",", "."));
                              notasController.updateGradeAt(i, grade);
                            }
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildTextField(
                            context: context,
                            enabled: true, 
                            controller: notasController.percentageTextFieldControllers[i], 
                            textInputAction: TextInputAction.done, 
                            hintText: notasController.suggestedPercentage?.toStringAsFixed(0) ?? "--", 
                            onChanged: (value) {
                              final grade = notasController.partialGrades[i];
                              grade.porcentaje = double.tryParse(value.replaceAll(",", ".")) ?? 0;
                              notasController.updateGradeAt(i, grade);
                            }
                          ),
                        ),
                        IconButton(
                          onPressed: () => notasController.removeGradeAt(i), 
                          icon: const Icon(AppIcons.delete, size: 20),
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  // BOTÓN AGREGAR: Ahora fuera del grid, libre de restricciones
                  const SizedBox(height: 8),
                  FilledButton.tonalIcon(
                    onPressed: () {
                      if(!canAddNotas) {
                        showErrorSnackbar(context, "Las notas están cargando... Intenta más tarde.");
                        return;
                      }
                      notasController.addGrade(IEvaluacion());
                    },
                    icon: const Icon(AppIcons.add),
                    label: const Text("Agregar Nota"),
                  ),
                ],
              )),
            ],
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
    style: Theme.of(context).textTheme.bodyMedium,
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