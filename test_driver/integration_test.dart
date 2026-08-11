import "dart:io";

import "package:integration_test/integration_test_driver_extended.dart";

/// Driver de `flutter drive`: guarda en disco cada captura tomada con
/// `binding.takeScreenshot(<nombre>)` desde integration_test/screenshots_test.dart.
///
/// Se configura con variables de entorno (las define el lane `ios screenshots`):
/// - SCREENSHOTS_DIR: carpeta destino (por defecto fastlane/screenshots/es-MX)
/// - SCREENSHOT_PREFIX: prefijo del archivo, usado para separar por dispositivo
Future<void> main() async {
  final directorio = Platform.environment["SCREENSHOTS_DIR"] ?? "fastlane/screenshots/es-MX";
  final prefijo = Platform.environment["SCREENSHOT_PREFIX"] ?? "";

  await integrationDriver(
    onScreenshot: (String nombre, List<int> bytes, [Map<String, Object?>? args]) async {
      final archivo = File("$directorio/$prefijo$nombre.png");
      await archivo.parent.create(recursive: true);
      await archivo.writeAsBytes(bytes);
      // ignore: avoid_print
      print("📸 ${archivo.path}");
      return true;
    },
  );
}
