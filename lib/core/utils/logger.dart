import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:logger/logger.dart';

final logger = Logger(
  printer: PrettyPrinter(),
  output: _ConsoleOutput(),
);

class _ConsoleOutput extends LogOutput {

  @override
  void output(OutputEvent event) {
    FirebaseCrashlytics.instance.log(event.lines.join('\n'));
    event.lines.forEach(print);
  }
}