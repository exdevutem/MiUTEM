import "package:flutter/material.dart";
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

  testWidgets("Captura las pantallas de la app para la App Store", (tester) async {
    paso(binding, "inicio");
    runMainApp(esProduccion ? prod.DefaultFirebaseOptions.currentPlatform : dev.DefaultFirebaseOptions.currentPlatform);
    // Arranque: Firebase, RemoteConfig y la resolución de sesión.
    await esperar(tester, const Duration(seconds: 15));
    paso(binding, "arrancó, login visible: ${botonIngresar.evaluate().isNotEmpty}");

    // En modo capturas la sesión vive en memoria, así que cada corrida parte del login.
    // Si no aparece, la app se compiló sin la bandera y estaría usando datos reales.
    if (botonIngresar.evaluate().isEmpty) {
      fail("No se llegó al login: revisa que se compile con --dart-define=SCREENSHOT_MODE=true.");
    }

    // El video de fondo y el logo tardan en aparecer.
    await esperar(tester, const Duration(seconds: 8));
    await capturar(tester, binding, "login");

    final campos = find.byType(TextField);
    await tester.enterText(campos.at(0), usuario);
    await tester.enterText(campos.at(1), clave);
    await tester.tap(botonIngresar);
    await esperar(tester, const Duration(seconds: 10));
    paso(binding, "login enviado");

    final destinos = find.byType(NavigationDestination);
    if (destinos.evaluate().isEmpty) {
      fail("No se llegó a la navegación principal después del login.");
    }

    // Las pestañas visibles dependen de los feature flags y del perfil, así que se recorren las que existan.
    final etiquetas = tester.widgetList<NavigationDestination>(destinos).map((destino) => destino.label).toList();
    for (var i = 0; i < etiquetas.length; i++) {
      await irAPestana(tester, i);
      await capturar(tester, binding, etiquetas[i].toLowerCase());
    }

    // Horario y malla histórica cuelgan de los accesos rápidos de Asignaturas.
    final idxAsignaturas = etiquetas.indexOf("Asignaturas");
    if (idxAsignaturas < 0) {
      paso(binding, "sin pestaña de asignaturas: se omiten horario y malla");
      return;
    }

    await irAPestana(tester, idxAsignaturas);
    for (final acceso in ["Horario", "Malla Histórica"]) {
      await abrirAccesoRapido(tester, binding, acceso);
      await capturar(tester, binding, acceso.split(" ").first.toLowerCase());
      await tester.pageBack();
      await esperar(tester, const Duration(seconds: 3));
    }
  }, timeout: const Timeout(Duration(minutes: 6)));
}

/// Deja rastro del avance en `reportData`, que el driver escribe en
/// build/integration_response_data.json incluso cuando el test se cuelga.
void paso(IntegrationTestWidgetsFlutterBinding binding, String texto) {
  binding.reportData ??= <String, dynamic>{};
  final pasos = binding.reportData!["pasos"] ??= <dynamic>[];
  (pasos as List<dynamic>).add(texto);
}

Finder get botonIngresar => find.widgetWithText(FilledButton, "Ingresar");

Future<void> irAPestana(WidgetTester tester, int indice) async {
  await tester.tap(find.byType(NavigationDestination).at(indice));
  await esperar(tester, const Duration(seconds: 8));
}

/// Abre una pantalla desde las tarjetas de acceso rápido y espera a que cargue.
///
/// La búsqueda se acota a la pantalla de asignaturas porque el `IndexedStack` de
/// la navegación mantiene montado el inicio, que tiene un acceso rápido homónimo.
Future<void> abrirAccesoRapido(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding, String label) async {
  final tarjeta = find.descendant(of: find.byType(AsignaturasScreen), matching: find.text(label));
  if (tarjeta.evaluate().isEmpty) {
    fail("No se encontró el acceso rápido \"$label\" en la pantalla de asignaturas.");
  }

  paso(binding, "abriendo $label");
  await tester.tap(tarjeta.first);
  await esperar(tester, const Duration(seconds: 8));
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

/// Número correlativo de la captura, para que el orden en App Store Connect
/// sea el mismo del recorrido.
var _capturas = 0;

/// Quita el foco y espera a que el teclado se retraiga antes de capturar,
/// porque el teclado del sistema no se captura y dejaría una franja en blanco.
Future<void> capturar(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding, String nombre) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await esperar(tester, const Duration(seconds: 2));

  final archivo = "${(++_capturas).toString().padLeft(2, "0")}_$nombre";

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
