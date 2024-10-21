import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:skeletonizer/skeletonizer.dart';

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
          Text(let<int, String>(DateTime.now().hour, (hour) => hour >= 6 && hour < 12 ? '¡Buenos Días!' : (hour >= 12 && hour < 19 ? '¡Buenas Tardes!' : '¡Buenas Noches!')) ?? '¡Te damos la Bienvenida!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          Skeletonizer(
            enabled: estudiante == null,
            child: Text(estudiante?.primerNombre ?? "John Doe",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        ],
      ),
      const Spacer(),
      GestureDetector(
        onTap: () async => Get.find<AuthService>().logout(context: context),
        child: const Text("👋", style: TextStyle(fontSize: 48)),
      ),
    ],
  );
}
