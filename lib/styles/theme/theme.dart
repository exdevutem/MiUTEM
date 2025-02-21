import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  static Color get primary => const Color(0xFF1D8E5C);
  static Color get primaryDark => const Color(0xFF009951);
  static Color get secondary => const Color(0xFF06607A);

  static Color get white => const Color(0xFFFAFAFA);
  static Color get black => const Color(0xFF333333);

  static Color get scaffoldBackgroundColor => white;
  static Color get scaffoldBackgroundColorDark => const Color(0xFF1D1B20);

  static Color get lightGrey => const Color(0xFFBBBBBB);
  static Color get darkLightGrey => const Color(0xFF474747);

  static Color get lightBlueCard => const Color(0xFFB8E8FC);
  static Color get darkBlueCard => const Color(0xFF005C82);

  static Color get lightPurpleCard => const Color(0xFFDFCCFB);
  static Color get darkPurpleCard => const Color(0xFF692083);

  static Color get lightYellowCard => const Color(0xFFFCF7BB);
  static Color get darkYellowCard => const Color(0xFF6D660A);

  static Color get lightSalmonCard => const Color(0xFFFFBDBD);
  static Color get darkSalmonCard => const Color(0xFF8C3A3A);

  static Color get lightGreenCard => const Color(0xFFB3E6CC);
  static Color get darkGreenCard => const Color(0xFF0A693C);

  /// themes horario
  static const Color mediumGrey = Color(0xFFBDBDBD);
  static const Color greyLight = Color(0xfff1f1f1);
  static const Color grey = Color(0xff7f7f7f);
  static const Color dividerColor = mediumGrey;

  static ColorScheme get colorScheme => ColorScheme.fromSeed(
    seedColor: primary,

    primary: primary,
    onPrimary: white,

    secondary: secondary,
    onSecondary: white,

    surface: white,
    onSurface: black,

    onSurfaceVariant: lightGrey,
  );

  static ColorScheme get darkColorScheme => ColorScheme.fromSeed(
    seedColor: primaryDark,

    primary: primaryDark,
    onPrimary: white,

    secondary: secondary,
    onSecondary: white,

    surface: black,
    onSurface: white,

    onSurfaceVariant: lightGrey,
  );

  /// Obtiene el tema para modo claro
  static ThemeData getTheme(BuildContext context) => ThemeData.light().copyWith(
    /// Esquema de colores
    colorScheme: colorScheme,
    canvasColor: colorScheme.surface,
    dividerColor: lightGrey,

    /// Tema de texto
    textTheme: textTheme(context).apply(
      bodyColor: black,
      displayColor: black,
    ),

    /// Fondo de la aplicación
    scaffoldBackgroundColor: scaffoldBackgroundColor,

    /// Tema de las tarjetas
    cardTheme: CardTheme(
      color: scaffoldBackgroundColor,
    ),

    /// Tema de la barra de navegación
    navigationBarTheme: navigationBarTheme(context).copyWith(
      backgroundColor: Colors.white,
      iconTheme: WidgetStateProperty.all(IconThemeData(color: black)),
    ),

    /// Tema de la barra superior
    appBarTheme: AppBarTheme.of(context).copyWith(
      backgroundColor: white,
      systemOverlayStyle: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: white,
        statusBarIconBrightness: Brightness.dark,
      ),
      actionsIconTheme: IconThemeData(
        color: black,
      ),
      titleTextStyle: GoogleFonts.inter(
        color: black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      toolbarTextStyle: GoogleFonts.roboto(
        color: black,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      foregroundColor: black,
      elevation: 0,
    ),

    /// Tema de la decoración de los inputs
    inputDecorationTheme: inputDecorationTheme(context).copyWith(fillColor: white),
  );

  /// Obtiene el tema para modo oscuro
  static ThemeData getThemeDark(BuildContext context) => ThemeData.dark().copyWith(
    /// Esquema de colores
    colorScheme: darkColorScheme,
    canvasColor: colorScheme.inverseSurface,
    dividerColor: darkLightGrey,

    /// Tema de texto
    textTheme: textTheme(context).apply(
      bodyColor: white,
      displayColor: white,
    ),

    /// Fondo de la aplicación
    scaffoldBackgroundColor: scaffoldBackgroundColorDark,

    /// Tema de las tarjetas
    cardTheme: CardTheme(
      color: scaffoldBackgroundColorDark,
    ),

    /// Tema de la barra de navegación
    navigationBarTheme: navigationBarTheme(context).copyWith(
      indicatorColor: primary.withOpacity(.9),
      backgroundColor: black.withOpacity(.1),
      iconTheme: WidgetStateProperty.all(IconThemeData(color: white)),
    ),

    /// Tema de la barra superior
    appBarTheme: AppBarTheme.of(context).copyWith(
      backgroundColor: scaffoldBackgroundColorDark,
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
      ),
      actionsIconTheme: IconThemeData(
        color: white,
      ),
      titleTextStyle: GoogleFonts.inter(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      toolbarTextStyle: GoogleFonts.roboto(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      foregroundColor: white,
      elevation: 0,
    ),

    /// Tema de la decoración de los inputs
    inputDecorationTheme: inputDecorationTheme(context).copyWith(fillColor: scaffoldBackgroundColorDark),
  );

  /// Obtiene el tema de los textos, incluyendo fuentes de Google Fonts.
  static TextTheme textTheme(BuildContext context) => GoogleFonts.robotoTextTheme(Theme.of(context).textTheme).copyWith(
    headlineMedium: GoogleFonts.inter(textStyle: const TextStyle( // Headline
      fontSize: 30,
      letterSpacing: 0,
      height: 1.2
    )),
    headlineSmall: GoogleFonts.inter(textStyle: const TextStyle( // Header
      fontSize: 18,
      height: 1.5
    )),
    titleLarge: GoogleFonts.inter(),
    titleMedium: GoogleFonts.inter(),
    titleSmall: GoogleFonts.inter(),
    labelMedium: GoogleFonts.inter(textStyle: const TextStyle( // Label
      fontSize: 16,
      height: 1.2
    )),

    bodySmall: GoogleFonts.roboto(textStyle: const TextStyle( // Caption
      fontSize: 12,
    )),

    bodyMedium: GoogleFonts.roboto(textStyle: const TextStyle( // Body
      fontSize: 14,
    )),

    bodyLarge: GoogleFonts.roboto(textStyle: const TextStyle( // Description
      fontSize: 16,
      height: 1.2
    )),
  );

  /// Obtiene el tema de la decoración de los inputs.
  static InputDecorationTheme inputDecorationTheme(BuildContext context) => InputDecorationTheme(
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Theme.of(context).dividerColor),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Theme.of(context).dividerColor),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Theme.of(context).dividerColor),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
    ),
    hintStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: lightGrey),
    labelStyle: Theme.of(context).textTheme.bodyMedium,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
  );

  /// Obtiene el tema de la barra de navegación.
  static NavigationBarThemeData navigationBarTheme(BuildContext context) => NavigationBarTheme.of(context).copyWith(
    labelTextStyle: WidgetStateProperty.all(const TextStyle()),
    elevation: 0,
  );
}