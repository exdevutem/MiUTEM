import 'dart:convert';

class AsignaturaMalla {
  final int nivel, intentos;
  final String nombre, tipo, estado, nota;

  AsignaturaMalla({
    required this.nivel,
    required this.intentos,
    required this.nombre,
    required this.tipo,
    required this.estado,
    required this.nota,
  });

  toJson() => {
    'nivel': nivel,
    'intentos': intentos,
    'nombre': nombre,
    'tipo': tipo,
    'estado': estado,
    'nota': nota,
  };

  @override
  String toString() => jsonEncode(toJson());

}