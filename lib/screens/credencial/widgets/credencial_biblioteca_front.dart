import "dart:convert";

import "package:barcode_widget/barcode_widget.dart";
import "package:flutter/material.dart";
import "package:miutem/core/models/user/credencial/credencial_biblioteca.dart";
import "package:miutem/core/utils/utilities.dart";
import "package:miutem/styles/styles.dart";
import "package:skeletonizer/skeletonizer.dart";

/// Frente de la credencial SIBUTEM con avatar, nombre, RUT, área y código de barras.
class CredencialBibliotecaFront extends StatelessWidget {
  final CredencialBiblioteca? credencial;
  final double? availableHeight;

  const CredencialBibliotecaFront({
    super.key,
    this.credencial,
    this.availableHeight,
  });

  double _responsiveScale() {
    final height = availableHeight ?? 680;
    return (height / 680).clamp(0.82, 1.0).toDouble();
  }

  @override
  Widget build(BuildContext context) {
    final scale = _responsiveScale();

    return Container(
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
          enabled: credencial == null,
          child: Column(
            children: [
              const Spacer(),
              _buildAvatar(scale),
              SizedBox(height: 20 * scale),
              Text(
                credencial?.nombre ?? "Nombre Completo",
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize:
                      (Theme.of(context).textTheme.titleLarge?.fontSize ?? 22) *
                      scale,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 20 * scale),
              Text(
                credencial?.rut.toString() ?? "12.345.678-9",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  fontSize:
                      (Theme.of(context).textTheme.titleMedium?.fontSize ??
                          16) *
                      scale,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20 * scale),
              Text(
                credencial?.area ?? "Área",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize:
                      (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) *
                      scale,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              _buildBarcode(context, scale),
              SizedBox(height: 8 * scale),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(double scale) {
    final rawImage = credencial?.imagenPerfil.trim();
    final hasValidImage = _hasValidProfileImage(rawImage);
    final radius = (96 * scale).clamp(78.0, 96.0).toDouble();
    final fontSize = (72 * scale).clamp(58.0, 72.0).toDouble();

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppTheme.colorScheme.primary.withValues(alpha: 0.2),
      backgroundImage: hasValidImage ? _buildProfileImage(rawImage!) : null,
      child: hasValidImage
          ? null
          : Text(
              credencial?.nombre.isNotEmpty == true
                  ? credencial!.nombre[0].toUpperCase()
                  : "U",
              style: TextStyle(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: AppTheme.colorScheme.primary,
              ),
            ),
    );
  }

  bool _hasValidProfileImage(String? value) =>
      value != null && value.isNotEmpty && !value.contains("sin_imagen");

  ImageProvider _buildProfileImage(String imageValue) {
    final normalized = imageValue.trim();

    if (normalized.startsWith("http://") || normalized.startsWith("https://")) {
      return NetworkImage(normalized);
    }

    final base64Data = normalized.contains(",")
        ? normalized.substring(normalized.indexOf(",") + 1)
        : normalized;

    return MemoryImage(base64Decode(base64Data));
  }

  Widget _buildBarcode(BuildContext context, double scale) {
    final barcodeHeight = (80 * scale).clamp(66.0, 80.0).toDouble();
    final verticalPadding = (12 * scale).clamp(10.0, 12.0).toDouble();

    // El código de barras siempre debe tener fondo blanco para ser legible
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: verticalPadding),
      decoration: BoxDecoration(
        color: themedColor(
          context,
          light: Colors.white,
          dark: const Color(0xFF2A2A2E),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: BarcodeWidget(
        color: themedColor(context, light: Colors.black87, dark: Colors.white),
        barcode: Barcode.code128(),
        data: credencial?.getBarcodeContent() ?? "0",
        width: double.infinity,
        height: barcodeHeight,
        drawText: false,
      ),
    );
  }
}
