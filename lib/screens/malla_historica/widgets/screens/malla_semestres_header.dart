import "package:flutter/material.dart";
import "package:miutem/screens/malla_historica/widgets/components/semestre_header_card.dart";

class MallaSemestresHeader extends StatelessWidget {
  final int cantidadSemestres;

  const MallaSemestresHeader({
    super.key,
    required this.cantidadSemestres,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        cantidadSemestres,
        (index) => Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: index < cantidadSemestres - 1
                    ? BorderSide(color: Theme.of(context).dividerColor)
                    : BorderSide.none,
                bottom: BorderSide(color: Theme.of(context).dividerColor),
              ),
            ),
            child: SemestreHeaderCard(semestre: index + 1),
          ),
        ),
      ),
    );
  }
}
