import 'dart:math';

import 'package:flutter/material.dart';
import 'package:miutem/styles/styles.dart';

/// Painter para el arte abstracto del dorso de la credencial.
class AbstractArtPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  AbstractArtPainter({
    required this.primaryColor,
    required this.secondaryColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawBackground(canvas, size);
    _drawCircles(canvas, size);
    _drawCurves(canvas, size);
    _drawDots(canvas, size);
  }

  void _drawBackground(Canvas canvas, Size size) {
    final bgPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryColor,
          secondaryColor,
          primaryColor.withValues(alpha: 0.8),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);
  }

  void _drawCircles(Canvas canvas, Size size) {
    final circlePaint = Paint()..style = PaintingStyle.fill;

    circlePaint.color = Colors.white.withValues(alpha: 0.08);
    canvas.drawCircle(
      Offset(size.width * 0.8, size.height * 0.2),
      size.width * 0.4,
      circlePaint,
    );

    circlePaint.color = Colors.white.withValues(alpha: 0.06);
    canvas.drawCircle(
      Offset(size.width * 0.15, size.height * 0.75),
      size.width * 0.35,
      circlePaint,
    );

    circlePaint.color = Colors.white.withValues(alpha: 0.05);
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.5),
      size.width * 0.25,
      circlePaint,
    );
  }

  void _drawCurves(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final path1 = Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.1,
        size.width,
        size.height * 0.4,
      );
    canvas.drawPath(path1, linePaint);

    final path2 = Path()
      ..moveTo(0, size.height * 0.6)
      ..quadraticBezierTo(
        size.width * 0.6,
        size.height * 0.9,
        size.width,
        size.height * 0.7,
      );
    canvas.drawPath(path2, linePaint);
  }

  void _drawDots(Canvas canvas, Size size) {
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final random = Random(42);
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final r = random.nextDouble() * 3 + 1;
      canvas.drawCircle(Offset(x, y), r, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant AbstractArtPainter oldDelegate) =>
      primaryColor != oldDelegate.primaryColor ||
      secondaryColor != oldDelegate.secondaryColor;
}

/// Dorso de la credencial con arte abstracto y logo UTEM.
class CredencialBack extends StatelessWidget {
  final double? availableHeight;

  const CredencialBack({super.key, this.availableHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: availableHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: CustomPaint(
          painter: AbstractArtPainter(
            primaryColor: AppTheme.colorScheme.primary,
            secondaryColor: AppTheme.colorScheme.secondary,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/utem_logo_color_blanco.png',
                    height: 60,
                    errorBuilder: (_, __, ___) => const Icon(
                      AppIcons.credential,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Universidad Tecnológica\nMetropolitana',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

