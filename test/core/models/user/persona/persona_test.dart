import 'package:flutter_test/flutter_test.dart';
import 'package:miutem/core/models/user/persona/persona.dart';
import 'package:miutem/core/models/user/persona/rut.dart';

void main() {
  group('Persona', () {
    group('constructor', () {
      test('debería crear una persona con nombre', () {
        final persona = Persona(nombreCompleto: 'Juan Pérez');
        expect(persona.nombreCompleto, 'Juan Pérez');
        expect(persona.rut, isNull);
      });

      test('debería crear una persona con nombre y rut', () {
        final persona = Persona(nombreCompleto: 'Juan Pérez', rut: Rut(12345678));
        expect(persona.nombreCompleto, 'Juan Pérez');
        expect(persona.rut, isNotNull);
        expect(persona.rut!.rut, 12345678);
      });
    });

    group('nombreCompletoCapitalizado', () {
      test('debería capitalizar el nombre completo', () {
        final persona = Persona(nombreCompleto: 'juan pérez');
        expect(persona.nombreCompletoCapitalizado, 'Juan Pérez');
      });

      test('debería capitalizar nombre en mayúsculas', () {
        final persona = Persona(nombreCompleto: 'JUAN PÉREZ');
        expect(persona.nombreCompletoCapitalizado, 'Juan Pérez');
      });

      test('debería hacer trim del nombre', () {
        final persona = Persona(nombreCompleto: '  juan pérez  ');
        expect(persona.nombreCompletoCapitalizado, 'Juan Pérez');
      });
    });

    group('primerNombre', () {
      test('debería retornar el primer nombre capitalizado', () {
        final persona = Persona(nombreCompleto: 'juan antonio pérez');
        expect(persona.primerNombre, 'Juan');
      });

      test('debería retornar nombre completo si solo tiene un nombre', () {
        final persona = Persona(nombreCompleto: 'juan');
        expect(persona.primerNombre, 'Juan');
      });
    });

    group('iniciales', () {
      test('debería retornar las iniciales del nombre', () {
        final persona = Persona(nombreCompleto: 'juan antonio pérez');
        expect(persona.iniciales, 'JAP');
      });

      test('debería retornar una sola inicial para un nombre', () {
        final persona = Persona(nombreCompleto: 'juan');
        expect(persona.iniciales, 'J');
      });

      test('debería retornar iniciales de dos palabras', () {
        final persona = Persona(nombreCompleto: 'juan pérez');
        expect(persona.iniciales, 'JP');
      });
    });

    group('fromJson', () {
      test('debería crear persona desde JSON con rut', () {
        final persona = Persona.fromJson({
          'rut': '12345678-5',
          'nombreCompleto': 'Juan Pérez',
        });
        expect(persona.nombreCompleto, 'Juan Pérez');
        expect(persona.rut, isNotNull);
        expect(persona.rut!.rut, 12345678);
      });

      test('debería crear persona desde JSON sin rut', () {
        final persona = Persona.fromJson({
          'nombreCompleto': 'Juan Pérez',
        });
        expect(persona.nombreCompleto, 'Juan Pérez');
        expect(persona.rut, isNull);
      });
    });

    group('toJson', () {
      test('debería serializar a JSON correctamente', () {
        final persona = Persona(nombreCompleto: 'Juan Pérez', rut: Rut(12345678));
        final json = persona.toJson();
        expect(json['nombreCompleto'], 'Juan Pérez');
        expect(json['rut'], isNotNull);
      });

      test('debería serializar a JSON sin rut', () {
        final persona = Persona(nombreCompleto: 'Juan Pérez');
        final json = persona.toJson();
        expect(json['nombreCompleto'], 'Juan Pérez');
        expect(json['rut'], isNull);
      });
    });

    group('toString', () {
      test('debería retornar formato rut - nombre', () {
        final persona = Persona(nombreCompleto: 'Juan Pérez', rut: Rut(12345678));
        final str = persona.toString();
        expect(str.contains('Juan Pérez'), true);
        expect(str.contains('-'), true);
      });
    });
  });

  group('PersonaUtem', () {
    group('fromJson', () {
      test('debería crear PersonaUtem desde JSON', () {
        final persona = PersonaUtem.fromJson({
          'rut': '12345678-5',
          'nombreCompleto': 'María López',
          'correoUtem': 'maria.lopez@utem.cl',
          'fotoUrl': 'https://example.com/foto.jpg',
        });
        expect(persona.nombreCompleto, 'María López');
        expect(persona.correoUtem, 'maria.lopez@utem.cl');
        expect(persona.fotoUrl, 'https://example.com/foto.jpg');
      });

      test('debería crear PersonaUtem sin foto', () {
        final persona = PersonaUtem.fromJson({
          'nombreCompleto': 'María López',
          'correoUtem': 'maria.lopez@utem.cl',
        });
        expect(persona.fotoUrl, isNull);
      });
    });
  });
}

