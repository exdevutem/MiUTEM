import 'package:flutter_test/flutter_test.dart';
import 'package:miutem/core/models/user/perfil.dart';

void main() {
  group('Perfil', () {
    test('debería tener el valor estudiante', () {
      expect(Perfil.values, contains(Perfil.estudiante));
    });

    test('debería tener solo 1 valor', () {
      expect(Perfil.values.length, 1);
    });

    test('debería tener nombre "estudiante"', () {
      expect(Perfil.estudiante.name, 'estudiante');
    });
  });
}

