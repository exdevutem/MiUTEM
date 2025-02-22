import 'package:flutter/material.dart';
import 'package:miutem/core/models/user/persona/persona.dart';
import 'package:miutem/styles/styles.dart';

class ModalPersona extends StatelessWidget {
  final Persona persona;

  const ModalPersona({
    super.key,
    required this.persona,
  });

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Stack(
      children: [
        Container(
          alignment: Alignment.topCenter,
          margin: const EdgeInsets.only(top: 70),
          child: Card(
            margin: const EdgeInsets.all(20),
            child: ListView(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              children: [
                ListTile(
                  title: const Text("Nombre"),
                  subtitle: Text(persona.nombreCompletoCapitalizado),
                ),
                if(persona.rut != null) const Divider(height: 5),
                if(persona.rut != null) ListTile(
                  title: const Text("R.U.N"),
                  subtitle: Text(persona.rut.toString()),
                ),
              ],
            ),
          ),
        ),
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Text(persona.iniciales[0],
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}