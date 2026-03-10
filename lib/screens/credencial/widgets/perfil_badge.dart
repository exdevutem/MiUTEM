import 'package:flutter/material.dart';
import 'package:miutem/core/models/user/perfil.dart';
import 'package:miutem/core/utils/utils.dart';

class PerfilBadge extends StatelessWidget {
  final Perfil? perfil;

  const PerfilBadge({super.key, this.perfil});

  @override
  Widget build(BuildContext context) {
    final label = perfil != null ? capitalize(perfil!.name) : 'Estudiante';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _badgeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color get _badgeColor {
    switch (perfil) {
      case Perfil.funcionario:
        return const Color(0xFF64A82E);
      case Perfil.profesor:
        return const Color(0xFF8F09AF);
      case Perfil.estudiante:
      default:
        return const Color(0xFFFF820D);
    }
  }
}

