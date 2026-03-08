import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:miutem/core/models/user/persona/persona.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/core/utils/logger.dart';
import 'package:miutem/core/utils/utilities.dart';
import 'package:uuid/uuid.dart';

/// Genera el user id para los servicios de analytics, usando el correo del estudiante, pero encriptado para no guardar datos sensibles.
String generateUserId(String correo) {
  final correoFinal = apply<String, String>(correo, (c) => c.endsWith('@utem.cl') ? c : '$c@utem.cl').toLowerCase();
  const uuid = Uuid();
  return uuid.v5(miutemUuidNamespace, correoFinal);
}

void setUserIdentifier(PersonaUtem persona) {
  final id = generateUserId(persona.correoUtem);
  FirebaseCrashlytics.instance.setUserIdentifier(id);
  logger.d('Se usará "$id" como ID de usuario para los servicios de analytics.');
}