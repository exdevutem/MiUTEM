import 'dart:convert';

class HorarioBloque {
  final String dia;
  final String horaInicio;
  final String horaFin;
  final String nombreAsignatura;
  final String sala;

  HorarioBloque({
    required this.dia,
    required this.horaInicio,
    required this.horaFin,
    required this.nombreAsignatura,
    required this.sala,
  });

  toJson() => {
    'dia': dia,
    'horaInicio': horaInicio,
    'horaFin': horaFin,
    'nombreAsignatura': nombreAsignatura,
    'sala': sala,
  };

}
