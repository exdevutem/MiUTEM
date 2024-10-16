import 'package:flutter/material.dart';

class CardClase extends StatefulWidget {
  final String horaInicio;
  final String horaFin;
  final String nombreClase;
  final String sala;

  const CardClase({
    required this.horaInicio,
    required this.horaFin,
    required this.nombreClase,
    required this.sala,
    super.key,
  });

  @override
  State<CardClase> createState() => _CardClaseState();
}

class _CardClaseState extends State<CardClase> with WidgetsBindingObserver {

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    setState(() {});
    super.didChangePlatformBrightness();
  }

  String formatTime(String time) {
    final parts = time.split(':');
    final hours = parts[0].padLeft(2, '0');
    final minutes = parts[1].padLeft(2, '0');
    return '$hours:$minutes';
  }

  @override
  Widget build(BuildContext context) => Card(
    color: MediaQuery.of(context).platformBrightness == Brightness.light ? Theme.of(context).scaffoldBackgroundColor.withOpacity(.6) : Theme.of(context).scaffoldBackgroundColor.withOpacity(.6),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.only(bottom: 10),
    child: IntrinsicHeight(  // Usamos IntrinsicHeight para igualar las alturas
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,  // Forzamos que ocupe toda la altura
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.white : Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), bottomLeft: Radius.circular(16)),
              border: Border(
                right: BorderSide(
                  color: MediaQuery.of(context).platformBrightness == Brightness.light ? Colors.black12 : Colors.white54,
                ),
              ),
            ),
            child: SizedBox(
              width: 85,  // Ancho ajustado para la columna de la hora
              child: Padding(
                padding: const EdgeInsets.all(16),  // Ajuste de padding
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      formatTime(widget.horaInicio),
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    Text(formatTime(widget.horaFin),
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),  // Ajuste de padding en la parte derecha
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 45,  // Espacio para el texto con 2 líneas
                    child: Text(
                      widget.nombreClase,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, size: 16),
                      const SizedBox(width: 5),
                      Text(widget.sala),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}