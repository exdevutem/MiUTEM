import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:integration_test/integration_test.dart";
import "package:miutem/firebase_options_dev.dart" as dev;
import "package:miutem/firebase_options_prod.dart" as prod;
import "package:miutem/main.dart";

/// Credenciales de Pasaporte.UTEM para la cuenta de demostración.
/// Se inyectan con `--dart-define` desde el lane `ios screenshots`.
/// Sin ellas sólo se captura la pantalla de login.
const String usuario = String.fromEnvironment("SCREENSHOT_USER");
const String clave = String.fromEnvironment("SCREENSHOT_PASSWORD");

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

    // El simulador conserva la sesión entre corridas. Se cierra para que el recorrido
    // siempre parta del login y el resultado sea idéntico en cada ejecución.
    if (botonIngresar.evaluate().isEmpty) {
      await cerrarSesion(tester, binding);
    }

    // El video de fondo y el logo tardan en aparecer.
    await esperar(tester, const Duration(seconds: 8));
    paso(binding, "capturando login");
    await capturar(tester, binding, "01_login");
    paso(binding, "login capturado");

    // ponytail: sin cuenta de demo no hay sesión, y sin sesión no hay más pantallas que capturar.
    if (usuario.isEmpty || clave.isEmpty) {
      return;
    }

    final campos = find.byType(TextField);
    await tester.enterText(campos.at(0), usuario);
    await tester.enterText(campos.at(1), clave);
    await tester.tap(botonIngresar);
    // Login contra SIGA + carga inicial del home.
    await esperar(tester, const Duration(seconds: 30));
    paso(binding, "login enviado");

    final destinos = find.byType(NavigationDestination);
    if (destinos.evaluate().isEmpty) {
      fail("No se llegó a la navegación principal: revisa SCREENSHOT_USER/SCREENSHOT_PASSWORD o la conexión a SIGA.");
    }

    // Las pestañas visibles dependen de los feature flags y del perfil, así que se recorren las que existan.
    final etiquetas = tester.widgetList<NavigationDestination>(destinos).map((destino) => destino.label).toList();
    for (var i = 0; i < etiquetas.length; i++) {
      await tester.tap(find.byType(NavigationDestination).at(i));
      await esperar(tester, const Duration(seconds: 10));
      await capturar(tester, binding, "${(i + 2).toString().padLeft(2, "0")}_${etiquetas[i].toLowerCase()}");
      paso(binding, "capturada ${etiquetas[i]}");
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

/// Cierra la sesión desde la pestaña de perfil para volver al login.
Future<void> cerrarSesion(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding) async {
  final perfil = find.descendant(of: find.byType(NavigationBar), matching: find.text("Perfil"));
  if (perfil.evaluate().isEmpty) {
    fail("La app no mostró ni el login ni la pestaña de perfil: no se pudo llegar a un estado conocido.");
  }

  paso(binding, "abriendo perfil");
  await tester.tap(perfil);
  await esperar(tester, const Duration(seconds: 5));
  paso(binding, "tocando cerrar sesión");
  await tester.tap(find.widgetWithText(ElevatedButton, "Cerrar Sesión"));
  await esperar(tester, const Duration(seconds: 5));
  paso(binding, "sesión cerrada, login visible: ${botonIngresar.evaluate().isNotEmpty}");
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
Future<void> capturar(WidgetTester tester, IntegrationTestWidgetsFlutterBinding binding, String nombre) async {
  FocusManager.instance.primaryFocus?.unfocus();
  await esperar(tester, const Duration(seconds: 2));

  // La captura nativa de iOS usa `drawViewHierarchyInRect:afterScreenUpdates:YES`, que espera
  // un frame nuevo. El binding de tests sólo dibuja cuando se le pide, así que hay que seguir
  // bombeando mientras se espera la respuesta del canal o se produce un deadlock.
  var listo = false;
  final captura = binding.takeScreenshot(nombre).whenComplete(() => listo = true);
  while (!listo) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  await captura;
}
