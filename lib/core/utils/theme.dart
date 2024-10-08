import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  static ThemeData getTheme(BuildContext context) => ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D8E5C)).copyWith(
      secondary: const Color(0xFF06607A),
    ),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme.apply(
      bodyColor: const Color(0xFF333333),
      displayColor: const Color(0xFFFAFAFA),
    )),
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
  );

  static ThemeData getThemeDark(BuildContext context) => ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF009851)).copyWith(
      secondary: const Color(0xFF02427C),
    ),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme.apply(
      bodyColor: const Color(0xFFFAFAFA),
      displayColor: const Color(0xFF333333),
    )),
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
  );
}