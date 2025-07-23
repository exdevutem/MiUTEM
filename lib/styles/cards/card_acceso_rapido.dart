import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:miutem/core/utils/utilities.dart';

class CardAccesoRapido extends StatelessWidget {
  final Color color, colorDark;
  final String label;
  final IconData icon;
  final Function() onTap;
  final double fill;

  const CardAccesoRapido({super.key, required this.color, required this.label, required this.icon, required this.onTap, required this.colorDark, this.fill = 1.0});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: ValueListenableBuilder<AdaptiveThemeMode>(
      valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
      builder: (ctx, mode, child) => DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: themedColor(context, light: color, dark: colorDark),
        ),
        child: SizedBox(
          width: 120,
          height: 120,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12,20,12,20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, fill: fill, size: 32, weight: 600, color: Theme.of(context).textTheme.bodyMedium?.color),
                const Spacer(),
                Text(label, style: Theme.of(context).textTheme.labelMedium),
              ],
            ),
          ),
        ),
      ),
    ),
  );

}
