import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/core/utils/http/interceptors/auth_interceptor.dart';
import 'package:miutem/core/utils/http/interceptors/error_interceptor.dart';
import 'package:miutem/core/utils/http/interceptors/headers_interceptor.dart';
import 'package:miutem/core/utils/http/interceptors/log_interceptor.dart';
import 'package:miutem/core/utils/http/interceptors/offline_mode_interceptor.dart';

class HttpClient {

  static final DioCacheManager cacheManagerSiga = DioCacheManager(CacheConfig(
    baseUrl: sigaServiceUri,
    defaultMaxAge: const Duration(days: 7),
    defaultMaxStale: const Duration(days: 14),
  ));

  static final Dio dioClient = Dio()..interceptors.addAll([
    HeadersInterceptor(),
    logInterceptor,
  ]);

  static final Dio httpClient = dioClient..interceptors.addAll([
    OfflineModeInterceptor(),
    errorInterceptor,
  ]);

  static final Dio authClientSiga = httpClient..interceptors.addAll([
    AuthInterceptorSiga(),
    cacheManagerSiga.interceptor,
    QueuedInterceptorsWrapper(onRequest: (options, handler) {
      logger.d('[HttpClient#authClientSiga]: ${options.method} ${options.uri}\n${options.data}');
      return handler.next(options);
    }),
  ]);

  static Future<void> clearCache() async {
    await cacheManagerSiga.clearAll();
  }
}