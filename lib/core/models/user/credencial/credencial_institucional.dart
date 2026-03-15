/*
 * Representa el modelo de una credencial física para utilizar dentro de la app.
 */
import "package:miutem/core/models/facultad.dart";
import "package:miutem/core/models/user/perfil.dart";
import "package:miutem/core/models/user/persona/persona.dart";

class CredencialInstitucional {
  final Persona persona;
  final Perfil perfil;
  final Facultad? facultad;

  const CredencialInstitucional({
    required this.persona,
    required this.perfil,
    this.facultad,
  });
}