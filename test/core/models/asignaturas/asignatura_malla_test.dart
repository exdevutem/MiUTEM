import "dart:convert";
import "package:flutter_test/flutter_test.dart";
import "package:miutem/core/models/asignaturas/asignatura_malla.dart";

void main() {
  group("AsignaturaMalla", () {
    group("fromJson", () {
      test("debería crear asignatura de malla desde JSON", () {
        final asignatura = AsignaturaMalla.fromJson({
          "nivel": 3,
          "intentos": 1,
          "nombre": "Cálculo I",
          "tipo": "Obligatoria",
          "estado": "Aprobado",
          "nota": "5.5",
        });
        expect(asignatura.nivel, 3);
        expect(asignatura.intentos, 1);
        expect(asignatura.nombre, "Cálculo I");
        expect(asignatura.tipo, "Obligatoria");
        expect(asignatura.estado, "Aprobado");
        expect(asignatura.nota, "5.5");
      });
    });

    group("fromJsonList", () {
      test("debería crear lista desde JSON", () {
        final asignaturas = AsignaturaMalla.fromJsonList([
          {
            "nivel": 1,
            "intentos": 1,
            "nombre": "Introducción",
            "tipo": "Obligatoria",
            "estado": "Aprobado",
            "nota": "6.0",
          },
          {
            "nivel": 2,
            "intentos": 2,
            "nombre": "Programación",
            "tipo": "Obligatoria",
            "estado": "Inscrito",
            "nota": "",
          },
        ]);
        expect(asignaturas.length, 2);
        expect(asignaturas[0].nombre, "Introducción");
        expect(asignaturas[1].intentos, 2);
      });

      test("debería retornar lista vacía para null", () {
        final asignaturas = AsignaturaMalla.fromJsonList(null);
        expect(asignaturas, isEmpty);
      });
    });

    group("toJson", () {
      test("debería serializar a JSON", () {
        final asignatura = AsignaturaMalla(
          nivel: 3,
          intentos: 1,
          nombre: "Cálculo I",
          tipo: "Obligatoria",
          estado: "Aprobado",
          nota: "5.5",
        );
        final json = asignatura.toJson();
        expect(json["nivel"], 3);
        expect(json["intentos"], 1);
        expect(json["nombre"], "Cálculo I");
        expect(json["tipo"], "Obligatoria");
        expect(json["estado"], "Aprobado");
        expect(json["nota"], "5.5");
      });
    });

    group("toString", () {
      test("debería retornar JSON string", () {
        final asignatura = AsignaturaMalla(
          nivel: 1,
          intentos: 1,
          nombre: "Test",
          tipo: "Obligatoria",
          estado: "Aprobado",
          nota: "5.0",
        );
        final str = asignatura.toString();
        final decoded = jsonDecode(str);
        expect(decoded["nombre"], "Test");
      });
    });

    group("round-trip", () {
      test("debería mantener datos al serializar y deserializar", () {
        final original = AsignaturaMalla(
          nivel: 5,
          intentos: 2,
          nombre: "Base de Datos",
          tipo: "Electivo",
          estado: "Inscrito",
          nota: "4.5",
        );
        final json = original.toJson();
        final restored = AsignaturaMalla.fromJson(json);
        expect(restored.nivel, original.nivel);
        expect(restored.intentos, original.intentos);
        expect(restored.nombre, original.nombre);
        expect(restored.tipo, original.tipo);
        expect(restored.estado, original.estado);
        expect(restored.nota, original.nota);
      });
    });
  });
}

