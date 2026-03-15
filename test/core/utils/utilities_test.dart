import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:miutem/core/utils/utilities.dart";

void main() {
  group("let", () {
    test("debería retornar resultado de op cuando el objeto no es nulo", () {
      final result = let<int, int>(5, (n) => n * 2);
      expect(result, 10);
    });

    test("debería retornar null cuando el objeto es nulo", () {
      final result = let<int, int>(null, (n) => n * 2);
      expect(result, isNull);
    });

    test("debería soportar diferentes tipos de entrada y salida", () {
      final result = let<String, DateTime?>("2021-10-10", (fecha) => DateTime.tryParse(fecha));
      expect(result, DateTime(2021, 10, 10));
    });

    test("debería retornar null cuando la función retorna null con objeto nulo", () {
      final result = let<String, DateTime?>(null, (fecha) => DateTime.tryParse(fecha));
      expect(result, isNull);
    });
  });

  group("apply", () {
    test("debería aplicar la función al objeto y retornar resultado", () {
      final result = apply<int, int>(5, (n) => n * 3);
      expect(result, 15);
    });

    test("debería soportar transformación de tipos", () {
      final result = apply<int, String>(42, (n) => "Número: $n");
      expect(result, "Número: 42");
    });
  });

  group("formatoNota", () {
    test("debería retornar null para nota nula", () {
      expect(formatoNota(null), isNull);
    });

    test("debería retornar 2 decimales para nota 3.95", () {
      expect(formatoNota(3.95), "3.95");
    });

    test("debería retornar 1 decimal para nota diferente de 3.95", () {
      expect(formatoNota(5.5), "5.5");
    });

    test("debería retornar 1 decimal para nota entera", () {
      expect(formatoNota(7), "7.0");
    });

    test("debería retornar 1 decimal para nota 1.0", () {
      expect(formatoNota(1.0), "1.0");
    });

    test("debería retornar 1 decimal para nota 4.0", () {
      expect(formatoNota(4.0), "4.0");
    });

    test("debería retornar 1 decimal para nota 6.9", () {
      expect(formatoNota(6.9), "6.9");
    });
  });

  group("RotateList", () {
    test("debería rotar elementos hacia la derecha", () {
      final lista = [1, 2, 3, 4, 5];
      expect(lista.rotate(2), [3, 4, 5, 1, 2]);
    });

    test("debería rotar elementos hacia la izquierda con número negativo", () {
      final lista = [1, 2, 3, 4, 5];
      expect(lista.rotate(-2), [4, 5, 1, 2, 3]);
    });

    test("debería mantener la lista igual al rotar por su longitud", () {
      final lista = [1, 2, 3];
      expect(lista.rotate(3), [1, 2, 3]);
    });

    test("debería rotar un solo elemento", () {
      final lista = [1, 2, 3, 4, 5];
      expect(lista.rotate(1), [2, 3, 4, 5, 1]);
    });
  });

  group("capitalize", () {
    test("debería capitalizar texto simple", () {
      expect(capitalize("hola mundo"), "Hola Mundo");
    });

    test("debería capitalizar texto en mayúsculas", () {
      expect(capitalize("HOLA MUNDO"), "Hola Mundo");
    });

    test("debería manejar texto vacío", () {
      expect(capitalize(""), "");
    });

    test("debería manejar una sola palabra", () {
      expect(capitalize("hola"), "Hola");
    });

    test("debería manejar una sola letra", () {
      expect(capitalize("a"), "A");
    });

    test("debería manejar palabras con un solo carácter", () {
      expect(capitalize("a b c"), "A B C");
    });

    test("debería manejar espacios múltiples", () {
      expect(capitalize("hola  mundo"), "Hola  Mundo");
    });
  });

  group("fromHex", () {
    test("debería convertir hex de 6 dígitos a Color", () {
      final color = fromHex("FF0000");
      expect(color, const Color(0xFFFF0000));
    });

    test("debería convertir hex con # de 7 caracteres a Color", () {
      final color = fromHex("#00FF00");
      expect(color, const Color(0xFF00FF00));
    });

    test("debería convertir hex negro", () {
      final color = fromHex("000000");
      expect(color, const Color(0xFF000000));
    });

    test("debería convertir hex blanco", () {
      final color = fromHex("FFFFFF");
      expect(color, const Color(0xFFFFFFFF));
    });
  });
}

