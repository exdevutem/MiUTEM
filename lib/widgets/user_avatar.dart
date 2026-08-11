import "package:flutter/material.dart";
import "package:miutem/core/models/user/estudiante.dart";
import "package:miutem/styles/styles.dart";

/// Widget global de avatar del usuario.
/// Se puede usar en perfil, credencial, y cualquier otro lugar.
class UserAvatar extends StatelessWidget {
  final Estudiante? estudiante;
  final double radius;
  final double? fontSize;

  const UserAvatar({
    super.key,
    required this.estudiante,
    this.radius = 50,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveFontSize = fontSize ?? (radius * 0.8);
    final foto = estudiante?.fotoUrl;

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppTheme.colorScheme.primary.withValues(alpha: 0.2),
      // Si la foto no carga (URL caída, sin sesión) el CircleAvatar deja ver las iniciales de abajo.
      foregroundImage: foto == null || foto.isEmpty
          ? null
          : (foto.startsWith("assets/") ? AssetImage(foto) as ImageProvider : NetworkImage(foto)),
      child: Text(
        estudiante?.iniciales[0] ?? "J",
        style: TextStyle(
          fontSize: effectiveFontSize,
          fontWeight: FontWeight.bold,
          color: AppTheme.colorScheme.primary,
        ),
      ),
    );
  }
}

