import 'package:flutter/material.dart';
import 'package:miutem/core/models/asignaturas/asignatura_malla.dart';
import 'package:miutem/core/utils/utilities.dart';
import 'package:miutem/styles/styles.dart';

class AsignaturaMallaCard extends StatelessWidget {
  final AsignaturaMalla asignatura;
  final double width;
  final double height;
  final double internalMargin;

  const AsignaturaMallaCard({
    super.key,
    required this.asignatura,
    required this.width,
    required this.height,
    this.internalMargin = 8,
  });

  Color _getBackgroundColor(BuildContext context) {
    final estado = asignatura.estado.toLowerCase();
    if (estado.contains('aprobado') || estado.contains('aprobada')) {
      return themedColor(context,
        light: AppTheme.lightGreenCard,
        dark: AppTheme.darkGreenCard,
      );
    } else if (estado.contains('reprobado') || estado.contains('reprobada')) {
      return themedColor(context,
        light: AppTheme.lightSalmonCard,
        dark: AppTheme.darkSalmonCard,
      );
    } else if (estado.contains('cursando') || estado.contains('inscrit')) {
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

    return SizedBox(
      height: height,
      width: width,
      child: Padding(
        padding: EdgeInsets.all(internalMargin),
        child: GestureDetector(
          onTap: () => _showAsignaturaDetail(context),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    asignatura.nombre,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Space.xSmall,
                  Text(
                    asignatura.tipo,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor.withValues(alpha: 0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Space.xSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildChip(context, asignatura.nota, textColor, backgroundColor),
                      Space.xSmall,
                      _buildChip(context, asignatura.estado, textColor, backgroundColor),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(BuildContext context, String label, Color textColor, Color backgroundColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
      ),
    );
  }

  void _showAsignaturaDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SingleChildScrollView(
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
            _buildDetailRow(context, 'Tipo', asignatura.tipo),
            _buildDetailRow(context, 'Estado', asignatura.estado),
            _buildDetailRow(context, 'Nota', asignatura.nota),
            _buildDetailRow(context, 'Nivel', asignatura.nivel.toString()),
            _buildDetailRow(context, 'Intentos', asignatura.intentos.toString()),
            Space.large,
          ],
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
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

