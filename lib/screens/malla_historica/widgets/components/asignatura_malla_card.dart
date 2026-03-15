import "package:flutter/material.dart";
import "package:miutem/core/models/asignaturas/asignatura_malla.dart";
import "package:miutem/core/utils/utilities.dart";
import "package:miutem/styles/styles.dart";

class AsignaturaMallaCard extends StatelessWidget {
  final AsignaturaMalla asignatura;

  const AsignaturaMallaCard({
    super.key,
    required this.asignatura,
  });

  Color _getBackgroundColor(BuildContext context) {
    final estado = asignatura.estado.toLowerCase();
    if (estado.contains("aprobado") || estado.contains("aprobada")) {
      return themedColor(context,
        light: AppTheme.lightGreenCard,
        dark: AppTheme.darkGreenCard,
      );
    } else if (estado.contains("reprobado") || estado.contains("reprobada")) {
      return themedColor(context,
        light: AppTheme.lightSalmonCard,
        dark: AppTheme.darkSalmonCard,
      );
    } else if (estado.contains("cursando") || estado.contains("inscrit")) {
      return themedColor(context,
        light: AppTheme.lightBlueCard,
        dark: AppTheme.darkBlueCard,
      );
    }
    return themedColor(context,
      light: AppTheme.lightYellowCard,
      dark: AppTheme.darkYellowCard,
    );
  }

  Color _getTextColor(BuildContext context) {
    final backgroundColor = _getBackgroundColor(context);
    final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);
    return brightness == Brightness.light ? Colors.black87 : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getBackgroundColor(context);
    final textColor = _getTextColor(context);

    return Padding(
      padding: const EdgeInsets.all(6),
      child: GestureDetector(
        onTap: () => _showAsignaturaDetail(context),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  asignatura.nombre,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Space.extraSmall,
              Text(
                asignatura.tipo,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: textColor.withValues(alpha: 0.8),
                ),
                textAlign: TextAlign.center,
              ),
              Space.extraSmall,
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 4,
                runSpacing: 4,
                children: [
                  _buildChip(context, asignatura.nota, textColor),
                  _buildChip(context, asignatura.estado, textColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: textColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  void _showAsignaturaDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Space.medium,
              Text(
                asignatura.nombre,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Space.medium,
              _buildDetailRow(context, "Tipo", asignatura.tipo),
              _buildDetailRow(context, "Estado", asignatura.estado),
              _buildDetailRow(context, "Nota", asignatura.nota),
              _buildDetailRow(context, "Nivel", asignatura.nivel.toString()),
              _buildDetailRow(context, "Intentos", asignatura.intentos.toString()),
              Space.large,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
