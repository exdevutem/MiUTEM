import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/asignaturas/asignatura.dart';
import 'package:miutem/core/models/evaluacion/grades.dart';
import 'package:miutem/core/models/exceptions/custom_exception.dart';
import 'package:miutem/core/services/carrera_service.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/core/utils/http/functions.dart';

class GradesService {

  Future<Grades> getGrades(Asignatura asignatura, { forceRefresh = false }) async {
    try {
      final carrera = await Get.find<CarreraService>().getCarrera();
      final response = await sigaClientRequest('estudiante/asignaturas/notas/',
        method: 'POST',
        sigaParams: {
          'carrera_id': carrera.id,
          'seccion_id': asignatura.id,
        },
        contentType: Headers.formUrlEncodedContentType,
        forceRefresh: forceRefresh,
      );

      if(response.data['status_code'] != 200) {
        throw CustomException.fromSiga(response.data);
      }

      return (response.data['response'] as List<dynamic>).map((it) => Grades.fromJson(it)).toList().first;
    } on DioError catch(e){
      final data = e.response?.data ?? {
        'response': 'Error al obtener notas de asignatura. Intenta más tarde.',
        'status_code': e.response?.statusCode ?? 500,
      };
      logger.e('Error al obtener notas de asignatura ${asignatura.nombre} (${asignatura.id})', error: data);
      throw CustomException.fromSiga(data);
    } catch (e) {
      logger.e('Error al obtener notas de asignatura ${asignatura.nombre} (${asignatura.id})', error: e);
      throw CustomException.custom(message: 'Error al obtener notas de asignatura. Intenta más tarde.');
    }
  }
}