import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;
  final EdgeInsetsGeometry padding;
  final String? message;

  const LoadingIndicator({
    super.key,
    this.color,
    this.padding = const EdgeInsets.all(20),
    this.message,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30),
    child: Center(
      child: Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: color),
            if (message != null) const SizedBox(height: 10),
            if (message != null) Text("$message"),
          ],
        ),
      ),
    ),
  );

  static Widget centered({String? message}) => Center(child: LoadingIndicator(message: message));

  static Widget centeredDefault() => centered(message: "Esto tardará un poco, paciencia...");

}
