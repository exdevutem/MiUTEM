import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/exceptions/custom_exception.dart';
import 'package:miutem/core/repositories/secure_storage_repository.dart';
import 'package:miutem/core/utils/http/http_client.dart';
import 'package:miutem/core/utils/utils.dart';

class MiUTEMAuthService {

  static MiUTEMAuthService get get => Get.find<MiUTEMAuthService>();

  final SecureStorageRepository _secureStorageRepository = Get.find<SecureStorageRepository>();

  /// Obtiene las cookies de la sesión de Mi.UTEM.
  Future<String?> login() async {
    final credentials = await _secureStorageRepository.getCredentials();
    if(credentials == null) {
      throw CustomException.custom(message: "No se encontraron credenciales. Por favor intenta más tarde.");
    }

    if(await isLoggedIn()) {
      return await _secureStorageRepository.getMiUTEMCookies();
    }

    List<String>? cookies = (await HttpClient.httpClient.get("$miUtemHost/pasaporte/")).headers['set-cookie'];
    if(cookies?.isNotEmpty != true) {
      throw CustomException(message: "No se pudo encontrar el token necesario. Por favor intenta más tarde.");
    }
    final csrfToken = cookies?.firstWhereOrNull((it) => it.startsWith("csrftoken"))?.split(";").firstWhereOrNull((it) => it.startsWith("csrftoken"))?.split("=").lastOrNull;

    final result = await HttpClient.httpClient.post("$miUtemHost/pasaporte/",
      data: "csrfmiddlewaretoken=$csrfToken&txt_usuario=${Uri.encodeComponent(credentials.username)}&txt_password=${Uri.encodeComponent(credentials.password)}",
      options: Options(
        headers: {
          'Cookie': cookies?.map((it) => it.split(";").firstOrNull).where((it) => it != null).join(";"),
          'Content-Type': 'application/x-www-form-urlencoded',
          'User-Agent': genericUserAgent,
        },
        validateStatus: (status) => status == 302
      )
    );

    if(result.statusCode != 302) {
      throw CustomException.custom(message: "No logramos autenticarte. Por favor intenta más tarde.");
    }

    final cookiesHeader = result.headers['set-cookie']?.map((it) => it.split(";").firstOrNull).where((it) => it != null).join(";");
    await _secureStorageRepository.setMiUTEMCookies(cookiesHeader);

    return cookiesHeader;
  }

  /// Revisa si el usuario está logueado en Mi.UTEM.
  Future<bool> isLoggedIn() async {
    final credentials = await _secureStorageRepository.getCredentials();
    if(credentials == null) {
      throw CustomException.custom(message: "No se encontraron credenciales. Por favor intenta más tarde.");
    }

    final cookies = await _secureStorageRepository.getMiUTEMCookies();
    if(cookies == null) {
      return false;
    }

    final result = await HttpClient.httpClient.get("$miUtemHost/academicos/mi-perfil-estudiante",
      options: Options(
        headers: {
          'Cookie': cookies,
          'User-Agent': genericUserAgent
        }
      )
    );

    return "${result.data}".contains(credentials.username);
  }

}