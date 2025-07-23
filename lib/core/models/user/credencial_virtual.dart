import 'dart:convert';

import 'package:miutem/core/models/user/persona/rut.dart';

class CredencialVirtual {

  final String nombre;
  final String profilePictureURL;
  final Rut rut;
  final String carrera;


  CredencialVirtual({
    required this.nombre,
    required this.profilePictureURL,
    required this.rut,
    required this.carrera,
  });

  String getBarcodeContent() => "${rut.rut}";

  toJson() => {
    'nombre': nombre,
    'profilePictureURL': profilePictureURL,
    'rut': rut.toString(),
    'carrera': carrera,
  };

  @override
  String toString() => jsonEncode(toJson());
}