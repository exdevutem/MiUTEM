import 'package:flutter/material.dart';
import 'package:miutem/styles/styles.dart';

class SemestreHeaderCard extends StatelessWidget {
  final int semestre;
  final double width;
  final double height;

  const SemestreHeaderCard({
    super.key,
    required this.semestre,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: width,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Sem.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            '$semestre',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );
}

