import "package:flutter_test/flutter_test.dart";
import "package:miutem/core/utils/horario_data.dart";

void main() {
  group("horario_data", () {
    group("diasHorario", () {
      test("debería contener 7 días", () {
        expect(diasHorario.length, 7);
      });

      test("debería empezar con Lunes", () {
        expect(diasHorario.first, "Lunes");
      });

      test("debería terminar con Domingo", () {
        expect(diasHorario.last, "Domingo");
      });

      test("debería incluir todos los días de la semana", () {
        expect(diasHorario, containsAll(["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"]));
      });
    });

    group("bloquesHorario", () {
      test("debería contener 18 bloques (9 periodos x 2)", () {
        expect(bloquesHorario.length, 18);
      });

      test("debería empezar con 8:00", () {
        expect(bloquesHorario.first, "8:00 - 8:45");
      });

      test("debería terminar con 22:50", () {
        expect(bloquesHorario.last, "22:05 - 22:50");
      });
    });

    group("horasInicio", () {
      test("debería contener 9 horas", () {
        expect(horasInicio.length, 9);
      });

      test("debería empezar con 08:00", () {
        expect(horasInicio.first, "08:00");
      });

      test("debería terminar con 21:20", () {
        expect(horasInicio.last, "21:20");
      });
    });

    group("horasIntermedio", () {
      test("debería contener 9 horas", () {
        expect(horasIntermedio.length, 9);
      });

      test("debería empezar con 08:45", () {
        expect(horasIntermedio.first, "08:45");
      });

      test("debería terminar con 22:05", () {
        expect(horasIntermedio.last, "22:05");
      });
    });

    group("horasTermino", () {
      test("debería contener 9 horas", () {
        expect(horasTermino.length, 9);
      });

      test("debería empezar con 09:30", () {
        expect(horasTermino.first, "09:30");
      });

      test("debería terminar con 22:50", () {
        expect(horasTermino.last, "22:50");
      });
    });

    group("consistencia entre horas", () {
      test("todas las listas de horas deberían tener la misma longitud", () {
        expect(horasInicio.length, horasIntermedio.length);
        expect(horasIntermedio.length, horasTermino.length);
      });
    });
  });
}

