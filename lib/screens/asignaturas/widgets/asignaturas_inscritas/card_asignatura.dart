import 'package:flutter/material.dart';

class CardAsignatura extends StatelessWidget {

  final String tipo, nombre, codigo;
  final Function()? onTap;

  const CardAsignatura({super.key, required this.tipo, required this.nombre, required this.codigo, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Card(
      color: MediaQuery.of(context).platformBrightness == Brightness.light ? Theme.of(context).scaffoldBackgroundColor.withOpacity(.6) : Theme.of(context).scaffoldBackgroundColor.withOpacity(.6),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tipo, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
              Text(nombre, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              Text(codigo, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ),
    ),
  );
}
