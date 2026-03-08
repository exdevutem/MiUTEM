import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:miutem/core/models/evaluacion/evaluacion.dart';
import 'package:miutem/core/models/evaluacion/grades.dart';

void main() {
  group('Grades', () {
    group('fromJson', () {
      test('debería crear Grades desde JSON completo', () {
        final grades = Grades.fromJson({
          'notas_parciales': [
            {'ponderador': 30, 'descripcion': 'P1', 'nota': 5.5},
            {'ponderador': 70, 'descripcion': 'P2', 'nota': 6.0},
          ],
          'nota_final_asignatura': 5.8,
          'nota_seccion_asignatura': 5.7,
          'nota_examen': 6.0,
        });
        expect(grades.notasParciales.length, 2);
        expect(grades.notaFinal, 5.8);
        expect(grades.notaPresentacion, 5.7);
        expect(grades.notaExamen, 6.0);
      });

      test('debería manejar notas parciales nulas', () {
        final grades = Grades.fromJson({
          'notas_parciales': null,
          'nota_final_asignatura': null,
          'nota_seccion_asignatura': null,
          'nota_examen': null,
        });
        expect(grades.notasParciales, isEmpty);
        expect(grades.notaFinal, isNull);
        expect(grades.notaPresentacion, isNull);
        expect(grades.notaExamen, isNull);
      });

      test('debería manejar JSON con campos parcialmente presentes', () {
        final grades = Grades.fromJson({
          'notas_parciales': [
            {'ponderador': 100, 'descripcion': 'Única', 'nota': 4.0},
          ],
        });
        expect(grades.notasParciales.length, 1);
        expect(grades.notaFinal, isNull);
      });
    });

    group('toJson', () {
      test('debería serializar a JSON correctamente', () {
        final grades = Grades(
          notasParciales: [
            REvaluacion(porcentaje: 50, descripcion: 'P1', nota: 5.0),
          ],
          notaFinal: 5.0,
          notaPresentacion: 5.0,
          notaExamen: null,
        );
        final json = grades.toJson();
        expect(json['notas_parciales'], isA<List>());
        expect((json['notas_parciales'] as List).length, 1);
        expect(json['nota_final_asignatura'], 5.0);
        expect(json['nota_seccion_asignatura'], 5.0);
        expect(json['nota_examen'], isNull);
      });
    });

    group('toString', () {
      test('debería retornar JSON string', () {
        final grades = Grades(notaFinal: 5.5);
        final str = grades.toString();
        final decoded = jsonDecode(str);
        expect(decoded['nota_final_asignatura'], 5.5);
      });
    });

    group('round-trip', () {
      test('debería mantener datos al serializar y deserializar', () {
        final original = Grades(
          notasParciales: [
            REvaluacion(porcentaje: 30, descripcion: 'Prueba 1', nota: 5.5),
            REvaluacion(porcentaje: 70, descripcion: 'Prueba 2', nota: 6.0),
          ],
          notaFinal: 5.8,
          notaPresentacion: 5.7,
          notaExamen: 6.0,
        );
        final json = original.toJson();
        final restored = Grades.fromJson(json);
        expect(restored.notasParciales.length, original.notasParciales.length);
        expect(restored.notaFinal, original.notaFinal);
        expect(restored.notaPresentacion, original.notaPresentacion);
        expect(restored.notaExamen, original.notaExamen);
      });
    });
  });
}

