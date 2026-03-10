import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:miutem/core/models/exceptions/custom_exception.dart';
import 'package:miutem/core/models/user/credencial/credencial_biblioteca.dart';
import 'package:miutem/core/models/user/perfil.dart';
import 'package:miutem/core/models/user/persona/rut.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/core/services/mi_utem/miutem_auth_service.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/core/utils/http/http_client.dart';

class MiUTEMCredencialService {

  Future<CredencialBiblioteca> getCredencialBiblioteca() async {
    final usuario = await Get.find<AuthService>().login();
    final cookies = await Get.find<MiUTEMAuthService>().login();

    final credentialRequestUri = switch (usuario.perfiles.first) {
      Perfil.estudiante => '$miUtemHost/academicos/estudiante_get_credencial',
      Perfil.profesor => '$miUtemHost/personal/funcionario_get_credencial',
      _ => throw CustomException(message: "El perfil del usuario no es compatible con esta función.", internalCode: 3),
    };

    final request = await HttpClient.httpClient.get(credentialRequestUri,
        options: Options(
            headers: {
              'Cookie': cookies,
              'User-Agent': genericUserAgent,
              'Referrer': "$miUtemHost/",
              'X-Requested-With': 'XMLHttpRequest',
            }
        )
    );

    final htmlDoc = parse(request.data);
    final style = htmlDoc.querySelector('div[class=cred_front_foto_perfil]')?.attributes['style'];
    if(style == null) {
      throw CustomException(message: "No se pudo obtener la credencial. Por favor intenta más tarde.", internalCode: 1);
    }

    final url = (style.replaceFirst("background:  #fff url('", "").replaceFirst("') center center/cover no-repeat;", ""));
    final datosPath = switch (usuario.perfiles.first) {
      Perfil.estudiante => "div[class=cred_front_informacion_estudiante]",
      Perfil.profesor => "div[class=cred_front_informacion_funcionario]",
      _ => throw CustomException(message: "El perfil del usuario no es compatible con esta función.", internalCode: 3),
    };
    final datos = htmlDoc.querySelector(datosPath);
    if(datos == null) {
      throw CustomException(message: "No se pudo obtener la credencial. Por favor intenta más tarde.", internalCode: 2);
    }

    final imagenQr = (htmlDoc.querySelector('div[class=imagen_qr]'))?.querySelectorAll('img')[0].attributes['src'] ?? "";
    if (imagenQr.isEmpty) {
      throw CustomException(message: "No se pudo obtener la credencial. Por favor intenta más tarde.", internalCode: 4);
    }

    final nombre = datos.querySelectorAll('p')[0].text;
    final rut = datos.querySelectorAll('p')[1].text;
    final area = datos.querySelectorAll('p')[2].text;

    return CredencialBiblioteca(
      nombre: nombre,
      imagenPerfil: url,
      rut: Rut.fromString(rut),
      area: area,
      imagenQr: imagenQr,
    );
  }
}