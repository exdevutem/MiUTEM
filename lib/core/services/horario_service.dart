import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/asignaturas/asignatura.dart';
import 'package:miutem/core/models/exceptions/custom_exception.dart';
import 'package:miutem/core/models/horario.dart';
import 'package:miutem/core/models/user/persona/persona.dart';
import 'package:miutem/core/services/carrera_service.dart';
import 'package:miutem/core/utils/http/functions.dart';

class HorarioService {

  Future<Horario> getHorario({ bool forceRefresh = false }) async {
    try {
      final carrera = await Get.find<CarreraService>().getCarrera();
      final response = await sigaClientRequest('estudiante/horario/',
        method: 'POST',
        contentType: Headers.formUrlEncodedContentType,
        forceRefresh: forceRefresh,
        sigaParams: {
          'carrera_id': carrera.id,
        }
      );

      if(response.data['status_code'] != 200) {
        throw CustomException.fromSiga(response.data);
      }

      // Create a matrix of 6x9
      final List<List<BloqueHorario>> horario = List.generate(18, (it) => List.generate(6, (it) => BloqueHorario()));
      for(final bloque in response.data['response']) {
        final diaIdx = bloque['dia_numero'] - 1;
        final bloqueIdx = bloque['bloque'] - 1;

        final asignatura = Asignatura(
          id: bloque['seccion_id'],
          nombre: bloque['nombre_asignatura'],
          codigo: bloque['codigo_asignatura'],
          tipoHora: bloque['tipo_hora'],
          seccion: bloque['asignatura_seccion'],
          docente: Persona(nombreCompleto: bloque['asignatura_profesor']),
          estado: '',
        );

        horario[bloqueIdx][diaIdx] = BloqueHorario(asignatura: asignatura, sala: bloque['nombre_sala'], codigo: "${bloque['codigo_asignatura']}/${bloque['asignatura_seccion']}");
      }

      return Horario(horario: horario);
    } catch (e) {
      rethrow;
    }
  }
}
