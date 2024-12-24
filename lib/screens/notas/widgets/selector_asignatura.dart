import 'package:flutter/material.dart';
import 'package:miutem/core/models/asignaturas/asignatura.dart';
import 'package:miutem/styles/styles.dart';

class SelectorAsignatura extends StatelessWidget {
  final Asignatura? asignatura;
  final List<Asignatura>? asignaturas;
  final Function(Asignatura?) onChanged;

  const SelectorAsignatura({
    super.key,
    required this.asignatura,
    required this.asignaturas,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Asignatura", style: StyleText.description),
      const SizedBox(height: 5),
      Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(12),
                    isExpanded: true,
                    items: asignaturas?.map((asignatura) => DropdownMenuItem(
                      value: asignatura,
                      child: Text(
                        asignatura.nombre,
                        style: StyleText.body.copyWith(overflow: TextOverflow.ellipsis),
                      ),
                    )).toList(),
                    disabledHint: Text("Cargando asignaturas...", style: StyleText.body),
                    hint: Text("Selecciona una asignatura", style: StyleText.body),
                    value: asignatura,
                    onChanged: onChanged,
                    icon: const Icon(AppIcons.dropdown),
                    focusColor: Colors.transparent,
                    isDense: false,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}