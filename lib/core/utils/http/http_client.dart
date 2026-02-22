import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/core/utils/http/interceptors/error_interceptor.dart';
import 'package:miutem/core/utils/http/interceptors/headers_interceptor.dart';
import 'package:miutem/core/utils/http/interceptors/log_interceptor.dart';
import 'package:miutem/core/utils/http/interceptors/offline_mode_interceptor.dart';

class HttpClient {

  static final DioCacheManager cacheManager = DioCacheManager(CacheConfig(
    defaultMaxAge: const Duration(days: 7),
    defaultMaxStale: const Duration(days: 14),
  ));

  static final DioCacheManager cacheManagerSiga = DioCacheManager(CacheConfig(
    baseUrl: sigaServiceUri,
    defaultMaxAge: const Duration(days: 7),
    defaultMaxStale: const Duration(days: 14),
  ));

  static final Dio dioClient = Dio()..interceptors.addAll([
    HeadersInterceptor(),
    logInterceptor,
  ]);

  static final Dio httpClient = Dio()..interceptors.addAll([
    HeadersInterceptor(),
    logInterceptor,
    OfflineModeInterceptor(),
    errorInterceptor,
  ]);

  static final httpCachedClient = Dio()..interceptors.addAll([
    HeadersInterceptor(),
    logInterceptor,
    OfflineModeInterceptor(),
    errorInterceptor,
    cacheManager.interceptor,
  ]);

  static final Dio authClientSiga = Dio()..interceptors.addAll([
    HeadersInterceptor(),
    logInterceptor,
    OfflineModeInterceptor(),
    errorInterceptor,
    cacheManagerSiga.interceptor,
  ]);

  static Future<void> clearCache() async {
    await cacheManagerSiga.clearAll();
    await cacheManager.clearAll();
  }
}