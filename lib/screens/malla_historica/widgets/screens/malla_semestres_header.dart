import 'package:flutter/material.dart';
import 'package:miutem/screens/malla_historica/widgets/components/semestre_header_card.dart';

class MallaSemestresHeader extends StatelessWidget {
  final int cantidadSemestres;
  final double height;
  final double semestreWidth;
  final double borderWidth;

  const MallaSemestresHeader({
    super.key,
    required this.cantidadSemestres,
    required this.height,
    required this.semestreWidth,
    this.borderWidth = 2,
  });

  @override
  Widget build(BuildContext context) => Table(
    defaultColumnWidth: FixedColumnWidth(semestreWidth),
    border: TableBorder(
      verticalInside: BorderSide(
        color: Theme.of(context).dividerColor,
        style: BorderStyle.solid,
        width: borderWidth,
      ),
      bottom: BorderSide(
        color: Theme.of(context).dividerColor,
        style: BorderStyle.solid,
        width: borderWidth,
      ),
    ),
    children: [
      TableRow(
        children: List.generate(
          cantidadSemestres,
          (index) => SemestreHeaderCard(
            semestre: index + 1,
            height: height,
            width: semestreWidth,
          ),
        ),
      ),
    ],
  );
}

