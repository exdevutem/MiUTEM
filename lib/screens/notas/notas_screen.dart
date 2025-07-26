import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/asignaturas/asignatura.dart';
import 'package:miutem/core/models/evaluacion/evaluacion.dart';
import 'package:miutem/core/models/evaluacion/grades.dart';
import 'package:miutem/core/models/user/persona/persona.dart';
import 'package:miutem/core/services/controllers/notas_controller.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/screens/notas/actions/cargar_asignaturas_con_notas.dart';
import 'package:miutem/screens/notas/widgets/notas.dart';
import 'package:miutem/screens/notas/widgets/promedio.dart';
import 'package:miutem/screens/notas/widgets/selector_asignatura.dart';

final emptyAsignatura = Asignatura(id: "id", nombre: "Calcular Notas", codigo: "--", tipoHora: "--", estado: "--", seccion: "--", docente: Persona(nombreCompleto: "--"), grades: Grades(notasParciales: [IEvaluacion()]));

class NotasScreen extends StatefulWidget {

  final Asignatura? asignatura;

  const NotasScreen({
    super.key,
    this.asignatura,
  });

  @override
  State<NotasScreen> createState() => _NotasScreenState();
}

class _NotasScreenState extends State<NotasScreen> {

  final notasController = Get.find<NotasController>();

  Asignatura? asignatura;
  List<Asignatura>? asignaturas;

  @override
  void initState() {
    super.initState();

    if (widget.asignatura != null) {
      if (!mounted) return;
      setState(() {
        asignatura = widget.asignatura;
        notasController.updateWithGrades(asignatura?.grades);
      });
      return;
    }

    cargarAsignaturasConNotas().then((asignaturas) {
      asignaturas = [
        emptyAsignatura,
        ...asignaturas
      ];
      if(!mounted) return;
      setState(() {
        this.asignaturas = asignaturas;
        asignatura = emptyAsignatura;
        notasController.updateWithGrades(asignatura?.grades);
      });
    }, onError: (err) {
      if(!mounted) return;
      setState(() {
        asignaturas = [emptyAsignatura];
        asignatura = emptyAsignatura;
        notasController.updateWithGrades(asignatura?.grades);
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Notas')),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if(widget.asignatura == null) SelectorAsignatura(asignatura: asignatura, asignaturas: asignaturas, onChanged: (Asignatura? asignatura) {
              notasController.updateWithGrades(asignatura?.grades);
              setState(() => this.asignatura = asignatura);
            }),
            const SizedBox(height: 12),
            Promedio(notasController: notasController),
            const SizedBox(height: 12),
            Notas(notasController: notasController, canAddNotas: asignaturas != null),
            const SizedBox(height: 12),
            const Center(child: Text("* La función de calculadora sólo funciona para el cálculo del ramo seleccionado, no modificará ninguna nota ingresada al sistema.", style: TextStyle(color: Colors.grey, fontSize: 12))),
          ],
        ),
      ),
    ),
  );


}
