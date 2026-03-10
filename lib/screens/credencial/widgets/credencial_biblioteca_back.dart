import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:miutem/core/models/user/credencial/credencial_biblioteca.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/styles/styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: availableHeight,
      decoration: BoxDecoration(
        color: themedColor(context, light: Colors.white, dark: const Color(0xFF2A2A2E)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(
          color: themedColor(context, light: Colors.black.withValues(alpha: 0.06), dark: Colors.white12),
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
              _buildQrImage(context),
              Space.medium,
              Text(_getPerfilLabel(),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              Space.extraSmall,
              Text('https://biblioteca.utem.cl/',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              Space.small,
              Text('Este documento es personal e intransferible. El atraso en la devolución del material solicitado será sancionado por la biblioteca.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              _buildSibutemLogo(context),
              Space.extraSmall,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQrImage(BuildContext context) {
    final imageBase64 = credencial?.imagenQr;

    Widget qrWidget;

    if (imageBase64 != null && imageBase64.isNotEmpty) {
      try {
        // Remover el prefijo data:image si existe
        String base64String = imageBase64;
        if (imageBase64.contains(',')) {
          base64String = imageBase64.split(',').last;
        }

        final bytes = base64Decode(base64String);
        qrWidget = Image.memory(
          bytes,
          width: 140,
          height: 140,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Center(
            child: Icon(Icons.qr_code, size: 80, color: themedColor(context, light: Colors.black38, dark: Colors.white38)),
          ),
          color: Colors.white, // Forzar fondo blanco
          colorBlendMode: BlendMode.modulate,
        );
      } catch (e) {
        // Si falla la decodificación, mostrar icono por defecto
        qrWidget = Center(
          child: Icon(Icons.qr_code, size: 80, color: themedColor(context, light: Colors.black38, dark: Colors.white38)),
        );
      }
    } else {
      qrWidget = Center(
        child: Icon(Icons.qr_code, size: 80, color: themedColor(context, light: Colors.black38, dark: Colors.white38)),
      );
    }

    // El QR siempre debe tener fondo blanco para ser legible
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: themedColor(context, light: Colors.white, dark: const Color(0xFF2A2A2E)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        width: 192,
        height: 192,
        child: qrWidget,
      ),
    );
  }

  Widget _buildSibutemLogo(BuildContext context) {
    // Load image /assets/images/sibutem.png
    return Image.asset(
      'assets/images/sibutem.png',
      height: 72,
      fit: BoxFit.contain,
      color: themedColor(context, light: Colors.black, dark: Colors.white),
    );
  }

  String _getPerfilLabel() {
    if (estudiante == null) return 'Estudiante';
    final perfil = estudiante!.perfiles.firstOrNull;
    if (perfil == null) return 'Estudiante';
    return capitalize(perfil.name);
  }
}
