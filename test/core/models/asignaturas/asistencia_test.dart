import 'package:flutter_test/flutter_test.dart';
import 'package:miutem/core/models/asignaturas/asistencia.dart';

void main() {
  group('Asistencia', () {
    group('constructor', () {
      test('debería crear asistencia con valores por defecto', () {
        final asistencia = Asistencia();
        expect(asistencia.total, 0);
        expect(asistencia.asistidos, 0);
        expect(asistencia.noAsistidos, 0);
        expect(asistencia.sinRegistro, 0);
      });

      test('debería crear asistencia con valores personalizados', () {
        final asistencia = Asistencia(
          total: 20,
          asistidos: 15,
          noAsistidos: 3,
          sinRegistro: 2,
        );
        expect(asistencia.total, 20);
        expect(asistencia.asistidos, 15);
        expect(asistencia.noAsistidos, 3);
        expect(asistencia.sinRegistro, 2);
      });
    });

    group('fromJson', () {
      test('debería crear asistencia desde JSON', () {
        final asistencia = Asistencia.fromJson({
          'total': 20,
          'asistida': 15,
          'noAsistidos': 3,
          'sinRegistro': 2,
        });
        expect(asistencia.total, 20);
        expect(asistencia.asistidos, 15);
        expect(asistencia.noAsistidos, 3);
        expect(asistencia.sinRegistro, 2);
      });

      test('debería crear asistencia vacía para JSON null', () {
        final asistencia = Asistencia.fromJson(null);
        expect(asistencia.total, 0);
        expect(asistencia.asistidos, 0);
      });

      test('debería manejar campos faltantes con valor por defecto 0', () {
        final asistencia = Asistencia.fromJson({});
        expect(asistencia.total, 0);
        expect(asistencia.asistidos, 0);
        expect(asistencia.noAsistidos, 0);
        expect(asistencia.sinRegistro, 0);
      });
    });

    group('fromJsonList', () {
      test('debería crear lista de asistencias desde JSON', () {
        final asistencias = Asistencia.fromJsonList([
          {'total': 10, 'asistida': 8, 'noAsistidos': 1, 'sinRegistro': 1},
          {'total': 20, 'asistida': 18, 'noAsistidos': 2, 'sinRegistro': 0},
        ]);
        expect(asistencias.length, 2);
        expect(asistencias[0].total, 10);
        expect(asistencias[1].total, 20);
      });

      test('debería retornar lista vacía para null', () {
        final asistencias = Asistencia.fromJsonList(null);
        expect(asistencias, isEmpty);
      });
    });

    group('toJson', () {
      test('debería serializar a JSON correctamente', () {
        final asistencia = Asistencia(
          total: 20,
          asistidos: 15,
          noAsistidos: 3,
          sinRegistro: 2,
        );
        final json = asistencia.toJson();
        expect(json['total'], 20);
        expect(json['asistidos'], 15);
        expect(json['noAsistidos'], 3);
        expect(json['sinRegistro'], 2);
      });
    });
  });
}

