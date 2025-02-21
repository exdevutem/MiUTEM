import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:miutem/screens/home/models/novedad.dart';
import 'package:miutem/screens/home/widgets/novedades/card_novedades.dart';
import 'package:miutem/styles/styles.dart';

const defaultCard = CardNovedades(novedad: Novedad(icon: "updates", title: "¡Nueva Versión!", subtitle: "Te presentamos la nueva versión de la app Mi UTEM"));

class ListaNovedades extends StatelessWidget {
  final List<Novedad> novedades;

  const ListaNovedades({super.key, required this.novedades});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("Novedades", style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700)),
      Space.xSmall,
      ExpandableCarousel(
        options: ExpandableCarouselOptions(
          showIndicator: false,
          autoPlay: true,
          viewportFraction: 1,
          enlargeCenterPage: true,
        ),
        items: novedades.map((novedad) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: CardNovedades(novedad: novedad),
        )).toList(),
      ),
    ],
  );
}
