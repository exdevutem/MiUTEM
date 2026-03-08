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

  factory AsignaturaMalla.fromJson(Map<String, dynamic> json) => AsignaturaMalla(
    nivel: json['nivel'] as int,
    intentos: json['intentos'] as int,
    nombre: json['nombre'] as String,
    tipo: json['tipo'] as String,
    estado: json['estado'] as String,
    nota: json['nota'] as String,
  );

  static List<AsignaturaMalla> fromJsonList(dynamic json) => json != null
      ? (json as List).map((it) => AsignaturaMalla.fromJson(it as Map<String, dynamic>)).toList()
      : [];

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