import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miutem/styles/styles.dart';

class BloqueDiasCard extends StatelessWidget {
  final String day;
  final double width;
  final double height;
  final bool active;

  const BloqueDiasCard({
    super.key,
    required this.day,
    required this.width,
    required this.height,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: width,
    child: DecoratedBox(
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(day.trim(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    ),
  );
}
