import 'package:flutter/material.dart';
import 'package:miutem/styles/styles.dart';

class HorarioCorner extends StatelessWidget {
  final double height;
  final double width;

  const HorarioCorner({
    super.key,
    required this.height,
    required this.width,
  });

  @override
  Widget build(BuildContext context) => Table(
    defaultColumnWidth: FixedColumnWidth(width),
    border: TableBorder(
      right: BorderSide(
        color: Theme.of(context).dividerColor,
        style: BorderStyle.solid,
        width: 2,
      ),
    ),
    children: [
      TableRow(
        children: [
          Container(
            height: height,
            width: width,
            color: Theme.of(context).scaffoldBackgroundColor,
          ),
        ],
      ),
    ],
  );
}
