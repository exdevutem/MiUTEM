import "package:flutter_test/flutter_test.dart";
import "package:miutem/core/models/user/estudiante.dart";
import "package:miutem/core/models/user/perfil.dart";

void main() {
  group("Estudiante", () {
    group("fromJson", () {
      test("debería crear estudiante desde JSON completo", () {
        final estudiante = Estudiante.fromJson({
          "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiZXhwIjo5OTk5OTk5OTk5fQ.Vx5ayYyGSq1LBjBNYJkOYV1EoC1mSOEO5t_Mh8MGSB0",
          "datos_persona": {
            "rut": "12345678",
            "nombre_completo": "Juan Pérez López",
            "correo_personal": "juan@gmail.com",
            "correo_utem": "juan.perez@utem.cl",
            "foto": "https://example.com/foto.jpg",
            "perfiles": ["estudiante"],
          },
        });
        expect(estudiante.token, isNotEmpty);
        expect(estudiante.nombreCompleto, "Juan Pérez López");
        expect(estudiante.correoPersonal, "juan@gmail.com");
        expect(estudiante.correoUtem, "juan.perez@utem.cl");
        expect(estudiante.fotoUrl, "https://example.com/foto.jpg");
        expect(estudiante.rut, isNotNull);
        expect(estudiante.rut!.rut, 12345678);
        expect(estudiante.perfiles, contains(Perfil.estudiante));
      });

      test("debería manejar perfiles vacíos", () {
        final estudiante = Estudiante.fromJson({
          "token": "test-token",
          "datos_persona": {
            "rut": "12345678",
            "nombre_completo": "María López",
            "correo_personal": "maria@gmail.com",
            "correo_utem": "maria.lopez@utem.cl",
            "foto": null,
            "perfiles": [],
          },
        });
        expect(estudiante.perfiles, isEmpty);
      });

      test("debería respetar ignoreTokenExpiration", () {
        final estudiante = Estudiante.fromJson({
          "token": "test-token",
          "ignore_token_expiration": true,
          "datos_persona": {
            "rut": "12345678",
            "nombre_completo": "Test",
            "correo_personal": "test@gmail.com",
            "correo_utem": "test@utem.cl",
            "foto": null,
            "perfiles": [],
          },
        });
        expect(estudiante.ignoreTokenExpiration, true);
      });
    });

    group("toJson", () {
      test("debería serializar a JSON correctamente", () {
        final estudiante = Estudiante.fromJson({
          "token": "test-token",
          "datos_persona": {
            "rut": "12345678",
            "nombre_completo": "Juan Pérez",
            "correo_personal": "juan@gmail.com",
            "correo_utem": "juan@utem.cl",
            "foto": "https://example.com/foto.jpg",
            "perfiles": ["estudiante"],
          },
        });
        final json = estudiante.toJson();
        expect(json["token"], "test-token");
        expect(json["datos_persona"]["nombre_completo"], "Juan Pérez");
        expect(json["datos_persona"]["correo_personal"], "juan@gmail.com");
        expect(json["datos_persona"]["correo_utem"], "juan@utem.cl");
      });
    });

    group("toString", () {
      test("debería retornar JSON string", () {
        final estudiante = Estudiante.fromJson({
          "token": "test-token",
          "datos_persona": {
            "rut": "12345678",
            "nombre_completo": "Juan Pérez",
            "correo_personal": "juan@gmail.com",
            "correo_utem": "juan@utem.cl",
            "foto": null,
            "perfiles": [],
          },
        });
        final str = estudiante.toString();
        expect(str.contains("Juan Pérez"), true);
        expect(str.contains("test-token"), true);
      });
    });

    group("round-trip", () {
      test("debería mantener datos al serializar y deserializar", () {
        final original = Estudiante.fromJson({
          "token": "test-token-round-trip",
          "datos_persona": {
            "rut": "20123456",
            "nombre_completo": "María García",
            "correo_personal": "maria@gmail.com",
            "correo_utem": "maria@utem.cl",
            "foto": "https://example.com/maria.jpg",
            "perfiles": ["estudiante"],
          },
        });

        final json = original.toJson();

        // Reconstruir formato esperado
        final restoredJson = {
          "token": json["token"],
          "datos_persona": {
            "rut": '${json['datos_persona']['rut']}',
            "nombre_completo": json["datos_persona"]["nombre_completo"],
            "correo_personal": json["datos_persona"]["correo_personal"],
            "correo_utem": json["datos_persona"]["correo_utem"],
            "foto": json["datos_persona"]["foto"],
            "perfiles": json["datos_persona"]["perfiles"],
          },
        };
        final restored = Estudiante.fromJson(restoredJson);

        expect(restored.token, original.token);
        expect(restored.nombreCompleto, original.nombreCompleto);
        expect(restored.correoPersonal, original.correoPersonal);
        expect(restored.correoUtem, original.correoUtem);
      });
    });
  });
}

