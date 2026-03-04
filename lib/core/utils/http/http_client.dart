import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/core/utils/http/interceptors/error_interceptor.dart';
import 'package:miutem/core/utils/http/interceptors/headers_interceptor.dart';
import 'package:miutem/core/utils/http/interceptors/log_interceptor.dart';
import 'package:uuid/uuid.dart';

final cacheOptions = CacheOptions(
  store: MemCacheStore(),
  policy: CachePolicy.forceCache,
  hitCacheOnErrorCodes: [500, 502, 503, 504],
  hitCacheOnNetworkFailure: true,
  maxStale: const Duration(days: 7),
  priority: CachePriority.normal,
  allowPostMethod: true,
  keyBuilder: ({required Uri url, Map<String, String>? headers, Object? body}) {
    final queryString = url.query.isNotEmpty ? "?${url.query}" : "";
    final bodyString = body != null ? "/${base64Encode(utf8.encode(body.toString()))}" : "";
    const uuid = Uuid();
    return uuid.v5(miutemUuidNamespace, base64Encode(utf8.encode("${url.origin}${url.path}$queryString$bodyString")));
  },
);

class HttpClient {

  static final cacheInterceptor = DioCacheInterceptor(options: cacheOptions);

  static final Dio dioClient = Dio()..interceptors.addAll([
    HeadersInterceptor(),
    logInterceptor,
  ]);

  static final Dio httpClient = Dio()..interceptors.addAll([
    HeadersInterceptor(),
    logInterceptor,
    errorInterceptor,
  ]);

  static final httpCachedClient = Dio()..interceptors.addAll([
    HeadersInterceptor(),
    logInterceptor,
    errorInterceptor,
    QueuedInterceptorsWrapper(
      onRequest: cacheInterceptor.onRequest,
      onResponse: cacheInterceptor.onResponse,
      onError: cacheInterceptor.onError,
    ),
  ]);

  static Future<void> clearCache() async {
    cacheOptions.store?.clean();
  }
}