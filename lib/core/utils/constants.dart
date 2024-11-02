import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final apiUrl = !kDebugMode ? 'https://api.exdev.cl' : (dotenv.env['MI_UTEM_API_DEBUG'] ?? 'https://api.exdev.cl');
const sigaHost = 'https://siga.utem.cl';
const sigaServiceUri = '$sigaHost/servicios'; // UTEM SIGA API URL

const String sentryDsn = 'https://c03edae5839c62f95de91c1cbabb65d7@o4506938204553216.ingest.us.sentry.io/4506938205470720';
const String uxCamDevKey = '0y6p88obpgiug1g';
const String uxCamProdKey = 'fxkjj5ulr7vb4yf';

/// Logger de la app.
final logger = Logger(printer: PrettyPrinter());
/// Secure storage para guardar datos sensibles.
const secureStorage = FlutterSecureStorage();

/// SharedPreferences para guardar datos no sensibles.
final SharedPreferencesAsync sharedPreferences = SharedPreferencesAsync();

/// Días de la semana.
const days = ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"];

/// Meses del año.
const months = ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"];

/// Formatea una nota en formato de 1 o 2 decimales dependiendo de si es un 3.95 o no.
final notaInputFormatter = TextInputFormatter.withFunction((prev, input) {
  final val = input.text;
  if(val.isEmpty) { // Si está vacío, no hacer nada
    return input;
  }

  final firstDigit = int.tryParse(val[0]);
  if(firstDigit != null && (firstDigit < 1 || firstDigit > 7)) { // Si el primer dígito es menor a 1 o mayor a 7, no hacer nada
    return prev;
  }

  if(val.length == 1) {
    return input;
  }

  final secondDigit = int.tryParse(val[1]);
  if(secondDigit != null && ((secondDigit < 0 || secondDigit > 9) || (firstDigit == 7 && secondDigit > 0)) || val.length > 3) { // Si el segundo dígito es menor a 0 o mayor a 9, o si el primer dígito es 7 y el segundo dígito es mayor a 0, no hacer nada
    return prev;
  }

  return input;
});
