import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Clase que contiene los estilos de texto de la aplicación.
class StyleText {
  /// (30px - black - Inter) Headline: Encabezados y textos muy grandes. 
  static TextStyle headline = GoogleFonts.inter(
    fontSize: 30,
    fontWeight: FontWeight.w900,
    letterSpacing: 0,
    height: 1.2,
  );

  /// (18px - normal - Inter) Header: Títulos y textos grandes. 
  static TextStyle header = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.5,
  );

  /// (16px - bold - Inter) Label: Textos de etiquetas medianas. 
  static TextStyle label = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// (16px - bold - Roboto) Description: Textos de descripciones.
  static TextStyle descriptionBold = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  /// (16px - normal - Roboto) Description: Textos de descripciones.
  static TextStyle description = GoogleFonts.roboto(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.2,
  );

  /// (14px - bold - Roboto) Body: Textos de cuerpo pequeños.
  static TextStyle bodyBold = GoogleFonts.roboto(
    fontSize: 14,
    fontWeight: FontWeight.w700,
  );

  /// (14px - normal - Roboto) Body: Textos de cuerpo pequeños.
  static TextStyle body = GoogleFonts.roboto( 
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );

  /// (12px - bold - Roboto) Caption: Textos de pie de página.
  static TextStyle captionBold = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w700,
  );

  /// (12px - normal - Roboto) Caption: Textos de pie de página.
  static TextStyle caption = GoogleFonts.roboto(
    fontSize: 12,
    fontWeight: FontWeight.w400,
  );
}
