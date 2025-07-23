import 'package:dio/dio.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:package_info_plus/package_info_plus.dart';

class HeadersInterceptor extends Interceptor {

  String? _userAgent;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final headers = options.headers;
    if(_userAgent == null) { // Obtiene la versión de la app una sola vez para mejorar rendimiento
      final info = await PackageInfo.fromPlatform();
      _userAgent = 'App/MiUTEM v${info.version} (${info.buildNumber})';
    }

    if(!headers.containsKey('User-Agent')) {
      headers['User-Agent'] = _userAgent;
    }

    if(options.data != null && !headers.containsKey('Content-Type')) {
      headers['Content-Type'] = 'application/json';
    }
    options.headers = headers;

    super.onRequest(options, handler);
  }
}