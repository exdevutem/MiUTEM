import 'package:flutter/material.dart';
import 'package:miutem/screens/home/models/novedad.dart';
import 'package:miutem/screens/home/widgets/novedades/card_novedades.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ListaNovedades extends StatelessWidget {

  final List<Novedad>? novedades;

  const ListaNovedades({super.key, required this.novedades});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Novedades", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
      const SizedBox(height: 10),
      SizedBox(
        height: 150,
        child: novedades != null ? ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: novedades!.length,
          itemBuilder: (context, index) => CardNovedades(novedad: novedades![index]),
        ) : Skeletonizer(child: ListView.builder(itemCount: 1, itemBuilder: (ctx, idx) => const CardNovedades(novedad: Novedad(icon: "updates", title: "¡Nueva Versión!", subtitle: "Te presentamos la nueva versión de la app Mi UTEM")))),
      ),
    ],
  );
}
