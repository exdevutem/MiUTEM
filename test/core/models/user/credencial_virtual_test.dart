import "package:flutter_test/flutter_test.dart";
import "package:miutem/core/models/user/credencial/credencial_biblioteca.dart";
import "package:miutem/core/models/user/persona/rut.dart";

void main() {
  group("CredencialVirtual", () {
    late CredencialBiblioteca credencial;

    setUp(() {
      credencial = CredencialBiblioteca(
        nombre: "Juan Pérez",
        imagenPerfil: "https://example.com/foto.jpg",
        rut: Rut(21342119),
        area: "Ingeniería en Informática",
        imagenQr: "https://example.com/qr.png",
      );
    });

    group("constructor", () {
      test("debería crear una credencial virtual", () {
        expect(credencial.nombre, "Juan Pérez");
        expect(credencial.imagenPerfil, "https://example.com/foto.jpg");
        expect(credencial.rut.rut, 21342119);
        expect(credencial.area, "Ingeniería en Informática");
        expect(credencial.imagenQr, "https://example.com/qr.png");
      });
    });

    group("getBarcodeContent", () {
      test("debería retornar el rut como string", () {
        expect(credencial.getBarcodeContent(), "21342119");
      });
    });

    group("toJson", () {
      test("debería serializar a JSON correctamente", () {
        final json = credencial.toJson();
        expect(json["nombre"], "Juan Pérez");
        expect(json["imagenPerfil"], "https://example.com/foto.jpg");
        expect(json["rut"], isNotNull);
        expect(json["rut"], "21.342.119-0"); // El dígito verificador se calcula automáticamente
        expect(json["area"], "Ingeniería en Informática");
        expect(json["imagenQr"], "https://example.com/qr.png");
      });
    });

    group("toString", () {
      test("debería retornar JSON string", () {
        final str = credencial.toString();
        expect(str.contains("Juan Pérez"), true);
        expect(str.contains("Ingeniería en Informática"), true);
      });
    });
  });
}

