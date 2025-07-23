import 'package:flutter/material.dart';
import 'package:miutem/core/models/asignaturas/asignatura.dart';
import 'package:miutem/core/models/horario.dart';
import 'package:miutem/styles/styles.dart';

class VistaPreviaAsignaturaModal extends StatelessWidget {

  final Asignatura asignatura;
  final BloqueHorario bloque;

  const VistaPreviaAsignaturaModal({
    super.key,
    required this.asignatura,
    required this.bloque,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      alignment: Alignment.topCenter,
      child: Card(
        margin: const EdgeInsets.all(0.0),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          children: [
            GestureDetector(
              onTap: () {
                if(asignatura.docente.nombreCompletoCapitalizado != 'Sin Asignar') {
                  showModalBottomSheet(context: context, builder: (ctx) => ModalPersona(persona: asignatura.docente));
                }
              },
              child: ListTile(
                title: Text(asignatura.nombre),
                subtitle: Text('Docente: ${asignatura.docente.nombreCompletoCapitalizado}'),
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Código'),
              subtitle: Text(asignatura.codigo),
            ),
            const Divider(),
            ListTile(
              title: const Text('Sección'),
              subtitle: Text(asignatura.seccion),
            ),
          ],
        ),
      ),
    ),
  );
}
