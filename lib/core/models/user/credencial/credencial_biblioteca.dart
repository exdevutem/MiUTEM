import 'dart:convert';

import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/models/user/persona/rut.dart';

class CredencialBiblioteca {

  final String nombre;
  final String profilePictureURL;
  final Rut rut;
  final String area;
  final String imagenQr;

  const CredencialBiblioteca({
    required this.nombre,
    required this.profilePictureURL,
    required this.rut,
    required this.area,
    required this.imagenQr,
  });

  String getBarcodeContent() => "${rut.rut}";

  toJson() => {
    'nombre': nombre,
    'profilePictureURL': profilePictureURL,
    'rut': rut.toString(),
    'area': area,
    'imagenQr': imagenQr,
  };

  @override
  String toString() => jsonEncode(toJson());
}