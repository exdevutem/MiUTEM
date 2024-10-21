import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

final apiUrl = !kDebugMode ? 'https://api.exdev.cl' : (dotenv.env['MI_UTEM_API_DEBUG'] ?? 'https://api.exdev.cl');
const sigaServiceUri = 'https://siga.utem.cl/servicios'; // UTEM SIGA API URL

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
