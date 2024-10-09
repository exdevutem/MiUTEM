import 'package:flutter/material.dart';

class CardAccesoRapido extends StatefulWidget {
  final Color color, colorDark;
  final String label;
  final IconData icon;
  final Function() onTap;
  final double fill;

  const CardAccesoRapido({super.key, required this.color, required this.label, required this.icon, required this.onTap, required this.colorDark, this.fill = 1.0});

  @override
  State<CardAccesoRapido> createState() => _CardAccesoRapidoState();
}

class _CardAccesoRapidoState extends State<CardAccesoRapido> with WidgetsBindingObserver{

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

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: widget.onTap,
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: MediaQuery.of(context).platformBrightness == Brightness.light ? widget.color : widget.colorDark,
      child: SizedBox(
        width: 120,
        height: 125,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(widget.icon, fill: widget.fill, size: 32, color: Theme.of(context).textTheme.bodyMedium?.color),
              const Spacer(),
              Text(widget.label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyMedium?.color)),
            ],
          ),
        ),
      ),
    ),
  );
}
