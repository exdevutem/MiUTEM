import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:miutem/core/models/pair.dart';

void main() {
  group('Pair', () {
    group('constructor', () {
      test('debería crear un par con dos valores', () {
        final pair = Pair(1, 'hello');
        expect(pair.a, 1);
        expect(pair.b, 'hello');
      });

      test('debería soportar diferentes tipos', () {
        final pair = Pair<double, bool>(3.14, true);
        expect(pair.a, 3.14);
        expect(pair.b, true);
      });
    });

    group('toJson', () {
      test('debería serializar a JSON', () {
        final pair = Pair(1, 'hello');
        final json = pair.toJson();
        expect(json['a'], 1);
        expect(json['b'], 'hello');
      });
    });

    group('toString', () {
      test('debería retornar JSON string', () {
        final pair = Pair(1, 'hello');
        final str = pair.toString();
        final decoded = jsonDecode(str);
        expect(decoded['a'], 1);
        expect(decoded['b'], 'hello');
      });
    });
  });
}

