import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/asignaturas/asignatura.dart';
import 'package:miutem/core/models/exceptions/custom_exception.dart';
import 'package:miutem/core/models/user/persona/persona.dart';
import 'package:miutem/core/services/carrera_service.dart';
import 'package:miutem/core/utils/constants.dart';
import 'package:miutem/core/utils/http/functions.dart';

class AsignaturasService {
  
  Future<List<Asignatura>> getAsignaturas({ bool forceRefresh = false}) async {
    try {
      final carrera = await Get.find<CarreraService>().getCarrera();
      final response = await sigaClientRequest('estudiante/asignaturas/',
        method: 'POST',
        sigaParams: {
          'carrera_id': carrera.id,
        },
        forceRefresh: forceRefresh,
        contentType: Headers.formUrlEncodedContentType,
      );

      final data = response.data;
      if(data['status_code'] != 200) {
        throw CustomException.fromSiga(data);
      }

      return (data['response'] as List<dynamic>).map<Asignatura>((e) => Asignatura.fromJson(e)).toList();
    } on DioError catch(e) {
      logger.e('Error al obtener asignaturas', error: e);
      final data = e.response?.data ?? {
        'response': 'Error al obtener asignaturas. Por favor intenta nuevamente.',
        'status_code': 500,
      };

      throw CustomException.fromSiga(data);
    } catch(e) {
      logger.e('Error al obtener asignaturas', error: e);
      rethrow;
    }
  }

  Future<List<PersonaUtem>> getEstudiantes(Asignatura asignatura, { bool forceRefresh = false }) async {
    // try {
    //   final response = await authClientRequest('asignaturas/${asignatura.codigo}',
    //     contentType: Headers.jsonContentType,
    //     forceRefresh: forceRefresh,
    //   );
    //
    //   final data = response.data as Map<String, dynamic>;
    //   if(!data.containsKey('estudiantes')) {
    //     throw CustomException.custom(
    //       message: 'Error al obtener estudiantes de asignatura. Por favor intenta nuevamente.',
    //       statusCode: 500,
    //     );
    //   }
    //
    //   return (data['estudiantes'] as List<dynamic>).map<PersonaUtem>((e) => PersonaUtem.fromJson(e)).toList();
    // } catch (e) {
    //   logger.e('Error al obtener estudiantes de asignatura', error: e);
    //   rethrow;
    // }
    return Future.value([]);
  }
}