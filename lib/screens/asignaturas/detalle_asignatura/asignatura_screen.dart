import "package:flutter/material.dart";
import "package:miutem/core/models/asignaturas/asignatura.dart";
import "package:miutem/core/utils/utils.dart";
import "package:miutem/screens/asignaturas/detalle_asignatura/actions/cargar_notas_asignatura.dart";
import "package:miutem/screens/asignaturas/detalle_asignatura/models/horario_bloque.dart";
import "package:miutem/screens/asignaturas/detalle_asignatura/widgets/promedio.dart";
import "package:miutem/screens/asignaturas/detalle_asignatura/widgets/seccion_horario.dart";
import "package:miutem/screens/notas/notas_screen.dart";
import "package:miutem/styles/styles.dart";

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
  List<HorarioBloque> bloquesHorario = [];

  @override
  void initState() {
    asignatura = widget.asignatura;
    super.initState();
    cargarAsignaturaConNotas(asignatura: widget.asignatura).then((loadedAsignatura) {
      if (mounted) setState(() => asignatura = loadedAsignatura);
    }).catchError((error) {
      if (mounted) showErrorSnackbar(context, "Error al cargar las notas");
    });

    cargarHorarioBloque(asignatura: asignatura).then((bloques) {
      if (mounted) setState(() => bloquesHorario = bloques);
    }).catchError((error) {
      logger.e("Error al cargar bloques de horario", error: error);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(asignatura.nombre)),
    body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: RefreshIndicator(
        onRefresh: () async {
          List<HorarioBloque> tmp = bloquesHorario;
          try {
            setState(() {
              bloquesHorario.clear();
            });

            final updatedAsignatura = await cargarAsignaturaConNotas(asignatura: widget.asignatura);
            final updatedBloquesHorario = await cargarHorarioBloque(asignatura: updatedAsignatura);
            if (context.mounted) {
              setState(() {
                asignatura = updatedAsignatura;
                bloquesHorario = updatedBloquesHorario;
              });
            }
          } catch (error) {
            logger.e("Error al recargar vista asignatura", error: error);
            if (context.mounted) {
              setState(() {
                bloquesHorario = tmp; // Revertir a los bloques anteriores en caso de error
              });
              showErrorSnackbar(context, "Error al recargar las notas");
            }
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
              SeccionHorario(bloques: bloquesHorario),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    ),
  );
}
