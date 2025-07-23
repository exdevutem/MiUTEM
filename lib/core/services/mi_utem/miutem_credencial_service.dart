import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:html/parser.dart';
import 'package:miutem/core/models/exceptions/custom_exception.dart';
import 'package:miutem/core/models/user/credencial_virtual.dart';
import 'package:miutem/core/models/user/persona/rut.dart';
import 'package:miutem/core/services/mi_utem/miutem_auth_service.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/core/utils/http/http_client.dart';

class MiUTEMCredencialService {

  static MiUTEMCredencialService get get => Get.find<MiUTEMCredencialService>();

  Future<CredencialVirtual> getCredencialURL() async {
    final cookies = await MiUTEMAuthService.get.login();

    final request = await HttpClient.httpClient.get("$miUtemHost/academicos/estudiante_get_credencial",
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
    final datos = htmlDoc.querySelector("div[class=cred_front_informacion_estudiante]");
    if(datos == null) {
      throw CustomException(message: "No se pudo obtener la credencial. Por favor intenta más tarde.", internalCode: 2);
    }

    final nombre = datos.querySelectorAll('p')[0].text;
    final rut = datos.querySelectorAll('p')[1].text;
    final carrera = datos.querySelectorAll('p')[2].text;

    return CredencialVirtual(
      nombre: nombre, 
      profilePictureURL: url, 
      rut: Rut.fromString(rut), 
      carrera: carrera,
    );
  }
}