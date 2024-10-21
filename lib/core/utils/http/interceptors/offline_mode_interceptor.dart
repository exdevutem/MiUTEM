import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/exceptions/custom_exception.dart';
import 'package:miutem/core/models/preferencia.dart';
import 'package:miutem/core/utils/http/functions.dart';
import 'package:miutem/widgets/snackbar.dart';

class OfflineModeInterceptor extends Interceptor {

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    bool offlineMode = (await Preferencia.isOffline.getAsBool(defaultValue: false, guardar: true));
    bool forceRefresh = options.extra.containsKey(DIO_CACHE_KEY_FORCE_REFRESH) && options.extra[DIO_CACHE_KEY_FORCE_REFRESH] == true;
    if(!offlineMode || !forceRefresh) {
      return handler.next(options);
    }

    // Revisa si sigue offline realizando solicitud a la API (solo head)
    offlineMode = await isOffline();
    await Preferencia.isOffline.set(offlineMode ? 'true' : 'false');

    if(!offlineMode) { // Si vuelve la conexión
      return handler.next(options);
    }

    if(forceRefresh) {
      final context = Get.context;
      if(context != null && context.mounted) {
        showErrorSnackbar(context, "No se puede realizar la solicitud en modo Offline. Por favor revisa tu conexión a internet e intenta nuevamente.");
      }
    }

    options.extra[DIO_CACHE_KEY_FORCE_REFRESH] = offlineMode;

    return handler.next(options);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    bool forceRefresh = err.requestOptions.extra.containsKey(DIO_CACHE_KEY_FORCE_REFRESH) && err.requestOptions.extra[DIO_CACHE_KEY_FORCE_REFRESH] == true;
    bool offlineMode = (await Preferencia.isOffline.get(defaultValue: "false", guardar: true)) == "true";
    if(!forceRefresh || !offlineMode) {
      return super.onError(err, handler);
    }

    final error = DioError(requestOptions: err.requestOptions, error: CustomException.fromJson({
      "mensaje": "No se puede realizar la solicitud en modo Offline. Por favor revisa tu conexión a internet e intenta nuevamente.",
      "error": "No se puede realizar la solicitud en modo Offline. Por favor revisa tu conexión a internet e intenta nuevamente.",
      "codigoHttp": 400,
      "codigoInterno": 0.0,
    }), type: DioErrorType.cancel, response: err.response);

    return handler.next(error);
  }
}