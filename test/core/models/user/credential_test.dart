import 'package:flutter_test/flutter_test.dart';
import 'package:miutem/core/models/user/credential.dart';

void main() {
  group('Credentials', () {
    group('constructor', () {
      test('debería crear credenciales con username y password', () {
        const cred = Credentials(username: 'user@utem.cl', password: 'pass123');
        expect(cred.username, 'user@utem.cl');
        expect(cred.password, 'pass123');
      });
    });

    group('toJson', () {
      test('debería serializar a JSON', () {
        const cred = Credentials(username: 'user@utem.cl', password: 'pass123');
        final json = cred.toJson();
        expect(json['username'], 'user@utem.cl');
        expect(json['password'], 'pass123');
      });
    });

    group('fromJson', () {
      test('debería crear desde JSON', () {
        final cred = Credentials.fromJson({
          'username': 'user@utem.cl',
          'password': 'pass123',
        });
        expect(cred.username, 'user@utem.cl');
        expect(cred.password, 'pass123');
      });
    });

    group('toFormUrlEncoded', () {
      test('debería codificar en formato URL', () {
        const cred = Credentials(username: 'user@utem.cl', password: 'pass 123');
        final encoded = cred.toFormUrlEncoded();
        expect(encoded, 'username=user%40utem.cl&password=pass%20123');
      });

      test('debería codificar caracteres especiales', () {
        const cred = Credentials(username: 'test+user@utem.cl', password: 'p@ss&word=1');
        final encoded = cred.toFormUrlEncoded();
        expect(encoded.contains('username='), true);
        expect(encoded.contains('&password='), true);
      });
    });

    group('toString', () {
      test('debería retornar JSON string', () {
        const cred = Credentials(username: 'user@utem.cl', password: 'pass123');
        final str = cred.toString();
        expect(str.contains('user@utem.cl'), true);
        expect(str.contains('pass123'), true);
      });
    });

    group('round-trip', () {
      test('debería mantener datos al serializar y deserializar', () {
        const original = Credentials(username: 'user@utem.cl', password: 'pass123');
        final json = original.toJson();
        final restored = Credentials.fromJson(json);
        expect(restored.username, original.username);
        expect(restored.password, original.password);
      });
    });
  });
}

