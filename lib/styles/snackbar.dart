import 'package:flutter/material.dart';

void showErrorSnackbar(BuildContext context, String message, { Function()? onTap }) => showTextSnackbar(context, title: "Error", message: message, backgroundColor: Colors.red, onTap: onTap);

void showTextSnackbar(BuildContext context, {
  required String title,
  required String message,
  Color? backgroundColor,
  Color? textColor,
  Duration? duration,
  Function()? onTap,
}) => showSnackbar(context,
  content: GestureDetector(
    onTap: onTap,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: textColor ?? Colors.white)),
        Text(message, style: TextStyle(color: textColor ?? Colors.white)),
      ],
    ),
  ),
  backgroundColor: backgroundColor,
  duration: duration,
);

void showSnackbar(BuildContext context, {
  required Widget content,
  Color? backgroundColor,
  Duration? duration,
}) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  content: content,
  backgroundColor: backgroundColor,
  behavior: SnackBarBehavior.floating,
  duration: duration ?? const Duration(seconds: 5),
));