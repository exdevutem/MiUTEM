import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/core/utils/constants.dart';

class AuthInterceptorSiga extends QueuedInterceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final data = options.extra['sigaParams'] ?? {};
    if((options.extra['noToken'] as bool?) != true) {
      try {
        final token = await Get.find<AuthService>().activeToken();
        data['token'] = token;
      } catch(e) {
        logger.e('Error al obtener token de siga', error: e);
      }
    }

    options.data = (data as Map<dynamic, dynamic>).entries.map((e) => '${e.key}=${Uri.encodeFull(e.value.toString())}').join('&');

    return handler.next(options);
  }
}