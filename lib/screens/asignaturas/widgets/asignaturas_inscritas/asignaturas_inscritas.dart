import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:miutem/core/models/asignaturas/asignatura.dart';
import 'package:miutem/core/services/asignaturas_service.dart';
import 'package:miutem/screens/asignaturas/widgets/asignaturas_inscritas/card_asignatura.dart';
import 'package:miutem/widgets/error/error_refresh.dart';
import 'package:miutem/widgets/icons.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AsignaturasInscritas extends StatelessWidget {

  final List<Asignatura>? asignaturas;

  const AsignaturasInscritas({super.key, required this.asignaturas});

  @override
  Widget build(BuildContext context) {
    if(asignaturas == null) {
      return const Skeletonizer(
          enabled: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardAsignatura(tipo: "Club", nombre: "Desarrollo Experimental", codigo: "Dart"),
              CardAsignatura(tipo: "Club", nombre: "Desarrollo Experimental", codigo: "Dart"),
              CardAsignatura(tipo: "Club", nombre: "Desarrollo Experimental", codigo: "Dart"),
              CardAsignatura(tipo: "Club", nombre: "Desarrollo Experimental", codigo: "Dart"),
            ],
          ),
        );
    }

    return Skeletonizer(
      enabled: asignaturas == null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: asignaturas?.map((asignatura) => CardAsignatura(
          tipo: asignatura.tipoHora,
          nombre: asignatura.nombre,
          codigo: asignatura.codigo,
        )).toList() ?? List.filled(6, const CardAsignatura(tipo: "Club", nombre: "Desarrollo Experimental", codigo: "Dart")),
      ),
    );
  }
}
