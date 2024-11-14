import 'dart:convert';

import 'package:miutem/core/models/tokenized_object.dart';
import 'package:miutem/core/models/user/perfil.dart';
import 'package:miutem/core/models/user/persona/persona.dart';
import 'package:miutem/core/models/user/persona/rut.dart';

class Estudiante extends PersonaUtem with TokenizedObject {

  @override
  final String token;

  final String correoPersonal;
  final List<Perfil> perfiles;

  Estudiante({
    required this.token,
    required super.rut,
    required super.nombreCompleto,
    required super.correoUtem,
    required this.correoPersonal,
    required super.fotoUrl,
    required this.perfiles,
  });

  factory Estudiante.fromJson(Map<String, dynamic> json) {
    final datosPersona = json['datos_persona'];

    return Estudiante(
      token: json['token'],
      rut: Rut.fromString("${datosPersona['rut']}"),
      nombreCompleto: datosPersona['nombre_completo'],
      correoPersonal: datosPersona['correo_personal'],
      correoUtem: datosPersona['correo_utem'],
      fotoUrl: datosPersona['foto'],
      perfiles: Perfil.values.where((perfil) => (datosPersona['perfiles'] as List).map((perfil) => (perfil as String).toLowerCase()).contains(perfil.name)).toList(),
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'token': token,
    'datos_persona': {
      'rut': rut?.rut,
      'nombre_completo': nombreCompleto,
      'correo_personal': correoPersonal,
      'correo_utem': correoUtem,
      'foto': fotoUrl,
      'perfiles': perfiles.map((perfil) => perfil.name).toList(),
    },
  };

  @override
  String toString() => jsonEncode(toJson());
}