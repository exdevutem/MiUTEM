import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:miutem/core/utils/theme.dart';

class BloqueVacio extends StatelessWidget {
  const BloqueVacio({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.lightGrey,
        borderRadius: BorderRadius.circular(15),
      ),
      child: DottedBorder(
        strokeWidth: 2,
        color: AppTheme.grey,
        borderType: BorderType.RRect,
        radius: Radius.circular(15),
        child: Container(),
      ),
    );
  }
}