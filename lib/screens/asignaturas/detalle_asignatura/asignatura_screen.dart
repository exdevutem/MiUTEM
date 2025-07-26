import 'package:flutter/material.dart';
import 'package:miutem/core/models/asignaturas/asignatura.dart';
import 'package:miutem/screens/asignaturas/detalle_asignatura/actions/cargar_notas_asignatura.dart';
import 'package:miutem/screens/asignaturas/detalle_asignatura/widgets/promedio.dart';
import 'package:miutem/screens/asignaturas/detalle_asignatura/widgets/seccion_horario.dart';
import 'package:miutem/screens/notas/notas_screen.dart';
import 'package:miutem/styles/styles.dart';

class AsignaturaScreen extends StatefulWidget {

  final Asignatura asignatura;

  const AsignaturaScreen({
    super.key,
    required this.asignatura,
  });

  @override
  State<AsignaturaScreen> createState() => _AsignaturaScreenState();
}

class _AsignaturaScreenState extends State<AsignaturaScreen> {

  late Asignatura asignatura;

  @override
  void initState() {
    asignatura = widget.asignatura;
    super.initState();
    cargarAsignaturaConNotas(asignatura: widget.asignatura).then((asignatura) => setState(() => this.asignatura = asignatura)).catchError((error) {
      if(mounted) showErrorSnackbar(context, "Error al cargar las notas");
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(asignatura.nombre)),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: RefreshIndicator(
        onRefresh: () async {
          try {
            final asignatura = await cargarAsignaturaConNotas(asignatura: widget.asignatura);
            if (context.mounted) setState(() => this.asignatura = asignatura);
          } catch (error) {
            if (context.mounted) showErrorSnackbar(context, "Error al recargar las notas");
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              GestureDetector(
                child: Promedio(grades: asignatura.grades),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (ctx) => NotasScreen(asignatura: asignatura))),
              ),
              const SizedBox(height: 12),
              SeccionHorario(asignatura: asignatura),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    ),
  );
}
