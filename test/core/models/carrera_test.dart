import 'package:flutter_test/flutter_test.dart';
import 'package:miutem/core/models/carrera.dart';

void main() {
  group('Carrera', () {
    group('constructor', () {
      test('debería crear una carrera', () {
        const carrera = Carrera(
          id: '1',
          nombre: 'Ingeniería en Informática',
          estado: 'Regular',
          codigo: '21030',
        );
        expect(carrera.id, '1');
        expect(carrera.nombre, 'Ingeniería en Informática');
        expect(carrera.estado, 'Regular');
        expect(carrera.codigo, '21030');
      });
    });

    group('fromJson', () {
      test('debería crear carrera desde JSON', () {
        final carrera = Carrera.fromJson({
          'carrera_id': '1',
          'nombre_carrera': 'ingeniería en informática',
          'situacion_academica': 'regular ',
          'codigo_carrera': 21030,
        });
        expect(carrera.id, '1');
        expect(carrera.nombre, 'Ingeniería En Informática');
        expect(carrera.estado, 'Regular');
        expect(carrera.codigo, '21030');
      });

      test('debería capitalizar el nombre de la carrera', () {
        final carrera = Carrera.fromJson({
          'carrera_id': '2',
          'nombre_carrera': 'INGENIERÍA CIVIL',
          'situacion_academica': 'REGULAR',
          'codigo_carrera': 21040,
        });
        expect(carrera.nombre, 'Ingeniería Civil');
      });

      test('debería hacer trim del estado', () {
        final carrera = Carrera.fromJson({
          'carrera_id': '3',
          'nombre_carrera': 'test',
          'situacion_academica': '  egresado  ',
          'codigo_carrera': 21050,
        });
        expect(carrera.estado, 'Egresado');
      });
    });

    group('fromJsonList', () {
      test('debería crear lista de carreras desde JSON', () {
        final carreras = Carrera.fromJsonList([
          {
            'carrera_id': '1',
            'nombre_carrera': 'informática',
            'situacion_academica': 'regular',
            'codigo_carrera': 21030,
          },
          {
            'carrera_id': '2',
            'nombre_carrera': 'civil',
            'situacion_academica': 'egresado',
            'codigo_carrera': 21040,
          },
        ]);
        expect(carreras.length, 2);
        expect(carreras[0].nombre, 'Informática');
        expect(carreras[1].nombre, 'Civil');
      });

      test('debería retornar lista vacía para JSON null', () {
        final carreras = Carrera.fromJsonList(null);
        expect(carreras, isEmpty);
      });
    });

    group('toJson', () {
      test('debería serializar a JSON correctamente', () {
        const carrera = Carrera(
          id: '1',
          nombre: 'Ingeniería',
          estado: 'Regular',
          codigo: '21030',
        );
        final json = carrera.toJson();
        expect(json['id'], '1');
        expect(json['nombre'], 'Ingeniería');
        expect(json['estado'], 'Regular');
        expect(json['codigo'], '21030');
      });
    });

    group('toString', () {
      test('debería retornar JSON string', () {
        const carrera = Carrera(
          id: '1',
          nombre: 'Ingeniería',
          estado: 'Regular',
          codigo: '21030',
        );
        final str = carrera.toString();
        expect(str.contains('Ingeniería'), true);
        expect(str.contains('21030'), true);
      });
    });
  });
}

