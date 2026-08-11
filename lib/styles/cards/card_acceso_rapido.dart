import "package:adaptive_theme/adaptive_theme.dart";
import "package:flutter/material.dart";
import "package:miutem/core/utils/utilities.dart";
import "package:miutem/widgets/feature_flag.dart";

class CardAccesoRapido extends StatelessWidget {
  final Color color, colorDark;
  final String label;
  final IconData icon;
  final Function() onTap;
  final double fill;

  /// Clave del feature flag dentro de `acceso_rapido` en Remote Config (ej: "horario").
  /// Si la característica está desactivada, la tarjeta se ve opaca y al tocarla
  /// muestra el motivo definido en `acceso_rapido.<flagKey>.reason`.
  final String? flagKey;

  const CardAccesoRapido({super.key, required this.color, required this.label, required this.icon, required this.onTap, required this.colorDark, this.fill = 1.0, this.flagKey});

  bool get _isEnabled => flagKey == null || FeatureFlag.evaluateSync("acceso_rapido.$flagKey.enabled");

  void _mostrarMotivo(BuildContext context) => showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      icon: const Icon(Icons.info_outline_rounded),
      title: Text(FeatureFlag.getString("acceso_rapido.$flagKey.reason.title", defaultValue: "$label no está disponible")),
      content: Text(FeatureFlag.getString("acceso_rapido.$flagKey.reason.message", defaultValue: "Desactivamos temporalmente esta característica. Inténtalo más tarde.")),
      actions: [
        TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Entendido")),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final enabled = _isEnabled;
    return GestureDetector(
      onTap: enabled ? onTap : () => _mostrarMotivo(context),
      child: Opacity(
        opacity: enabled ? 1 : 0.4,
        child: ValueListenableBuilder<AdaptiveThemeMode>(
          valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
          builder: (ctx, mode, child) => DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: themedColor(context, light: color, dark: colorDark),
            ),
            child: SizedBox(
              height: 120,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12,20,12,20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(icon, fill: fill, size: 32, weight: 600, color: Theme.of(context).textTheme.bodyMedium?.color),
                    const Spacer(),
                    Text(label, style: Theme.of(context).textTheme.labelMedium),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
