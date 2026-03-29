import "package:flutter/material.dart";

class Space {
  /// 28 PX para separar secciones muy distintas o elementos muy importantes
  static const Widget extraLarge = SizedBox(height: 28);
  /// 20 PX para separar elementos muy distintos o secciones
  static const Widget large = SizedBox(height: 20);
  /// 16 PX para separar elementos similares con bordes
  static const Widget medium = SizedBox(height: 16);
  /// 12 PX para separar elementos similares pequeños
  static const Widget small = SizedBox(height: 12);
  /// 8 PX para separar elementos muy similares
  static const Widget extraSmall = SizedBox(height: 8);
}

class HorizontalSpace {
  /// 48 PX para separar secciones muy distintas o elementos muy importantes
  static const Widget extraExtraLarge = SizedBox(width: 48);
  /// 28 PX para separar secciones muy distintas o elementos muy importantes
  static const Widget extraLarge = SizedBox(width: 28);
  /// 20 PX para separar elementos muy distintos o secciones
  static const Widget large = SizedBox(width: 20);
  /// 16 PX para separar elementos similares con bordes
  static const Widget medium = SizedBox(width: 16);
  /// 12 PX para separar elementos similares pequeños
  static const Widget small = SizedBox(width: 12);
  /// 8 PX para separar elementos muy similares
  static const Widget extraSmall = SizedBox(width: 8);
}