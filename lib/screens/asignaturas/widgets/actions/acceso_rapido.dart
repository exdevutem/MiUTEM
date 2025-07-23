import 'package:flutter/material.dart';
import 'package:miutem/screens/horario/horario_screen.dart';
import 'package:miutem/screens/notas/notas_screen.dart';

void visitarCalculadoraNotas(BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const NotasScreen()));

void visitarHorario(BuildContext context) => Navigator.push(context, MaterialPageRoute(builder: (ctx) => const HorarioScreen()));