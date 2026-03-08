import 'package:flutter_test/flutter_test.dart';
import 'package:miutem/core/models/asignaturas/asignatura.dart';
import 'package:miutem/core/models/user/persona/persona.dart';
import 'package:miutem/core/models/user/persona/rut.dart';

void main() {
  group('Asignatura', () {
    group('fromJson', () {
      test('debería crear asignatura desde JSON con docente nombre y rut', () {
        final asignatura = Asignatura.fromJson({
          'seccion_id': 'ABC123',
          'codigo_asignatura': 'INF-100',
          'nombre_asignatura': 'programación',
          'tipo_hora': 'cátedra',
          'profesor': '12345678 - juan pérez',
          'seccion': '1',
          'tipo_asignatura': 'obligatoria',
          'sala': 'a-301',
          'horario': 'LU-MA 08:00-09:30',
          'intentos': '1',
        });
        expect(asignatura.id, 'ABC123');
        expect(asignatura.codigo, 'INF-100');
        expect(asignatura.nombre, 'Programación');
        expect(asignatura.tipoHora, 'Cátedra');
        expect(asignatura.seccion, '1');
        expect(asignatura.docente.nombreCompleto, isNotEmpty);
        expect(asignatura.tipoAsignatura, 'Obligatoria');
        expect(asignatura.sala, 'A-301');
      });

      test('debería crear asignatura con docente sin rut', () {
        final asignatura = Asignatura.fromJson({
          'seccion_id': 'ABC123',
          'codigo_asignatura': 'INF-100',
          'nombre_asignatura': 'test',
          'tipo_hora': 'lab',
          'profesor': 'juan pérez',
          'seccion': '1',
        });
        expect(asignatura.docente.nombreCompleto, 'Juan Pérez');
        expect(asignatura.docente.rut, isNull);
      });

      test('debería asignar "Sin Docente" cuando profesor es null', () {
        final asignatura = Asignatura.fromJson({
          'seccion_id': 'ABC123',
          'codigo_asignatura': 'INF-100',
          'nombre_asignatura': 'test',
          'tipo_hora': 'lab',
          'seccion': '1',
        });
        expect(asignatura.docente.nombreCompleto, 'Sin Docente');
      });

      test('debería asignar "Sin Docente" cuando profesor es vacío', () {
        final asignatura = Asignatura.fromJson({
          'seccion_id': 'ABC123',
          'codigo_asignatura': 'INF-100',
          'nombre_asignatura': 'test',
          'tipo_hora': 'lab',
          'profesor': '',
          'seccion': '1',
        });
        expect(asignatura.docente.nombreCompleto, 'Sin Docente');
      });

      test('debería manejar intentos como entero', () {
        final asignatura = Asignatura.fromJson({
          'seccion_id': 'ABC123',
          'codigo_asignatura': 'INF-100',
          'nombre_asignatura': 'test',
          'tipo_hora': 'lab',
          'seccion': '1',
          'intentos': '3',
        });
        expect(asignatura.intentos, 3);
      });

      test('debería usar 1 como valor por defecto de intentos cuando es inválido', () {
        final asignatura = Asignatura.fromJson({
          'seccion_id': 'ABC123',
          'codigo_asignatura': 'INF-100',
          'nombre_asignatura': 'test',
          'tipo_hora': 'lab',
          'seccion': '1',
        });
        expect(asignatura.intentos, 1);
      });
    });

    group('fromJsonList', () {
      test('debería crear lista de asignaturas', () {
        final asignaturas = Asignatura.fromJsonList([
          {
            'seccion_id': '1',
            'codigo_asignatura': 'INF-100',
            'nombre_asignatura': 'prog',
            'tipo_hora': 'cat',
            'seccion': '1',
          },
          {
            'seccion_id': '2',
            'codigo_asignatura': 'INF-200',
            'nombre_asignatura': 'bd',
            'tipo_hora': 'lab',
            'seccion': '2',
          },
        ]);
        expect(asignaturas.length, 2);
      });

      test('debería retornar lista vacía para null', () {
        final asignaturas = Asignatura.fromJsonList(null);
        expect(asignaturas, isEmpty);
      });
    });

    group('uniqueId', () {
      test('debería generar id único combinando campos', () {
        final asignatura = Asignatura(
          id: '1',
          nombre: 'Prog',
          codigo: 'INF-100',
          tipoHora: 'Cátedra',
          estado: 'Inscrito',
          seccion: '1',
          docente: Persona(nombreCompleto: 'Juan'),
          sala: 'A-301',
        );
        expect(asignatura.uniqueId.contains('INF-100'), true);
        expect(asignatura.uniqueId.contains('A-301'), true);
        expect(asignatura.uniqueId.contains('1'), true);
      });
    });

    group('colorPorEstado', () {
      test('debería retornar verde para Aprobado', () {
        final asignatura = Asignatura(
          id: '1', nombre: 'Test', codigo: 'T', tipoHora: 'C',
          estado: 'Aprobado', seccion: '1',
          docente: Persona(nombreCompleto: 'Doc'),
        );
        expect(asignatura.colorPorEstado.green, greaterThan(200));
      });

      test('debería retornar rojo para Reprobado', () {
        final asignatura = Asignatura(
          id: '1', nombre: 'Test', codigo: 'T', tipoHora: 'C',
          estado: 'Reprobado', seccion: '1',
          docente: Persona(nombreCompleto: 'Doc'),
        );
        expect(asignatura.colorPorEstado.red, greaterThan(200));
      });

      test('debería retornar azul para otros estados', () {
        final asignatura = Asignatura(
          id: '1', nombre: 'Test', codigo: 'T', tipoHora: 'C',
          estado: 'Inscrito', seccion: '1',
          docente: Persona(nombreCompleto: 'Doc'),
        );
        expect(asignatura.colorPorEstado.blue, greaterThan(200));
      });
    });

    group('copyWith', () {
      test('debería copiar con valores nuevos', () {
        final original = Asignatura(
          id: '1', nombre: 'Prog', codigo: 'INF-100', tipoHora: 'Cátedra',
          estado: 'Inscrito', seccion: '1',
          docente: Persona(nombreCompleto: 'Juan'),
        );
        final copied = original.copyWith(nombre: 'Nuevo Nombre', estado: 'Aprobado');
        expect(copied.nombre, 'Nuevo Nombre');
        expect(copied.estado, 'Aprobado');
        expect(copied.codigo, 'INF-100');
        expect(copied.id, '1');
      });

      test('debería mantener valores originales si no se especifican', () {
        final original = Asignatura(
          id: '1', nombre: 'Prog', codigo: 'INF-100', tipoHora: 'Cátedra',
          estado: 'Inscrito', seccion: '1',
          docente: Persona(nombreCompleto: 'Juan'),
        );
        final copied = original.copyWith();
        expect(copied.nombre, original.nombre);
        expect(copied.codigo, original.codigo);
      });
    });

    group('toJson', () {
      test('debería serializar a JSON correctamente', () {
        final asignatura = Asignatura(
          id: '1', nombre: 'Prog', codigo: 'INF-100', tipoHora: 'Cátedra',
          estado: 'Inscrito', seccion: '1',
          docente: Persona(nombreCompleto: 'Juan'),
        );
        final json = asignatura.toJson();
        expect(json['id'], '1');
        expect(json['nombre'], 'Prog');
        expect(json['codigo'], 'INF-100');
        expect(json['seccion'], '1');
      });
    });
  });
}

