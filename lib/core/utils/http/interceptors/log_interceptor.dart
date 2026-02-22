import 'package:dio/dio.dart';
import 'package:miutem/core/utils/utils.dart';

/// Headers whose values must never appear in logs.
const _sensitiveHeaders = {
  'authorization', 'cookie', 'set-cookie',
  'x-api-key', 'api-key', 'api_key',
  'x-auth-token', 'refresh-token', 'session-id',
};

/// Form-encoded / JSON body keys whose values must never appear in logs.
const _sensitiveBodyKeys = {'password', 'token', 'username', 'rut', 'pass'};

/// Pre-compiled regex that matches sensitive key=value pairs in
/// application/x-www-form-urlencoded strings.
final _sensitiveBodyRegex = RegExp(
  r'((?:^|&)(?:' + _sensitiveBodyKeys.join('|') + r')=)([^&]*)',
  caseSensitive: false,
);

/// Returns a copy of [headers] with sensitive values replaced by `[REDACTED]`.
Map<String, dynamic> _redactHeaders(Map<String, dynamic> headers) => {
  for (final entry in headers.entries)
    entry.key: _sensitiveHeaders.contains(entry.key.toLowerCase())
        ? '[REDACTED]'
        : entry.value,
};

/// Returns a sanitised representation of [data].
/// Redacts known sensitive keys when [data] is a [Map].
/// When [data] is a URL-encoded string the sensitive keys are also redacted.
String _redactBody(dynamic data) {
  if (data == null) return '';
  if (data is Map) {
    final redacted = {
      for (final entry in data.entries)
        entry.key: entry.key is String && _sensitiveBodyKeys.contains((entry.key as String).toLowerCase())
            ? '[REDACTED]'
            : entry.value,
    };
    return redacted.toString();
  }
  if (data is String) {
    // Redact values in application/x-www-form-urlencoded strings.
    return data.replaceAllMapped(
      _sensitiveBodyRegex,
      (m) => '${m[1]}[REDACTED]',
    );
  }
  return data.toString();
}

InterceptorsWrapper logInterceptor = InterceptorsWrapper(
  onRequest: (RequestOptions options, RequestInterceptorHandler handler) {
    final now = DateTime.now();
    logger.d("[HttpClient - ${now.toIso8601String()}]: ${options.method.toUpperCase()} ${options.uri}\nHeaders: ${_redactHeaders(options.headers)}\nExtra: ${options.extra}\nData: ${_redactBody(options.data)}");
    options.extra["request_created_at"] = now.toIso8601String();
    return handler.next(options);
  },
  onResponse: (Response response, ResponseInterceptorHandler handler) {
    final now = DateTime.now();
    final requestCreatedAt = DateTime.tryParse(response.requestOptions.extra["request_created_at"] as String);
    if(requestCreatedAt != null) {
      final difference = now.difference(requestCreatedAt).inMilliseconds;
      logger.d("[HttpClient - $requestCreatedAt]: ${response.statusCode} > ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.uri} ${difference}ms${response.headers.value('content-type')?.startsWith('text/html') == true ? '' : '\nResponse: ${response.data}'}");
    }
    return handler.next(response);
  },
);