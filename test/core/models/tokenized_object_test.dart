import 'package:flutter_test/flutter_test.dart';
import 'package:miutem/core/models/tokenized_object.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class _TestTokenizedObject with TokenizedObject {
  @override
  final String token;

  @override
  final bool ignoreTokenExpiration;

  _TestTokenizedObject({required this.token, this.ignoreTokenExpiration = false});
}

void main() {
  group('TokenizedObject', () {
    group('decodeToken', () {
      test('debería decodificar un JWT válido', () {
        // Crear un JWT válido de prueba
        final jwt = JWT({'sub': '12345', 'name': 'Test User', 'exp': 9999999999});
        final token = jwt.sign(SecretKey('test-secret'));

        final obj = _TestTokenizedObject(token: token);
        final decoded = obj.decodeToken();
        expect(decoded, isNotNull);
        expect(decoded!.payload['sub'], '12345');
        expect(decoded.payload['name'], 'Test User');
      });

      test('debería retornar null para token inválido', () {
        final obj = _TestTokenizedObject(token: 'token-invalido');
        final decoded = obj.decodeToken();
        expect(decoded, isNull);
      });
    });

    group('isTokenExpired', () {
      test('debería retornar false para token no expirado', () {
        final futureExp = (DateTime.now().millisecondsSinceEpoch ~/ 1000) + 3600; // 1 hora en el futuro
        final jwt = JWT({'exp': futureExp});
        final token = jwt.sign(SecretKey('test-secret'));

        final obj = _TestTokenizedObject(token: token);
        expect(obj.isTokenExpired(), false);
      });

      test('debería retornar true para token expirado', () {
        final pastExp = (DateTime.now().millisecondsSinceEpoch ~/ 1000) - 3600; // 1 hora en el pasado
        final jwt = JWT({'exp': pastExp});
        final token = jwt.sign(SecretKey('test-secret'));

        final obj = _TestTokenizedObject(token: token);
        expect(obj.isTokenExpired(), true);
      });

      test('debería retornar true para token sin exp', () {
        final jwt = JWT({'sub': '12345'});
        final token = jwt.sign(SecretKey('test-secret'));

        final obj = _TestTokenizedObject(token: token);
        expect(obj.isTokenExpired(), true);
      });

      test('debería retornar true para token inválido', () {
        final obj = _TestTokenizedObject(token: 'no-es-un-jwt');
        expect(obj.isTokenExpired(), true);
      });
    });
  });
}

