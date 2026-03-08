import 'package:flutter_test/flutter_test.dart';
import 'package:miutem/core/models/exceptions/custom_exception.dart';

void main() {
  group('CustomException', () {
    group('constructor', () {
      test('debería crear excepción con mensaje por defecto', () {
        final ex = CustomException();
        expect(ex.message, contains('error inesperado'));
        expect(ex.error, isNull);
        expect(ex.statusCode, isNull);
        expect(ex.internalCode, isNull);
      });

      test('debería crear excepción con mensaje personalizado', () {
        final ex = CustomException(message: 'Error personalizado');
        expect(ex.message, 'Error personalizado');
      });

      test('debería crear excepción con todos los campos', () {
        final ex = CustomException(
          message: 'Error',
          error: 'NOT_FOUND',
          statusCode: 404,
          internalCode: 1.1,
        );
        expect(ex.message, 'Error');
        expect(ex.error, 'NOT_FOUND');
        expect(ex.statusCode, 404);
        expect(ex.internalCode, 1.1);
      });
    });

    group('unknown', () {
      test('debería crear excepción desconocida', () {
        final ex = CustomException.unknown();
        expect(ex.message, contains('error inesperado'));
      });
    });

    group('custom', () {
      test('debería crear excepción custom con mensaje', () {
        final ex = CustomException.custom(message: 'Algo salió mal');
        expect(ex.message, contains('Algo salió mal'));
      });

      test('debería crear excepción custom sin mensaje', () {
        final ex = CustomException.custom();
        expect(ex.message, contains('intenta más tarde'));
      });

      test('debería crear excepción custom con statusCode', () {
        final ex = CustomException.custom(statusCode: 500);
        expect(ex.statusCode, 500);
      });
    });

    group('fromJson', () {
      test('debería crear excepción desde JSON', () {
        final ex = CustomException.fromJson({
          'mensaje': 'Error del servidor',
          'error': 'SERVER_ERROR',
          'codigoHttp': 500,
          'codigoInterno': 2.5,
        });
        expect(ex.message, 'Error del servidor');
        expect(ex.error, 'SERVER_ERROR');
        expect(ex.statusCode, 500);
        expect(ex.internalCode, 2.5);
      });

      test('debería manejar codigoInterno como num', () {
        final ex = CustomException.fromJson({
          'mensaje': 'Error',
          'codigoHttp': 400,
          'codigoInterno': 3,
        });
        expect(ex.internalCode, 3.0);
      });

      test('debería manejar campos nulos en JSON', () {
        final ex = CustomException.fromJson({
          'mensaje': 'Error',
          'error': null,
          'codigoHttp': null,
          'codigoInterno': null,
        });
        expect(ex.message, 'Error');
        expect(ex.error, isNull);
        expect(ex.statusCode, isNull);
        expect(ex.internalCode, isNull);
      });
    });

    group('fromSiga', () {
      test('debería crear excepción desde respuesta Siga con response', () {
        final ex = CustomException.fromSiga({
          'response': 'Token expirado',
          'status_code': 401,
        });
        expect(ex.message, contains('Token expirado'));
        expect(ex.statusCode, 401);
      });

      test('debería crear excepción desde respuesta Siga con message', () {
        final ex = CustomException.fromSiga({
          'message': 'No autorizado',
          'status_code': 403,
        });
        expect(ex.message, contains('No autorizado'));
        expect(ex.statusCode, 403);
      });
    });

    group('toJson', () {
      test('debería serializar a JSON correctamente', () {
        final ex = CustomException(
          message: 'Error',
          error: 'NOT_FOUND',
          statusCode: 404,
          internalCode: 1.0,
        );
        final json = ex.toJson();
        expect(json['mensaje'], 'Error');
        expect(json['error'], 'NOT_FOUND');
        expect(json['codigoHttp'], 404);
        expect(json['codigoInterno'], 1.0);
      });
    });

    group('toString', () {
      test('debería retornar JSON string', () {
        final ex = CustomException(message: 'Error de prueba');
        final str = ex.toString();
        expect(str.contains('Error de prueba'), true);
      });
    });

    group('implements Exception', () {
      test('debería ser una Exception', () {
        final ex = CustomException();
        expect(ex, isA<Exception>());
      });
    });
  });
}

