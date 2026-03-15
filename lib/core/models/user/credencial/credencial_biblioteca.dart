import "dart:convert";

import "package:miutem/core/models/user/persona/rut.dart";

class CredencialBiblioteca {

  final String nombre;
  final String imagenPerfil;
  final Rut rut;
  final String area;
  final String imagenQr;

  const CredencialBiblioteca({
    required this.nombre,
    required this.imagenPerfil,
    required this.rut,
    required this.area,
    required this.imagenQr,
  });

  String getBarcodeContent() => "${rut.rut}";

  Map<String, String> toJson() => {
    "nombre": nombre,
    "imagenPerfil": imagenPerfil,
    "rut": rut.toString(),
    "area": area,
    "imagenQr": imagenQr,
  };

  @override
  String toString() => jsonEncode(toJson());
}