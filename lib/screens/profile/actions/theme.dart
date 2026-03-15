
import "package:adaptive_theme/adaptive_theme.dart";

String getThemeModeText(AdaptiveThemeMode mode) {
  switch (mode) {
    case AdaptiveThemeMode.light:
      return "Claro";
    case AdaptiveThemeMode.dark:
      return "Oscuro";
    case AdaptiveThemeMode.system:
      return "Sistema";
  }
}