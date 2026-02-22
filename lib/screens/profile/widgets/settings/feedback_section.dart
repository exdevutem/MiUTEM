import 'package:flutter/material.dart';
import 'package:miutem/styles/styles.dart';
import 'package:miutem/widgets/feature_flag.dart';

class FeedbackSection extends StatelessWidget {
  const FeedbackSection({super.key});

  @override
  Widget build(BuildContext context) => FeatureFlag.multiple(const ['perfil.bug_report', 'perfil.feedback_report'], child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Space.small,
      Text('Feedback', style: Theme.of(context).textTheme.bodyLarge),
      FeatureFlag('perfil.bug_report', child: ListTile(
        title: const Text('Reportar un Bug'),
        subtitle: const Text('Reportar un bug en la aplicación'),
        onTap: () {
          // Implementar lógica para reportar un bug
        },
      )),
      FeatureFlag('perfil.feedback_report', child: ListTile(
        title: const Text('Sugerencias'),
        subtitle: const Text('Déjanos tus opiniones sobre la App'),
        onTap: () {
          // Implementar lógica para sugerencias
        },
      ))
    ],
  ));
}
