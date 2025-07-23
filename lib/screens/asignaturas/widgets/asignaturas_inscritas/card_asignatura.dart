import 'package:flutter/material.dart';

class CardAsignatura extends StatelessWidget {

  final String tipo, nombre, codigo;
  final Function()? onTap;

  const CardAsignatura({super.key, required this.tipo, required this.nombre, required this.codigo, this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Card(
      elevation: 0,
      color: Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: Theme.of(context).dividerColor),
      ),
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tipo, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
              Text(nombre, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
              Text(codigo, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ),
    ),
  );
}
