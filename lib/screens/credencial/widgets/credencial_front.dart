import "package:flutter/material.dart";
import "package:miutem/core/models/user/estudiante.dart";
import "package:miutem/core/utils/utilities.dart";
import "package:miutem/screens/credencial/widgets/perfil_badge.dart";
import "package:miutem/styles/styles.dart";
import "package:miutem/widgets/user_avatar.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:skeletonizer/skeletonizer.dart";

/// Frente de la credencial con avatar, nombre, QR y RUT.
class CredencialFront extends StatelessWidget {
  final Estudiante? usuario;
  final double? availableHeight;

  const CredencialFront({super.key, this.usuario, this.availableHeight});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    height: availableHeight,
    decoration: BoxDecoration(
      color: themedColor(
        context,
        light: Colors.white,
        dark: const Color(0xFF2A2A2E),
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
      border: Border.all(
        color: themedColor(
          context,
          light: Colors.black.withValues(alpha: 0.06),
          dark: Colors.white12,
        ),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Skeletonizer(
        enabled: usuario == null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeader(),
            Space.large,
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: PerfilBadge(perfil: usuario?.perfiles.firstOrNull),
            ),
            Space.extraSmall,
            _buildNombre(context),
            _buildApellido(context),
            Space.large,
            Flexible(
              child: Center(
                child: FittedBox(fit: BoxFit.scaleDown, child: _buildQrCode()),
              ),
            ),
            Space.small,
            _buildRut(context),
          ],
        ),
      ),
    ),
  );

  Widget _buildHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UserAvatar(estudiante: usuario, radius: 80),
        Space.small,
      ],
    );
  }

  Widget _buildNombre(BuildContext context) {
    return Text(
      _getNombres(),
      style: Theme.of(
        context,
      ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
    );
  }

  Widget _buildApellido(BuildContext context) {
    return Text(
      _getApellidos(),
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }

  Widget _buildQrCode() {
    // Tamaño visual base: en alto reducido se escala hacia abajo sin romper layout.
    const qrSize = 256.0;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: QrImageView(
        data: _getQrData(),
        version: QrVersions.auto,
        size: qrSize,
        backgroundColor: Colors.white,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Colors.black,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildRut(BuildContext context) {
    return Center(
      child: Text(
        usuario?.rut?.toString() ?? "12.345.678-9",
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  String _getNombres() {
    if (usuario == null) return "Nombre";
    final parts = usuario!.nombreCompletoCapitalizado.split(" ");
    if (parts.length >= 3) {
      return parts.sublist(0, parts.length - 2).join(" ");
    }
    return parts.first;
  }

  String _getApellidos() {
    if (usuario == null) return "Apellido";
    final parts = usuario!.nombreCompletoCapitalizado.split(" ");
    if (parts.length >= 3) {
      return parts.sublist(parts.length - 2).join(" ");
    }
    if (parts.length == 2) return parts.last;
    return "";
  }

  String _getQrData() {
    if (usuario?.rut == null) return "0";
    return "${usuario!.rut!.rut}";
  }
}
