import "package:flutter_test/flutter_test.dart";
import "package:miutem/core/models/user/perfil.dart";

void main() {
  group("Perfil", () {
    test("debería tener el valor estudiante", () {
      expect(Perfil.values, contains(Perfil.estudiante));
    });

    test("debería tener el valor profesor", () {
      expect(Perfil.values, contains(Perfil.profesor));
    });

    test("debería tener el valor funcionario", () {
      expect(Perfil.values, contains(Perfil.funcionario));
    });

    test("debería tener solo 3 valores", () {
      expect(Perfil.values.length, 3);
    });

    test('debería tener nombre "estudiante"', () {
      expect(Perfil.estudiante.name, "estudiante");
    });

    test('debería tener nombre "profesor"', () {
      expect(Perfil.profesor.name, "profesor");
    });

    test('debería tener nombre "funcionario"', () {
      expect(Perfil.funcionario.name, "funcionario");
    });
  });
}

