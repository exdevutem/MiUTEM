import "package:flutter_test/flutter_test.dart";
import "package:miutem/core/models/noticia.dart";

void main() {
  group("Noticia", () {
    group("fromJson", () {
      test("debería crear noticia desde JSON", () {
        final noticia = Noticia.fromJson({
          "id": 123,
          "yoast_head_json": {
            "title": "Título de la Noticia",
            "og_image": [
              {"url": "https://example.com/imagen.jpg"}
            ],
          },
        });
        expect(noticia.id, 123);
        expect(noticia.titulo, "Título de la Noticia");
        expect(noticia.imagen, "https://example.com/imagen.jpg");
        expect(noticia.link, "https://noticias.utem.cl/?p=123");
      });
    });

    group("fromJsonList", () {
      test("debería crear lista de noticias desde JSON", () {
        final noticias = Noticia.fromJsonList([
          {
            "id": 1,
            "yoast_head_json": {
              "title": "Noticia 1",
              "og_image": [
                {"url": "https://example.com/img1.jpg"}
              ],
            },
          },
          {
            "id": 2,
            "yoast_head_json": {
              "title": "Noticia 2",
              "og_image": [
                {"url": "https://example.com/img2.jpg"}
              ],
            },
          },
        ]);
        expect(noticias.length, 2);
        expect(noticias[0].titulo, "Noticia 1");
        expect(noticias[1].titulo, "Noticia 2");
      });

      test("debería filtrar noticias sin imagen", () {
        final noticias = Noticia.fromJsonList([
          {
            "id": 1,
            "yoast_head_json": {
              "title": "Con imagen",
              "og_image": [
                {"url": "https://example.com/img.jpg"}
              ],
            },
          },
          {
            "id": 2,
            "yoast_head_json": {
              "title": "Sin imagen",
              "og_image": [],
            },
          },
        ]);
        expect(noticias.length, 1);
        expect(noticias[0].titulo, "Con imagen");
      });

      test("debería filtrar noticias con og_image null", () {
        final noticias = Noticia.fromJsonList([
          {
            "id": 1,
            "yoast_head_json": {
              "title": "Sin og_image",
              "og_image": null,
            },
          },
        ]);
        expect(noticias, isEmpty);
      });
    });

    group("link", () {
      test("debería generar link correcto con el id", () {
        final noticia = Noticia.fromJson({
          "id": 456,
          "yoast_head_json": {
            "title": "Test",
            "og_image": [
              {"url": "https://example.com/img.jpg"}
            ],
          },
        });
        expect(noticia.link, "https://noticias.utem.cl/?p=456");
      });
    });
  });
}

