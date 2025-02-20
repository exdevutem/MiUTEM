import 'package:flutter/material.dart';
import 'package:miutem/styles/styles.dart';

class BloquePeriodoCard extends StatelessWidget {
  final String? inicio;
  final String? intermedio;
  final String? fin;
  final double height;
  final double width;
  final bool active;
  final Color backgroundColor;

  const BloquePeriodoCard({
    super.key,
    required this.inicio,
    required this.intermedio,
    required this.fin,
    required this.height,
    required this.width,
    this.backgroundColor = AppTheme.greyLight,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(color: backgroundColor),
    height: height,
    width: width,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(inicio!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(intermedio!,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: TextStyle(
            letterSpacing: 0.5,
            wordSpacing: 1,
            color: Colors.black54,
            fontSize: 14,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(fin!,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        )
      ],
    ),
  );
}
