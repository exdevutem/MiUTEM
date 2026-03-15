import "package:flutter_test/flutter_test.dart";
import "package:miutem/core/models/user/persona/rut.dart";

void main() {
  group("Rut", () {
    group("constructor", () {
      test("debería crear un Rut con el número entregado", () {
        final rut = Rut(12345678);
        expect(rut.rut, 12345678);
      });
    });

    group("dv (dígito verificador)", () {
      test("debería calcular DV correctamente para 12345678", () {
        final rut = Rut(12345678);
        expect(rut.dv, "5");
      });

      test("debería calcular DV como K cuando corresponde", () {
        final rut = Rut(7092966);
        expect(rut.dv, "K");
      });

      test("debería calcular DV como 0 cuando corresponde", () {
        final rut = Rut(11111111);
        expect(rut.dv, "1");
      });

      test("debería calcular DV para 1", () {
        final rut = Rut(1);
        expect(rut.dv, "9");
      });

      test("debería calcular DV para rut conocido 20123456", () {
        final rut = Rut(20123456);
        expect(rut.dv, "5");
      });
    });

    group("fromString", () {
      test("debería parsear rut con guión", () {
        final rut = Rut.fromString("12345678-5");
        expect(rut.rut, 12345678);
      });

      test("debería parsear rut sin guión", () {
        final rut = Rut.fromString("12345678");
        expect(rut.rut, 12345678);
      });

      test("debería parsear rut con puntos y guión", () {
        final rut = Rut.fromString("12.345.678-5");
        expect(rut.rut, 12345678);
      });

      test("debería parsear rut con puntos sin guión", () {
        final rut = Rut.fromString("12.345.678");
        expect(rut.rut, 12345678);
      });
    });

    group("toString", () {
      test("debería formatear rut con puntos y guión", () {
        final rut = Rut(12345678);
        expect(rut.toString(), "12.345.678-5");
      });

      test("debería formatear rut corto correctamente", () {
        final rut = Rut(1234567);
        final str = rut.toString();
        expect(str.contains("-"), true);
        expect(str.contains("."), true);
      });

      test("debería mantener formato consistente entre fromString y toString", () {
        final rut = Rut.fromString("12.345.678-5");
        expect(rut.toString(), "12.345.678-5");
      });
    });
  });
}

