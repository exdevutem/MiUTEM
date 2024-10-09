import 'package:flutter/material.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/utils/utils.dart';

class Saludo extends StatelessWidget {
  final Estudiante? estudiante;

  const Saludo({super.key, required this.estudiante});

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(let<int, String>(DateTime.now().hour, (hour) => hour >= 6 && hour < 12 ? '¡Buenos Días!' : (hour >= 12 && hour < 19 ? '¡Buenas Tardes!' : '¡Buenas Noches!')) ?? '¡Te damos la Bienvenida!', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          Text(estudiante?.primerNombre ?? "", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
        ],
      ),
      const Spacer(),
      const Text("👋", style: TextStyle(fontSize: 48)),
    ],
  );
}
