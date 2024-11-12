import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/horario.dart';
import 'package:miutem/screens/horario/controller/horario_controller.dart';


class BloqueClase extends StatelessWidget {
  final BloqueHorario block;
  final double width;
  final double height;
  final Color textColor;
  final Color? color;
  final void Function(BloqueHorario)? onTap;
  final void Function(BloqueHorario)? onLongPress;

  const BloqueClase({
    super.key,
    required this.block,
    required this.width,
    required this.height,
    required this.textColor,
    this.color = Colors.teal,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: Get.find<HorarioController>().getColor(block.asignatura) ?? this.color,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: () => onTap?.call(block),
        onLongPress: () => onLongPress?.call(block),
        child: Column(
          children: [
            HorarioText.classCode("${block.codigo}",
              color: textColor,
            ),
            HorarioText.className("${block.asignatura?.nombre.toUpperCase()}",
              color: textColor,
            ),
            HorarioText.classLocation(block.sala ?? "Sin sala",
              color: textColor,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ),
    ),
  );
}


/// TODO esto se puede pasar a theme, pero no quise agregarlo aun porque no se si se va a ocupar en otro lado
class HorarioText extends Text {
  HorarioText._(
      String text, {
        Key? key,
        required TextAlign textAlign,
        required Color color,
        int? maxLines,
        required bool bold,
        double? wordSpacing,
        double? letterSpacing,
      }) : super(
    text,
    key: key,
    maxLines: maxLines,
    textAlign: textAlign,
    style: TextStyle(
      fontSize: 18,
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      color: color,
      wordSpacing: wordSpacing,
      letterSpacing: letterSpacing,
    ),
  );

  factory HorarioText.classCode(
      String text, {
        Color color = Colors.white,
        TextAlign textAlign = TextAlign.center,
      }) =>
      HorarioText._(
        text,
        bold: false,
        color: color,
        textAlign: textAlign,
      );

  factory HorarioText.className(
      String text, {
        Color color = Colors.white,
        TextAlign textAlign = TextAlign.center,
      }) =>
      HorarioText._(
        text,
        maxLines: 3,
        bold: true,
        letterSpacing: 0.5,
        wordSpacing: 1,
        color: color,
        textAlign: textAlign,
      );

  factory HorarioText.classLocation(
      String text, {
        Color color = Colors.white,
        TextAlign textAlign = TextAlign.center,
      }) =>
      HorarioText._(
        text,
        maxLines: 2,
        bold: false,
        color: color,
        textAlign: textAlign,
      );
}