import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {

  static Color get lightBlueCard => const Color(0xFFB8E8FC);
  static Color get darkBlueCard => const Color(0xFF005C82);

  static Color get lightPurpleCard => const Color(0xFFDFCCFB);
  static Color get darkPurpleCard => const Color(0xFF692083);

  static Color get lightYellowCard => const Color(0xFFFCF7BB);
  static Color get darkYellowCard => const Color(0xFF6D660A);

  static ThemeData getTheme(BuildContext context) => ThemeData.light().copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D8E5C)).copyWith(
      secondary: const Color(0xFF06607A),
    ),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme.apply(
      bodyColor: const Color(0xFF333333),
      displayColor: const Color(0xFFFAFAFA),
    )),
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    navigationBarTheme: NavigationBarTheme.of(context).copyWith(
      backgroundColor: const Color(0xFFFFFFFF),
      elevation: 0,
    ),
  );

  static ThemeData getThemeDark(BuildContext context) => ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1D8E5C)).copyWith(
      secondary: const Color(0xFF06607A),
    ),
    textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme.apply(
      bodyColor: const Color(0xFFFAFAFA),
      displayColor: const Color(0xFF333333),
    )),
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    navigationBarTheme: NavigationBarTheme.of(context).copyWith(
      backgroundColor: const Color(0xFF1A1A1A),
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
  );
}