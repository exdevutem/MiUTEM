import 'package:get/get.dart';
import 'package:html/parser.dart' show parse;
import 'package:miutem/core/models/asignaturas/asignatura_malla.dart';
import 'package:miutem/core/models/exceptions/custom_exception.dart';
import 'package:miutem/core/services/mi_utem/miutem_auth_service.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/core/utils/http/functions.dart';
import 'package:miutem/core/utils/utils.dart';

class MiUTEMMallaService {
  static MiUTEMMallaService get get => Get.find<MiUTEMMallaService>();

  /// Obtiene la malla, usando caché si está disponible y no ha expirado.
  /// [forceRefresh] fuerza una actualización desde el servidor.
  Future<List<AsignaturaMalla>> getMalla({bool forceRefresh = false}) async {
    final cookie = await MiUTEMAuthService.get.login();
    final response = await httpClientRequest("$miUtemHost/academicos/mi-malla",
      forceRefresh: forceRefresh,
      headers: {
        'Cookie': cookie ?? '',
        'User-Agent': genericUserAgent,
      },
    );

    final html = "${response.data}";
    if (!html.contains("La información proporcionada en el módulo debe ser validada por la Dirección General de Docencia.")) {
      throw CustomException(message: "No se pudo obtener la malla. Por favor intenta más tarde.", internalCode: 1);
    }

    final htmlDoc = parse(html).documentElement;
    if (htmlDoc == null) {
      throw CustomException(message: "No se pudo obtener la malla. Por favor intenta más tarde.", internalCode: 2);
    }

    return (htmlDoc.querySelectorAll("#avance-malla").first.querySelectorAll("#table-avance").first).querySelectorAll("tbody > tr").map((it) {
      final parts = it.children;
      var nota = parts[5].text.trim();
      if (nota.isEmpty) {
        nota = "-";
      }

      return AsignaturaMalla(
        nivel: int.tryParse(parts[0].text.trim()) ?? 0,
        nombre: parts[1].text.trim(),
        tipo: parts[2].text.trim(),
        intentos: int.tryParse(parts[3].text.trim()) ?? 0,
        estado: parts[4].text.trim(),
        nota: nota,
      );
    }).toList();
  }
}
