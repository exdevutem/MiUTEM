import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:miutem/core/utils/constants.dart';

void main() {
  group('constants', () {
    group('miutemUuidNamespace', () {
      test('debería ser un UUID válido', () {
        expect(miutemUuidNamespace, matches(RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$')));
      });
    });

    group('miUtemHost', () {
      test('debería ser la URL de mi.utem.cl', () {
        expect(miUtemHost, 'https://mi.utem.cl');
      });
    });

    group('genericUserAgent', () {
      test('debería contener Mozilla', () {
        expect(genericUserAgent, contains('Mozilla'));
      });

      test('debería no estar vacío', () {
        expect(genericUserAgent, isNotEmpty);
      });
    });

    group('days', () {
      test('debería tener 7 días', () {
        expect(days.length, 7);
      });

      test('debería empezar con Lunes y terminar con Domingo', () {
        expect(days.first, 'Lunes');
        expect(days.last, 'Domingo');
      });
    });

    group('months', () {
      test('debería tener 12 meses', () {
        expect(months.length, 12);
      });

      test('debería empezar con Enero y terminar con Diciembre', () {
        expect(months.first, 'Enero');
        expect(months.last, 'Diciembre');
      });
    });

    group('notaInputFormatter', () {
      test('debería permitir dígito entre 1 y 7', () {
        final result = notaInputFormatter.formatEditUpdate(
          TextEditingValue.empty,
          const TextEditingValue(text: '5'),
        );
        expect(result.text, '5');
      });

      test('debería rechazar dígito 0', () {
        final result = notaInputFormatter.formatEditUpdate(
          TextEditingValue.empty,
          const TextEditingValue(text: '0'),
        );
        expect(result.text, '');
      });

      test('debería rechazar dígito 8', () {
        final result = notaInputFormatter.formatEditUpdate(
          TextEditingValue.empty,
          const TextEditingValue(text: '8'),
        );
        expect(result.text, '');
      });

      test('debería rechazar dígito 9', () {
        final result = notaInputFormatter.formatEditUpdate(
          TextEditingValue.empty,
          const TextEditingValue(text: '9'),
        );
        expect(result.text, '');
      });

      test('debería permitir segundo dígito válido', () {
        final result = notaInputFormatter.formatEditUpdate(
          const TextEditingValue(text: '5'),
          const TextEditingValue(text: '55'),
        );
        expect(result.text, '55');
      });

      test('debería rechazar segundo dígito > 0 cuando primer dígito es 7', () {
        final result = notaInputFormatter.formatEditUpdate(
          const TextEditingValue(text: '7'),
          const TextEditingValue(text: '71'),
        );
        expect(result.text, '7');
      });

      test('debería permitir 70', () {
        final result = notaInputFormatter.formatEditUpdate(
          const TextEditingValue(text: '7'),
          const TextEditingValue(text: '70'),
        );
        expect(result.text, '70');
      });

      test('debería rechazar más de 3 caracteres', () {
        final result = notaInputFormatter.formatEditUpdate(
          const TextEditingValue(text: '555'),
          const TextEditingValue(text: '5555'),
        );
        expect(result.text, '555');
      });

      test('debería permitir texto vacío', () {
        final result = notaInputFormatter.formatEditUpdate(
          const TextEditingValue(text: '5'),
          TextEditingValue.empty,
        );
        expect(result.text, '');
      });
    });
  });
}

