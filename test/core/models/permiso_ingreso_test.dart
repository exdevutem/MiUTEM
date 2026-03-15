import "package:flutter_test/flutter_test.dart";
import "package:miutem/core/models/permiso_ingreso.dart";

void main() {
  group("PermisoIngreso", () {
    group("constructor", () {
      test("debería crear permiso con valores por defecto nulos", () {
        final permiso = PermisoIngreso();
        expect(permiso.id, isNull);
        expect(permiso.persona, isNull);
        expect(permiso.codigoQr, isNull);
        expect(permiso.perfil, isNull);
        expect(permiso.motivo, isNull);
        expect(permiso.campus, isNull);
        expect(permiso.dependencia, isNull);
        expect(permiso.jornada, isNull);
        expect(permiso.vigencia, isNull);
        expect(permiso.fechaSolicitud, isNull);
      });
    });

    group("fromJson", () {
      test("debería crear permiso desde JSON completo", () {
        final permiso = PermisoIngreso.fromJson({
          "id": "perm-001",
          "codigoQr": "QR123",
          "perfil": "Estudiante",
          "motivo": "Clases",
          "campus": "Macul",
          "dependencia": "Edificio A",
          "jornada": "Diurna",
          "vigencia": "2025-12-31",
          "fechaSolicitud": "2025-01-15T10:30:00",
        });
        expect(permiso.id, "perm-001");
        expect(permiso.codigoQr, "QR123");
        expect(permiso.perfil, "Estudiante");
        expect(permiso.motivo, "Clases");
        expect(permiso.campus, "Macul");
        expect(permiso.dependencia, "Edificio A");
        expect(permiso.jornada, "Diurna");
        expect(permiso.vigencia, "2025-12-31");
        expect(permiso.fechaSolicitud, DateTime(2025, 1, 15, 10, 30));
      });

      test("debería crear permiso vacío para JSON null", () {
        final permiso = PermisoIngreso.fromJson(null);
        expect(permiso.id, isNull);
        expect(permiso.codigoQr, isNull);
      });

      test("debería parsear fecha correctamente", () {
        final permiso = PermisoIngreso.fromJson({
          "id": "1",
          "codigoQr": "",
          "perfil": "",
          "motivo": "",
          "campus": "",
          "dependencia": "",
          "jornada": "",
          "vigencia": "",
          "fechaSolicitud": "2024-06-15T08:00:00",
        });
        expect(permiso.fechaSolicitud?.year, 2024);
        expect(permiso.fechaSolicitud?.month, 6);
        expect(permiso.fechaSolicitud?.day, 15);
      });

      test("debería manejar fecha inválida", () {
        final permiso = PermisoIngreso.fromJson({
          "id": "1",
          "codigoQr": "",
          "perfil": "",
          "motivo": "",
          "campus": "",
          "dependencia": "",
          "jornada": "",
          "vigencia": "",
          "fechaSolicitud": "fecha-invalida",
        });
        expect(permiso.fechaSolicitud, isNull);
      });

      test("debe incluir usuario cuando esta presente", () {
        final permiso = PermisoIngreso.fromJson({
          "id": "1",
          "usuario": {
            "nombreCompleto": "Francisco Solis"
          },
          "codigoQr": "",
          "perfil": "",
          "motivo": "",
          "campus": "",
          "dependencia": "",
          "jornada": "",
          "vigencia": "",
        });
        expect(permiso.persona, isNotNull);
        expect(permiso.persona?.nombreCompleto, "Francisco Solis");
      });
    });

    group("fromJsonList", () {
      test("debería crear lista de permisos", () {
        final permisos = PermisoIngreso.fromJsonList([
          {"id": "1", "campus": "Macul", "fechaSolicitud": "2025-01-01T00:00:00"},
          {"id": "2", "campus": "Providencia", "fechaSolicitud": "2025-01-02T00:00:00"},
        ]);
        expect(permisos.length, 2);
        expect(permisos[0].campus, "Macul");
        expect(permisos[1].campus, "Providencia");
      });

      test("debería retornar lista vacía para null", () {
        final permisos = PermisoIngreso.fromJsonList(null);
        expect(permisos, isEmpty);
      });
    });
  });
}
