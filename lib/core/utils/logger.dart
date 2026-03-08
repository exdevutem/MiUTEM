import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(),
  output: _ConsoleOutput(),
);

class _ConsoleOutput extends LogOutput {

  @override
  void output(OutputEvent event) {
    // Only send warning-level and above to Crashlytics to avoid leaking
    // sensitive request/response data (headers, credentials) from debug logs.
    if (event.level.index >= Level.warning.index) {
      FirebaseCrashlytics.instance.log(event.lines.join('\n'));
    }
    event.lines.forEach(print);
  }
}