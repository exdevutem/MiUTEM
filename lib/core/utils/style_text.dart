import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyleText {
  static TextStyle headline = GoogleFonts.inter(
    fontSize: 30,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
    height: 1.2,
  );

  static TextStyle label = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );
  
  static TextStyle header = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  static TextStyle descriptionBold = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static TextStyle description = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  static TextStyle bodyBold = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  static TextStyle body = GoogleFonts.roboto( 
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}
