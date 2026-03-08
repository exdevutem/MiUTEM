import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miutem/core/models/Task/enums/task_state.dart';
import 'package:miutem/core/models/Task/models/task_model.dart';

void main() {
  group('Task', () {
    late Task task;
    final now = DateTime(2025, 6, 15, 10, 30);

    setUp(() {
      task = Task(
        id: 1,
        category: 'Estudio',
        title: 'Estudiar Cálculo',
        content: 'Repasar capítulo 5',
        color: const Color(0xFF42A5F5),
        state: TaskState.unspecified,
        createdAt: now,
        modifiedAt: now,
      );
    });

    group('constructor', () {
      test('debería crear un task con todos los campos', () {
        expect(task.id, 1);
        expect(task.category, 'Estudio');
        expect(task.title, 'Estudiar Cálculo');
        expect(task.content, 'Repasar capítulo 5');
        expect(task.color, const Color(0xFF42A5F5));
        expect(task.state, TaskState.unspecified);
        expect(task.createdAt, now);
        expect(task.modifiedAt, now);
      });

      test('debería permitir id nulo', () {
        final task = Task(
          id: null,
          category: 'Test',
          title: 'Test',
          content: '',
          color: Colors.red,
          state: TaskState.unspecified,
          createdAt: now,
          modifiedAt: now,
        );
        expect(task.id, isNull);
      });
    });

    group('toJson', () {
      test('debería serializar a JSON correctamente', () {
        final json = task.toJson();
        expect(json['id'], 1);
        expect(json['category'], 'Estudio');
        expect(json['title'], 'Estudiar Cálculo');
        expect(json['content'], 'Repasar capítulo 5');
        expect(json['color'], const Color(0xFF42A5F5).value);
        expect(json['state'], TaskState.unspecified.index);
        expect(json['createdAt'], now.toIso8601String());
        expect(json['modifiedAt'], now.toIso8601String());
      });
    });

    group('fromMap', () {
      test('debería crear Task desde Map', () {
        final map = {
          'id': 2,
          'category': 'Trabajo',
          'title': 'Entregar informe',
          'content': 'Informe final',
          'color': const Color(0xFFEF5350).value,
          'state': TaskState.pinned.index,
          'createdAt': '2025-03-01T12:00:00.000',
          'modifiedAt': '2025-03-02T14:00:00.000',
        };
        final task = Task.fromMap(map);
        expect(task.id, 2);
        expect(task.category, 'Trabajo');
        expect(task.title, 'Entregar informe');
        expect(task.state, TaskState.pinned);
        expect(task.createdAt, DateTime(2025, 3, 1, 12, 0));
      });
    });

    group('toMap', () {
      test('debería convertir a Map correctamente', () {
        final map = task.toMap();
        expect(map['id'], 1);
        expect(map['category'], 'Estudio');
        expect(map['title'], 'Estudiar Cálculo');
      });

      test('toMap y toJson deberían retornar lo mismo', () {
        final json = task.toJson();
        final map = task.toMap();
        expect(json['id'], map['id']);
        expect(json['category'], map['category']);
        expect(json['title'], map['title']);
        expect(json['content'], map['content']);
        expect(json['color'], map['color']);
        expect(json['state'], map['state']);
      });
    });

    group('round-trip', () {
      test('debería mantener datos al serializar y deserializar', () {
        final map = task.toMap();
        final restored = Task.fromMap(map);
        expect(restored.id, task.id);
        expect(restored.category, task.category);
        expect(restored.title, task.title);
        expect(restored.content, task.content);
        expect(restored.state, task.state);
        expect(restored.createdAt, task.createdAt);
        expect(restored.modifiedAt, task.modifiedAt);
      });
    });
  });

  group('TaskState', () {
    test('debería tener 4 estados', () {
      expect(TaskState.values.length, 4);
    });

    test('debería tener los estados esperados', () {
      expect(TaskState.values, contains(TaskState.unspecified));
      expect(TaskState.values, contains(TaskState.pinned));
      expect(TaskState.values, contains(TaskState.archived));
      expect(TaskState.values, contains(TaskState.deleted));
    });

    test('debería tener índices correctos', () {
      expect(TaskState.unspecified.index, 0);
      expect(TaskState.pinned.index, 1);
      expect(TaskState.archived.index, 2);
      expect(TaskState.deleted.index, 3);
    });
  });
}

