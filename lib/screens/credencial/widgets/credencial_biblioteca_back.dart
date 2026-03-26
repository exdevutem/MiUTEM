import "dart:convert";
import "package:flutter/material.dart";
import "package:miutem/core/models/user/credencial/credencial_biblioteca.dart";
import "package:miutem/core/models/user/estudiante.dart";
import "package:miutem/core/utils/utils.dart";
import "package:miutem/styles/styles.dart";
import "package:skeletonizer/skeletonizer.dart";

/// Dorso de la credencial SIBUTEM con QR, perfil, URL, texto legal y logo.
class CredencialBibliotecaBack extends StatelessWidget {
  final CredencialBiblioteca? credencial;
  final Estudiante? estudiante;
  final double? availableHeight;

  const CredencialBibliotecaBack({
    super.key,
    this.credencial,
    this.estudiante,
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              _buildQrImage(context, scale),
              SizedBox(height: 16 * scale),
              Text(
                _getPerfilLabel(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize:
                      (Theme.of(context).textTheme.titleMedium?.fontSize ??
                          16) *
                      scale,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8 * scale),
              Text(
                "https://biblioteca.utem.cl/",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w500,
                  fontSize:
                      (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) *
                      scale,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12 * scale),
              Text(
                "Este documento es personal e intransferible. El atraso en la devolución del material solicitado será sancionado por la biblioteca.",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4,
                  fontSize:
                      (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 14) *
                      scale,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              _buildSibutemLogo(context, scale),
              SizedBox(height: 8 * scale),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrImage(BuildContext context, double scale) {
    final imageBase64 = credencial?.imagenQr;
    final qrImageSize = (140 * scale).clamp(112.0, 140.0).toDouble();
    final qrBoxSize = (192 * scale).clamp(158.0, 192.0).toDouble();
    final iconSize = (80 * scale).clamp(64.0, 80.0).toDouble();
    final qrPadding = (12 * scale).clamp(10.0, 12.0).toDouble();

    Widget qrWidget;

    if (imageBase64 != null && imageBase64.isNotEmpty) {
      try {
        // Remover el prefijo data:image si existe
        String base64String = imageBase64;
        if (imageBase64.contains(",")) {
          base64String = imageBase64.split(",").last;
        }

        final bytes = base64Decode(base64String);
        qrWidget = Image.memory(
          bytes,
          width: qrImageSize,
          height: qrImageSize,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Center(
            child: Icon(
              Icons.qr_code,
              size: iconSize,
              color: themedColor(
                context,
                light: Colors.black38,
                dark: Colors.white38,
              ),
            ),
          ),
          color: Colors.white, // Forzar fondo blanco
          colorBlendMode: BlendMode.modulate,
        );
      } catch (e) {
        // Si falla la decodificación, mostrar icono por defecto
        qrWidget = Center(
          child: Icon(
            Icons.qr_code,
            size: iconSize,
            color: themedColor(
              context,
              light: Colors.black38,
              dark: Colors.white38,
            ),
          ),
        );
      }
    } else {
      qrWidget = Center(
        child: Icon(
          Icons.qr_code,
          size: iconSize,
          color: themedColor(
            context,
            light: Colors.black38,
            dark: Colors.white38,
          ),
        ),
      );
    }

    // El QR siempre debe tener fondo blanco para ser legible
    return Container(
      padding: EdgeInsets.all(qrPadding),
      decoration: BoxDecoration(
        color: themedColor(
          context,
          light: Colors.white,
          dark: const Color(0xFF2A2A2E),
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(width: qrBoxSize, height: qrBoxSize, child: qrWidget),
    );
  }

  Widget _buildSibutemLogo(BuildContext context, double scale) {
    final logoHeight = (72 * scale).clamp(58.0, 72.0).toDouble();

    // Load image /assets/images/sibutem.png
    return Image.asset(
      "assets/images/sibutem.png",
      height: logoHeight,
      fit: BoxFit.contain,
      color: themedColor(context, light: Colors.black, dark: Colors.white),
    );
  }

  String _getPerfilLabel() {
    if (estudiante == null) return "Estudiante";
    final perfil = estudiante!.perfiles.firstOrNull;
    if (perfil == null) return "Estudiante";
    return capitalize(perfil.name);
  }
}
