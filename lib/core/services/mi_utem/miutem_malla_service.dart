import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart' show parse;
import 'package:miutem/core/models/asignaturas/asignatura_malla.dart';
import 'package:miutem/core/models/exceptions/custom_exception.dart';
import 'package:miutem/core/services/mi_utem/miutem_auth_service.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/core/utils/http/http_client.dart';
import 'package:miutem/core/utils/utils.dart';

const String _mallaCacheKey = "malla_cache";
const String _mallaCacheTimestampKey = "malla_cache_timestamp";
const Duration _cacheDuration = Duration(hours: 6);

class MiUTEMMallaService {

  static MiUTEMMallaService get get => Get.find<MiUTEMMallaService>();

  /// Caché en memoria para evitar lecturas repetidas de SharedPreferences
  List<AsignaturaMalla>? _memoryCache;
  DateTime? _memoryCacheTimestamp;

  /// Obtiene la malla, usando caché si está disponible y no ha expirado.
  /// [forceRefresh] fuerza una actualización desde el servidor.
  Future<List<AsignaturaMalla>> getMalla({bool forceRefresh = false}) async {
    // Si no se fuerza refresh, intentar obtener desde caché
    if (!forceRefresh) {
      final cachedMalla = await _getCachedMalla();
      if (cachedMalla != null) {
        return cachedMalla;
      }
    }

    // Obtener desde el servidor
    final malla = await _fetchMallaFromServer();

    // Guardar en caché
    await _saveMallaToCache(malla);

    return malla;
  }

  /// Obtiene la malla desde el caché (memoria o persistente)
  Future<List<AsignaturaMalla>?> _getCachedMalla() async {
    // Primero revisar caché en memoria
    if (_memoryCache != null && _memoryCacheTimestamp != null) {
      if (DateTime.now().difference(_memoryCacheTimestamp!) < _cacheDuration) {
        logger.d('Malla obtenida desde caché en memoria');
        return _memoryCache;
      }
    }

    // Si no hay caché en memoria, revisar SharedPreferences
    try {
      final cachedData = await sharedPreferences.getString(_mallaCacheKey);
      final cachedTimestamp = await sharedPreferences.getInt(_mallaCacheTimestampKey);

      if (cachedData != null && cachedTimestamp != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(cachedTimestamp);
        if (DateTime.now().difference(cacheTime) < _cacheDuration) {
          final jsonList = jsonDecode(cachedData) as List<dynamic>;
          final malla = AsignaturaMalla.fromJsonList(jsonList);

          // Actualizar caché en memoria
          _memoryCache = malla;
          _memoryCacheTimestamp = cacheTime;

          logger.d('Malla obtenida desde caché persistente');
          return malla;
        }
      }
    } catch (e) {
      logger.e('Error al leer caché de malla', error: e);
    }

    return null;
  }

  /// Guarda la malla en caché (memoria y persistente)
  Future<void> _saveMallaToCache(List<AsignaturaMalla> malla) async {
    final now = DateTime.now();

    // Guardar en memoria
    _memoryCache = malla;
    _memoryCacheTimestamp = now;

    // Guardar en SharedPreferences
    try {
      final jsonString = jsonEncode(malla.map((e) => e.toJson()).toList());
      await sharedPreferences.setString(_mallaCacheKey, jsonString);
      await sharedPreferences.setInt(_mallaCacheTimestampKey, now.millisecondsSinceEpoch);
      logger.d('Malla guardada en caché');
    } catch (e) {
      logger.e('Error al guardar caché de malla', error: e);
    }
  }

  /// Limpia el caché de la malla
  Future<void> clearCache() async {
    _memoryCache = null;
    _memoryCacheTimestamp = null;
    await sharedPreferences.remove(_mallaCacheKey);
    await sharedPreferences.remove(_mallaCacheTimestampKey);
    logger.d('Caché de malla limpiado');
  }

  /// Obtiene la malla directamente desde el servidor
  Future<List<AsignaturaMalla>> _fetchMallaFromServer() async {
    final cookie = await MiUTEMAuthService.get.login();
    final response = await HttpClient.httpCachedClient.get("$miUtemHost/academicos/mi-malla",
      options: Options(
        headers: {
          'Cookie': cookie,
          'User-Agent': genericUserAgent,
        }
      )
    );

    final html = "${response.data}";
    if(!html.contains("La información proporcionada en el módulo debe ser validada por la Dirección General de Docencia.")) {
      throw CustomException(message: "No se pudo obtener la malla. Por favor intenta más tarde.", internalCode: 1);
    }

    final htmlDoc = parse(html).documentElement;
    if(htmlDoc == null) {
      throw CustomException(message: "No se pudo obtener la malla. Por favor intenta más tarde.", internalCode: 2);
    }

    logger.d('Malla obtenida desde el servidor');
    return (htmlDoc.querySelectorAll("#avance-malla").first.querySelectorAll("#table-avance").first).querySelectorAll("tbody > tr").map((it) {
      final parts = it.children;
      var nota = parts[5].text.trim();
      if(nota.isEmpty) {
        nota = "-";
      }

      return AsignaturaMalla(
        nivel: int.tryParse(parts[0].text.trim()) ?? 0,
        nombre: parts[1].text.trim(),
        tipo: parts[2].text.trim(),
        intentos: int.tryParse(parts[3].text.trim()) ?? 0,
        estado: parts[4].text.trim(),
        nota: nota,
      );
    }).toList();
  }
}