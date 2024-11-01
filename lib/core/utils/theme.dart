import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miutem/core/utils/style_text.dart';

class AppTheme {

  static Color get white => const Color(0xFFFAFAFA);
  static Color get black => const Color(0xFF333333);

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

  static ColorScheme get colorScheme => ColorScheme.fromSeed(
    seedColor: const Color(0xFF1D8E5C),
    primary: const Color(0xFF1D8E5C),
    secondary: const Color(0xFF06607A),
  );

  static ThemeData getTheme(BuildContext context) => ThemeData.light().copyWith(
    /// Esquema de colores
    colorScheme: colorScheme,
    canvasColor: colorScheme.surface,
    dividerColor: lightGrey,

    /// Tema de texto
    textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme).copyWith(
      headlineMedium: GoogleFonts.inter(textStyle: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.01,
      )),
      titleLarge: GoogleFonts.inter(),
      titleMedium: GoogleFonts.inter(),
      titleSmall: GoogleFonts.inter(),
    ).apply(
      bodyColor: const Color(0xFF333333),
      displayColor: const Color(0xFF333333),
    ),

    /// Fondo de la aplicación
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),

    /// Tema de la barra de navegación
    navigationBarTheme: NavigationBarTheme.of(context).copyWith(
      backgroundColor: const Color(0xFFFFFFFF),
      elevation: 0,
    ),

    /// Tema de la barra superior
    appBarTheme: AppBarTheme.of(context).copyWith(
      backgroundColor: white,
      actionsIconTheme: const IconThemeData(
        color: Color(0xFF333333),
      ),
      titleTextStyle: GoogleFonts.inter(
        color: const Color(0xFF333333),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      toolbarTextStyle: GoogleFonts.roboto(
        color: const Color(0xFF333333),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      foregroundColor: const Color(0xFF333333),
      elevation: 0,
    ),

    /// Tema de la decoración de los inputs
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: lightGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: lightGrey),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: lightGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.primary),
      ),
      fillColor: white,
      hintStyle: StyleText.body.copyWith(
        color: AppTheme.lightGrey,
      ),
      labelStyle: StyleText.body,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    ),
  );

  static ThemeData getThemeDark(BuildContext context) => ThemeData.dark().copyWith(
    /// Esquema de colores
    colorScheme: colorScheme.copyWith(
      primary: const Color(0xFF009951)
    ),
    canvasColor: colorScheme.inverseSurface,
    dividerColor: darkLightGrey,

    /// Tema de texto
    textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme.copyWith(
      headlineMedium: GoogleFonts.inter(textStyle: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w900,
        letterSpacing: 0.01,
      )),
      titleLarge: GoogleFonts.inter(),
      titleMedium: GoogleFonts.inter(),
      titleSmall: GoogleFonts.inter(),
    ).apply(
      bodyColor: const Color(0xFFFAFAFA),
      displayColor: const Color(0xFFFAFAFA),
    )),

    /// Fondo de la aplicación
    scaffoldBackgroundColor: const Color(0xFF1D1B20),

    /// Tema de la barra de navegación
    navigationBarTheme: NavigationBarTheme.of(context).copyWith(
      backgroundColor: const Color(0xFF1E1E1E),
      indicatorColor: const Color(0xFF1D8E5C).withOpacity(.9),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if(states.contains(WidgetState.selected)) {
          return const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          );
        }

        return const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if(states.contains(WidgetState.selected)) {
          return const IconThemeData(
            color: Color(0xFFFAFAFA),
          );
        }

        return const IconThemeData(
          color: Color(0xFFFAFAFA),
        );
      }),
      elevation: 0,
    ),

    /// Tema de la barra superior
    appBarTheme: AppBarTheme.of(context).copyWith(
      backgroundColor: const Color(0xFF1D1B20),
      actionsIconTheme: const IconThemeData(
        color: Color(0xFFFAFAFA),
      ),
      titleTextStyle: GoogleFonts.inter(
        color: const Color(0xFFFAFAFA),
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
      toolbarTextStyle: GoogleFonts.roboto(
        color: const Color(0xFFFAFAFA),
        fontSize: 20,


        fontWeight: FontWeight.w600,
      ),
      foregroundColor: const Color(0xFFFAFAFA),
      elevation: 0,
    ),

    /// Tema de la decoración de los inputs
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: darkLightGrey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: darkLightGrey),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: darkLightGrey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorScheme.primary),
      ),
      fillColor: const Color(0xFF1D1B20),
      hintStyle: StyleText.body.copyWith(color: AppTheme.lightGrey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    ),
  );
}