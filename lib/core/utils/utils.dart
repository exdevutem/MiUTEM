import 'dart:ui';

import 'package:miutem/core/utils/constants.dart';

/// Esta función ejecuta la función `op` si es que el objeto no es nulo, además retorna lo que retorne la función op.
///
/// Modo de uso:
///
/// ```dart
/// num? numeroPosiblementeNulo = 5;
/// num? resultado = let(numeroPosiblementeNulo, (numero) => numero*2);
/// print(resultado); // 10
/// ```
///
/// Ahora, si el objeto es nulo, la función retornará null.
///
/// Además puedes especificar los tipos de datos para ayudar a los IDEs a inferir el tipo de dato de retorno.
/// Ejemplo:
///
/// ```dart
/// String? fechaPosiblementeNula = "2021-10-10";
/// DateTime? fecha = let<String, DateTime?>(fechaPosiblementeNula, (fecha) => DateTime.tryParse(fecha));
/// print(fecha); // 2021-10-10 00:00:00.000
/// ```
V? let<K,V>(K? object, V Function(K) op) => object != null ? op(object) : null;

/// Esta función muestra una nota en formato de 1 o 2 decimales dependiendo de si es un 3.95 o no.
String? formatoNota(num? nota) => nota == 3.95 ? nota?.toStringAsFixed(2) : nota?.toStringAsFixed(1);

/// Esta extensión rotará los elementos de una lista "rotándolos" al final las veces que sea especificado.
/// Ejemplo:
/// ```dart
/// List<int> lista = [1, 2, 3, 4, 5];
/// print(lista.rotate(2)); // [3, 4, 5, 1, 2]
///
/// // Si el número es negativo, se rotará hacia la izquierda
/// print(lista.rotate(-2)); // [4, 5, 1, 2, 3]
/// ```
extension RotateList<T> on List<T> {
  List<T> rotate(int count) => count > 0 ? (sublist(count)..addAll(sublist(0, count))) : (sublist(length + count)..addAll(sublist(0, length + count)));
}

/// Capitaliza el texto entregado
/// Ejemplo:
/// ```dart
/// print(capitalize("hola mundo")); // Hola Mundo
/// ```
///
String capitalize(String text) => text.split(" ").map((e) {
  if(e.isEmpty) return "";
  if(e.length == 1) return e.toUpperCase();
  return e[0].toUpperCase() + e.substring(1).toLowerCase();
}).join(" ");

/// Convierte un string hexadecimal a un color de Flutter
Color fromHex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

/// Obtiene el día actual en formato 'Día, Numero de Mes'.
String getToday() {
  final now = DateTime.now();
  return "${days[now.weekday - 1]}, ${now.day} de ${months[now.month - 1]}";
}