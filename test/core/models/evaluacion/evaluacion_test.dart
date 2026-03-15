import "dart:convert";
import "package:flutter_test/flutter_test.dart";
import "package:miutem/core/models/evaluacion/evaluacion.dart";

void main() {
  group("REvaluacion", () {
    group("fromJson", () {
      test("debería crear evaluación desde JSON", () {
        final eval = REvaluacion.fromJson({
          "ponderador": 30,
          "descripcion": "Prueba 1",
          "nota": 5.5,
        });
        expect(eval.porcentaje, 30);
        expect(eval.descripcion, "Prueba 1");
        expect(eval.nota, 5.5);
      });

      test("debería manejar valores nulos", () {
        final eval = REvaluacion.fromJson({});
        expect(eval.porcentaje, isNull);
        expect(eval.descripcion, isNull);
        expect(eval.nota, isNull);
      });
    });

    group("fromJsonList", () {
      test("debería crear lista de evaluaciones desde JSON", () {
        final evals = REvaluacion.fromJsonList([
          {"ponderador": 30, "descripcion": "Prueba 1", "nota": 5.5},
          {"ponderador": 70, "descripcion": "Prueba 2", "nota": 6.0},
        ]);
        expect(evals.length, 2);
        expect(evals[0].descripcion, "Prueba 1");
        expect(evals[1].descripcion, "Prueba 2");
      });

      test("debería retornar lista vacía para null", () {
        final evals = REvaluacion.fromJsonList(null);
        expect(evals, isEmpty);
      });
    });

    group("toJson", () {
      test("debería serializar a JSON", () {
        final eval = REvaluacion(
          porcentaje: 30,
          descripcion: "Prueba 1",
          nota: 5.5,
        );
        final json = eval.toJson();
        expect(json["ponderador"], 30);
        expect(json["descripcion"], "Prueba 1");
        expect(json["nota"], 5.5);
      });
    });

    group("toString", () {
      test("debería retornar JSON string", () {
        final eval = REvaluacion(descripcion: "Prueba 1", nota: 5.5, porcentaje: 30);
        final str = eval.toString();
        final decoded = jsonDecode(str);
        expect(decoded["descripcion"], "Prueba 1");
      });
    });
  });

  group("IEvaluacion", () {
    group("fromRemote", () {
      test("debería crear IEvaluacion desde REvaluacion", () {
        final remote = REvaluacion(
          porcentaje: 30,
          descripcion: "Prueba 1",
          nota: 5.5,
        );
        final iEval = IEvaluacion.fromRemote(remote);
        expect(iEval.porcentaje, 30);
        expect(iEval.descripcion, "Prueba 1");
        expect(iEval.nota, 5.5);
        expect(iEval.editable, false);
      });
    });

    group("copyWith", () {
      test("debería copiar con valores nuevos", () {
        final original = IEvaluacion(
          porcentaje: 30,
          descripcion: "Prueba 1",
          nota: 5.5,
          editable: false,
        );
        final copied = original.copyWith(editable: true, nota: 6.0);
        expect(copied.editable, true);
        expect(copied.nota, 6.0);
        expect(copied.descripcion, "Prueba 1");
        expect(copied.porcentaje, 30);
      });

      test("debería mantener valores originales si no se especifican", () {
        final original = IEvaluacion(
          porcentaje: 50,
          descripcion: "Examen",
          nota: 4.0,
          editable: true,
        );
        final copied = original.copyWith();
        expect(copied.porcentaje, 50);
        expect(copied.descripcion, "Examen");
        expect(copied.nota, 4.0);
        expect(copied.editable, true);
      });
    });

    group("toJson", () {
      test("debería incluir campo editable en JSON", () {
        final iEval = IEvaluacion(
          porcentaje: 30,
          descripcion: "Prueba 1",
          nota: 5.5,
          editable: true,
        );
        final json = iEval.toJson();
        expect(json["editable"], true);
        expect(json["ponderador"], 30);
      });
    });
  });
}

