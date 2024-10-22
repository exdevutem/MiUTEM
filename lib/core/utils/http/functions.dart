import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get/get.dart' hide Response;
import 'package:miutem/core/models/exceptions/custom_exception.dart';
import 'package:miutem/core/models/preferencia.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/core/utils/http/http_client.dart';


/// Función para realizar solicitudes mediante el httpClient a Siga.UTEM.
/// Esta función además genera un [CacheOptions] con opciones personalizadas por defecto.
/// También esta función utiliza `$sigaServiceUri/` como prefijo.
///
/// [path] es el endpoint al que se desea acceder. No puede tener el prefijo `/`.
/// [method] es el método HTTP a utilizar.
/// [data] es un mapa con los datos a enviar.
/// [options] son las opciones personalizadas para la solicitud.
/// [forceRefresh] fuerza a que se realice una solicitud nueva.
/// [ttl] es el tiempo que se guardará en caché la solicitud.
Future<Response> sigaClientRequest(String path, {
  String method = "GET",
  Map<String, String>? headers,
  dynamic data,
  String? contentType,
  ResponseType? responseType,
  Options? options,
  bool forceRefresh = false,
  Duration ttl = const Duration(days: 7),
  Map<String, dynamic>? extra,
  Map<String, dynamic>? queryParameters,
  Map<String, dynamic> sigaParams = const {},
}) async {
  try {
    Map<String, dynamic> params = {
      ...sigaParams
    };
    if((extra?['noToken'] ?? false) != true) {
      params['token'] = await Get.find<AuthService>().activeToken();
    }

    return await HttpClient.authClientSiga.request("$sigaServiceUri/$path",
      data: data ?? params.entries.map((e) => "${e.key}=${Uri.encodeFull(e.value)}").join("&"),
      queryParameters: queryParameters,
      options: options ?? buildCacheOptions(ttl,
        forceRefresh: forceRefresh,
        primaryKey: 'api_siga.miutem',
        subKey: path,
        maxStale: const Duration(days: 14),
        options: (options ?? Options()).copyWith(
          method: method,
          headers: headers,
          contentType: contentType,
          responseType: responseType,
          extra: extra,
        ),
      ),
    );
  } on SocketException {
    throw CustomException(message: 'Error al conectar con la API. Por favor intenta más tarde.');
  } catch (e) {
    rethrow;
  }
}

Future<bool> isOffline() async {
  bool offlineMode = (await Preferencia.isOffline.getAsBool(defaultValue: false, guardar: true));

  try {
    final response = await HttpClient.dioClient.head(sigaServiceUri);
    offlineMode = !"${response.statusCode}".startsWith("2");
  } catch (e) {
    logger.e("[HttpRequest#isOffline]: Error al conectar con la API", error: e);
    offlineMode = true;
  }

  await Preferencia.isOffline.set(offlineMode.toString());
  return offlineMode;
}