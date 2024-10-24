import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miutem/core/models/asignaturas/asignatura.dart';
import 'package:miutem/screens/asignaturas/widgets/asignaturas_inscritas/lista_asignaturas.dart';

class AsignaturasEnCurso extends StatelessWidget {

  final List<Asignatura>? asignaturas;

  const AsignaturasEnCurso({super.key, required this.asignaturas});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text("En Curso", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
      const SizedBox(height: 5),
      Text("Asignaturas Inscritas", style: GoogleFonts.roboto(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.01,
      )),
      const SizedBox(height: 10),
      ListaAsignaturas(asignaturas: asignaturas),
    ],
  );

}

