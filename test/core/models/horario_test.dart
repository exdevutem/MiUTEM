import 'package:flutter_test/flutter_test.dart';
import 'package:miutem/core/models/horario.dart';

void main() {
  group('Periodo', () {
    group('fromJson', () {
      test('debería crear periodo desde JSON', () {
        final periodo = Periodo.fromJson({
          'numero': '1',
          'horaInicio': '08:00',
          'horaIntermedio': '08:45',
          'horaTermino': '09:30',
        });
        expect(periodo.numero, '1');
        expect(periodo.horaInicio, '08:00');
        expect(periodo.horaIntermedio, '08:45');
        expect(periodo.horaTermino, '09:30');
      });

      test('debería crear periodo vacío para JSON null', () {
        final periodo = Periodo.fromJson(null);
        expect(periodo.numero, isNull);
        expect(periodo.horaInicio, isNull);
      });
    });

    group('fromJsonList', () {
      test('debería crear lista de periodos desde JSON', () {
        final periodos = Periodo.fromJsonList([
          {'numero': '1', 'horaInicio': '08:00', 'horaIntermedio': '08:45', 'horaTermino': '09:30'},
          {'numero': '2', 'horaInicio': '09:40', 'horaIntermedio': '10:25', 'horaTermino': '11:10'},
        ]);
        expect(periodos.length, 2);
        expect(periodos[0].numero, '1');
        expect(periodos[1].numero, '2');
      });

      test('debería retornar lista vacía para null', () {
        final periodos = Periodo.fromJsonList(null);
        expect(periodos, isEmpty);
      });
    });
  });

  group('Horario', () {
    group('constructor', () {
      test('debería crear horario vacío', () {
        final horario = Horario();
        expect(horario.asignaturas, isNull);
        expect(horario.horario, isNull);
      });
    });

    group('fromJson', () {
      test('debería crear horario vacío desde JSON null', () {
        final horario = Horario.fromJson(null);
        expect(horario.asignaturas, isNull);
      });

      test('debería crear horario desde JSON con horario null', () {
        final horario = Horario.fromJson({
          'horario': null,
        });
        expect(horario.horario, isNull);
      });
    });

    group('getters de horas', () {
      test('debería retornar 9 horas de inicio', () {
        final horario = Horario();
        expect(horario.horasInicio.length, 9);
        expect(horario.horasInicio.first, '08:00');
        expect(horario.horasInicio.last, '21:20');
      });

      test('debería retornar 9 horas intermedias', () {
        final horario = Horario();
        expect(horario.horasIntermedio.length, 9);
        expect(horario.horasIntermedio.first, '08:45');
        expect(horario.horasIntermedio.last, '22:05');
      });

      test('debería retornar 9 horas de término', () {
        final horario = Horario();
        expect(horario.horasTermino.length, 9);
        expect(horario.horasTermino.first, '09:30');
        expect(horario.horasTermino.last, '22:50');
      });
    });

    group('diasHorario', () {
      test('debería retornar 6 días', () {
        final horario = Horario();
        expect(horario.diasHorario.length, 6);
        expect(horario.diasHorario.first, 'Lunes');
        expect(horario.diasHorario.last, 'Sábado');
      });
    });

    group('horarioEnlazado', () {
      test('debería retornar lista vacía si horario es null', () {
        final horario = Horario();
        expect(horario.horarioEnlazado, isEmpty);
      });

      test('debería retornar copia del horario', () {
        final horario = Horario(horario: [
          [BloqueHorario(), BloqueHorario()],
          [BloqueHorario(), BloqueHorario()],
        ]);
        final enlazado = horario.horarioEnlazado;
        expect(enlazado.length, 2);
        expect(enlazado[0].length, 2);
      });
    });
  });

  group('BloqueHorario', () {
    group('constructor', () {
      test('debería crear bloque vacío', () {
        final bloque = BloqueHorario();
        expect(bloque.asignatura, isNull);
        expect(bloque.sala, isNull);
        expect(bloque.codigo, isNull);
      });
    });

    group('fromJson', () {
      test('debería crear bloque vacío para JSON null', () {
        final bloque = BloqueHorario.fromJson(null);
        expect(bloque.asignatura, isNull);
        expect(bloque.sala, isNull);
        expect(bloque.codigo, isNull);
      });
    });

    group('fromJsonMatrix', () {
      test('debería retornar null para input null', () {
        final matrix = BloqueHorario.fromJsonMatrix(null);
        expect(matrix, isNull);
      });

      test('debería crear matriz vacía para lista vacía', () {
        final matrix = BloqueHorario.fromJsonMatrix([]);
        expect(matrix, isEmpty);
      });
    });

    group('toJson', () {
      test('debería serializar bloque vacío', () {
        final bloque = BloqueHorario();
        final json = bloque.toJson();
        expect(json['asignatura'], isNull);
        expect(json['sala'], isNull);
        expect(json['codigo'], isNull);
      });
    });
  });
}

