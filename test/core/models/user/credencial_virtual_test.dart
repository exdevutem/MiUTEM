import 'package:flutter_test/flutter_test.dart';
import 'package:miutem/core/models/user/credencial_virtual.dart';
import 'package:miutem/core/models/user/persona/rut.dart';

void main() {
  group('CredencialVirtual', () {
    late CredencialVirtual credencial;

    setUp(() {
      credencial = CredencialVirtual(
        nombre: 'Juan Pérez',
        profilePictureURL: 'https://example.com/foto.jpg',
        rut: Rut(12345678),
        carrera: 'Ingeniería en Informática',
      );
    });

    group('constructor', () {
      test('debería crear una credencial virtual', () {
        expect(credencial.nombre, 'Juan Pérez');
        expect(credencial.profilePictureURL, 'https://example.com/foto.jpg');
        expect(credencial.rut.rut, 12345678);
        expect(credencial.carrera, 'Ingeniería en Informática');
      });
    });

    group('getBarcodeContent', () {
      test('debería retornar el rut como string', () {
        expect(credencial.getBarcodeContent(), '12345678');
      });
    });

    group('toJson', () {
      test('debería serializar a JSON correctamente', () {
        final json = credencial.toJson();
        expect(json['nombre'], 'Juan Pérez');
        expect(json['profilePictureURL'], 'https://example.com/foto.jpg');
        expect(json['rut'], isNotNull);
        expect(json['carrera'], 'Ingeniería en Informática');
      });
    });

    group('toString', () {
      test('debería retornar JSON string', () {
        final str = credencial.toString();
        expect(str.contains('Juan Pérez'), true);
        expect(str.contains('Ingeniería en Informática'), true);
      });
    });
  });
}

