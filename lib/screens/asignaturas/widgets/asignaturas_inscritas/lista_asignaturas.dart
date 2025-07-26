import 'package:flutter/material.dart';
import 'package:miutem/core/models/asignaturas/asignatura.dart';
import 'package:miutem/screens/asignaturas/detalle_asignatura/asignatura_screen.dart';
import 'package:miutem/screens/asignaturas/widgets/asignaturas_inscritas/card_asignatura.dart';
import 'package:skeletonizer/skeletonizer.dart';

const defaultCard = CardAsignatura(tipo: "Club", nombre: "Desarrollo Experimental", codigo: "Dart");

class ListaAsignaturas extends StatelessWidget {

  final List<Asignatura>? asignaturas;

  const ListaAsignaturas({super.key, required this.asignaturas});

  @override
  Widget build(BuildContext context) => asignaturas == null ? Skeletonizer(
    enabled: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.filled(5, defaultCard),
    ),
  ) : Skeletonizer(
    enabled: asignaturas == null,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: asignaturas?.map((asignatura) => CardAsignatura(
        tipo: asignatura.tipoHora,
        nombre: asignatura.nombre,
        codigo: asignatura.codigo,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AsignaturaScreen(asignatura: asignatura))),
      )).toList() ?? List.filled(6, defaultCard),
    ),
  );
}
