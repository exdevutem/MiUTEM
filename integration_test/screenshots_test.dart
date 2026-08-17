import "dart:io";
import "dart:ui" as ui;

import "package:adaptive_theme/adaptive_theme.dart";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";
import "package:flutter_test/flutter_test.dart";
import "package:integration_test/integration_test.dart";
import "package:miutem/firebase_options_dev.dart" as dev;
import "package:miutem/firebase_options_prod.dart" as prod;
import "package:miutem/main.dart";
import "package:miutem/screens/asignaturas/lista_asignaturas_screen.dart";

/// Credenciales que se escriben en el formulario. En modo capturas
/// (`--dart-define=SCREENSHOT_MODE=true`) la app acepta cualquier par y devuelve
/// siempre el estudiante ficticio de `lib/core/mock/mock_data.dart`.
const String usuario = "ecarrenos";
const String clave = "••••••••";

/// Debe coincidir con el flavor con el que se compila (`--flavor production|development`),
/// porque las opciones de Firebase están atadas al bundle id de cada flavor.
const bool esProduccion = bool.fromEnvironment("SCREENSHOT_PROD", defaultValue: true);

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Las capturas 01 y 02 no salen de la app: son la composición del teléfono en diagonal
  // que arma `scripts/compose-store-screenshots`. Por eso el recorrido parte en la 03,
  // y los nombres llevan el número escrito: el orden del archivo es el orden en la tienda.
  testWidgets("Captura las pantallas de la app para las tiendas", (tester) async {
    paso(binding, "inicio");
    runMainApp(esProduccion ? prod.DefaultFirebaseOptions.currentPlatform : dev.DefaultFirebaseOptions.currentPlatform);

    // En modo capturas la sesión vive en memoria, así que cada corrida parte del login.
    // Si no aparece, la app se compiló sin la bandera y estaría usando datos reales.
    await esperarPor(tester, binding, botonIngresar,
      descripcion: "el login (¿falta --dart-define=SCREENSHOT_MODE=true?)",
    );

    // En Android las capturas se toman del render de Flutter, no de la ventana del
    // sistema, y hay que convertir la superficie una sola vez antes de la primera.
    if (Platform.isAndroid) {
      await binding.convertFlutterSurfaceToImage();
      paso(binding, "superficie convertida a imagen");
    }

    final campos = find.byType(TextField);
    await tester.enterText(campos.at(0), usuario);
    await tester.enterText(campos.at(1), clave);
    await tester.tap(botonIngresar);
    paso(binding, "login enviado");

    final destinos = find.byType(NavigationDestination);
    await esperarPor(tester, binding, destinos, descripcion: "la navegación principal");
    final etiquetas = tester.widgetList<NavigationDestination>(destinos).map((destino) => destino.label).toList();

    // 03 — el inicio, pero en oscuro: es la novedad que se está mostrando.
    await irAPestana(tester, indiceDe(etiquetas, "Inicio"));
    await cambiarTema(tester, binding, AdaptiveThemeMode.dark);
    await capturar(tester, binding, "03_oscuro");
    await cambiarTema(tester, binding, AdaptiveThemeMode.light);

    // 04 — la calculadora de notas, que cuelga de los accesos rápidos de Asignaturas.
    final idxAsignaturas = indiceDe(etiquetas, "Asignaturas");
    await irAPestana(tester, idxAsignaturas);
    await abrirAccesoRapido(tester, binding, "Notas");
    await capturar(tester, binding, "04_calculadora");
    await volver(tester);

    // 05 — el inicio en claro, con la primera clase del día en curso.
    await irAPestana(tester, indiceDe(etiquetas, "Inicio"));
    await capturar(tester, binding, "05_inicio");

    // 06 — la credencial con el código QR.
    await irAPestana(tester, indiceDe(etiquetas, "Credencial"));
    await capturar(tester, binding, "06_credencial");

    // 07 y 08 — horario y malla histórica, también desde los accesos rápidos.
    await irAPestana(tester, idxAsignaturas);
    for (final (acceso, archivo) in [("Horario", "07_horario"), ("Malla Histórica", "08_malla")]) {
      await abrirAccesoRapido(tester, binding, acceso);
      await capturar(tester, binding, archivo);
      await volver(tester);
    }
  }, timeout: const Timeout(Duration(minutes: 15)));
}

/// Deja rastro del avance en `reportData`, que el driver escribe en
/// build/integration_response_data.json incluso cuando el test se cuelga.
void paso(IntegrationTestWidgetsFlutterBinding binding, String texto) {
  binding.reportData ??= <String, dynamic>{};
  final pasos = binding.reportData!["pasos"] ??= <dynamic>[];
  (pasos as List<dynamic>).add(texto);
}

Finder get botonIngresar => find.widgetWithText(FilledButton, "Ingresar");

/// Posición de una pestaña en la barra inferior. Las pestañas dependen de los feature
/// flags y del perfil, así que se falla con nombre propio en vez de capturar otra cosa.
int indiceDe(List<String> etiquetas, String etiqueta) {
  final indice = etiquetas.indexOf(etiqueta);
  if (indice < 0) {
    fail("No está la pestaña \"$etiqueta\". Pestañas disponibles: ${etiquetas.join(", ")}.");
  }

  return indice;
}

Future<void> irAPestana(WidgetTester tester, int indice) async {
  await tester.tap(find.byType(NavigationDestination).at(indice));
  await esperar(tester, const Duration(seconds: 8));
}

/// Cambia el tema sin pasar por Perfil → Pantalla → Tema: el diálogo obliga a hacer
/// scroll y a esperar animaciones, y acá sólo interesa con qué brillo se dibuja la app.
Future<void> cambiarTema(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding, AdaptiveThemeMode modo) async {
  AdaptiveTheme.of(tester.element(find.byType(NavigationBar))).setThemeMode(modo);
  paso(binding, "tema $modo");
  await esperar(tester, const Duration(seconds: 3));
}

/// Abre una pantalla desde las tarjetas de acceso rápido y espera a que cargue.
///
/// La búsqueda se acota a la pantalla de asignaturas porque el `IndexedStack` de
/// la navegación mantiene montado el inicio, que tiene accesos rápidos homónimos.
Future<void> abrirAccesoRapido(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding, String label) async {
  final tarjeta = find.descendant(of: find.byType(AsignaturasScreen), matching: find.text(label));
  if (tarjeta.evaluate().isEmpty) {
    fail("No se encontró el acceso rápido \"$label\" en la pantalla de asignaturas.");
  }

  paso(binding, "abriendo $label");
  await tester.tap(tarjeta.first);
  await esperar(tester, const Duration(seconds: 8));
}

Future<void> volver(WidgetTester tester) async {
  await tester.pageBack();
  await esperar(tester, const Duration(seconds: 3));
}

/// Bombea frames hasta que [finder] encuentre algo, o falla el test al agotar
/// [limite]. El emulador de Android arranca bastante más lento que el simulador
/// de iOS, así que se espera por lo que hay en pantalla y no por un tiempo fijo.
Future<void> esperarPor(
  WidgetTester tester,
  IntegrationTestWidgetsFlutterBinding binding,
  Finder finder, {
  required String descripcion,
  Duration limite = const Duration(seconds: 90),
}) async {
  final fin = DateTime.now().add(limite);
  while (DateTime.now().isBefore(fin)) {
    if (finder.evaluate().isNotEmpty) {
      paso(binding, "apareció $descripcion");
      return;
    }
    await tester.pump(const Duration(milliseconds: 100));
  }

  fail("No apareció $descripcion después de ${limite.inSeconds}s.");
}

/// Bombea frames durante [duracion] en tiempo real.
///
/// No se usa `pumpAndSettle` porque la app tiene animaciones permanentes
/// (video del login, skeletons) que nunca dejan el árbol quieto.
Future<void> esperar(WidgetTester tester, Duration duracion) async {
  final fin = DateTime.now().add(duracion);
  while (DateTime.now().isBefore(fin)) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

/// Quita el foco y espera a que el teclado se retraiga antes de capturar,
/// porque el teclado del sistema no se captura y dejaría una franja en blanco.
Future<void> capturar(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding, String archivo) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await esperar(tester, const Duration(seconds: 2));

  if (Platform.isMacOS) {
    await capturarDesdeFlutter(tester, binding, archivo);
    return;
  }

  // La captura nativa de iOS usa `drawViewHierarchyInRect:afterScreenUpdates:YES`, que espera
  // un frame nuevo. El binding de tests sólo dibuja cuando se le pide, así que hay que seguir
  // bombeando mientras se espera la respuesta del canal o se produce un deadlock.
  var listo = false;
  final captura = binding.takeScreenshot(archivo).whenComplete(() => listo = true);
  while (!listo) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  await captura;
  paso(binding, "capturada $archivo");
}

/// Ancho en píxeles de las capturas de macOS. La Mac App Store sólo acepta 1280x800,
/// 1440x900, 2560x1600 y 2880x1800: la ventana se abre en 1440x900 (MIUTEM_WINDOW_SIZE)
/// y acá se rasteriza al doble, así el resultado calza con 2880x1800 sin recortar nada.
const double anchoCapturaMacOS = 2880;

/// Captura la ventana desde el árbol de Flutter y la deja en `reportData`, que es de donde
/// el driver escribe los archivos (misma llave que usa `binding.takeScreenshot`).
///
/// En macOS el plugin de integration_test sólo responde `allTestsFinished`: no implementa
/// `captureScreenshot`, así que la captura nativa devuelve MissingPluginException. Rasterizar
/// la capa raíz da lo mismo en pantalla y además deja elegir la resolución de salida.
Future<void> capturarDesdeFlutter(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding, String archivo) async {
  final vista = tester.binding.renderViews.first;
  final capa = vista.debugLayer! as OffsetLayer;

  ui.Image? imagen;
  var listo = false;
  // Igual que en iOS: el binding sólo dibuja cuando se le pide, así que se sigue bombeando
  // mientras el rasterizado está en curso. Se espera por `listo` y no por la imagen, para
  // que un error corte el bucle y salga por el `await` de abajo.
  final render = capa
      .toImage(vista.paintBounds, pixelRatio: anchoCapturaMacOS / vista.paintBounds.width)
      .then((resultado) => imagen = resultado)
      .whenComplete(() => listo = true);
  while (!listo) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  await render;

  final bytes = await imagen!.toByteData(format: ui.ImageByteFormat.png);
  imagen!.dispose();

  binding.reportData ??= <String, dynamic>{};
  final capturas = binding.reportData!["screenshots"] ??= <dynamic>[];
  (capturas as List<dynamic>).add(<String, dynamic>{
    "screenshotName": archivo,
    "bytes": bytes!.buffer.asUint8List(),
  });
  paso(binding, "capturada $archivo");
}
