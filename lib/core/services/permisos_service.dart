// import 'package:dio/dio.dart';
// import 'package:miutem/core/models/exceptions/custom_exception.dart';
// import 'package:miutem/core/models/permiso_ingreso.dart';
// import 'package:miutem/core/utils/constants.dart';
// import 'package:miutem/core/utils/http/functions.dart';
//
// class PermisosService {
//
//   Future<List<PermisoIngreso>> getPermisos({ bool forceRefresh = false }) async {
//     try {
//       final response = await authClientRequest('permisos',
//         method: 'POST',
//         ttl: const Duration(days: 30),
//         forceRefresh: forceRefresh,
//       );
//
//       return PermisoIngreso.fromJsonList(response.data as List<dynamic>?);
//     } on DioError catch(e) {
//       final data = e.response?.data ?? {
//         'response': 'Error al obtener permisos',
//         'status_code': e.response?.statusCode ?? 500,
//       };
//
//       logger.e('Error al obtener permisos', error: e);
//       throw CustomException.fromSiga(data);
//     }
//   }
//
//   Future<PermisoIngreso> getDetallesPermiso(String id, { bool forceRefresh = false }) async {
//     try {
//       final response = await authClientRequest('permisos/$id',
//         method: 'POST',
//         ttl: const Duration(days: 30),
//         forceRefresh: forceRefresh,
//       );
//
//       return PermisoIngreso.fromJson(response.data as Map<String, dynamic>?);
//     } on DioError catch(e) {
//       final data = e.response?.data ?? {
//         'response': 'Error al obtener permisos',
//         'status_code': e.response?.statusCode ?? 500,
//       };
//
//       logger.e('Error al obtener permisos', error: e);
//       throw CustomException.fromSiga(data);
//     } catch (e) {
//       logger.e('Error al obtener permisos', error: e);
//       throw CustomException.custom(message: 'Error al obtener permisos');
//     }
//   }
// }