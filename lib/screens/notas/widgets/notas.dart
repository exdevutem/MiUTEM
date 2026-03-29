import "package:collection/collection.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:miutem/core/models/evaluacion/evaluacion.dart";
import "package:miutem/core/services/controllers/notas_controller.dart";
import "package:miutem/core/utils/utils.dart";
import "package:miutem/screens/notas/widgets/notas/fila_nota.dart";
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
      Space.small,
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
              Obx(
                () => Column(
                  children: [
                    // Encabezados manuales para evitar el GridView rígido
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: Center(child: Text("Notas"))),
                        HorizontalSpace.small,
                        Expanded(child: Center(child: Text("Porcentaje"))),
                        HorizontalSpace.extraExtraLarge,
                      ],
                    ),
                    HorizontalSpace.small,

                    // Filas de Notas
                    ...notasController.percentageTextFieldControllers
                        .mapIndexed<Widget>(
                          (i, controller) => FilaNota(
                            notasController: notasController,
                            index: i,
                          ),
                        )
                        .toList()
                        .intersperse(Space.small),

                    Space.extraSmall,
                    FilledButton.tonalIcon(
                      onPressed: () {
                        if (!canAddNotas) {
                          showErrorSnackbar(
                            context,
                            "Las notas están cargando... Intenta más tarde.",
                          );
                          return;
                        }
                        notasController.addGrade(IEvaluacion());
                      },
                      icon: const Icon(AppIcons.add),
                      label: const Text("Agregar Nota"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
