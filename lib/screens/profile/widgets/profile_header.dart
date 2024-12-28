import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/carrera.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/services/carrera_service.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/styles/styles.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:logger/logger.dart';

class ProfileHeader extends StatefulWidget {
  final Estudiante? estudiante;

  const ProfileHeader({super.key, required this.estudiante});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  final Logger _logger = Logger();
  Carrera? carrera;

  @override
  void initState() {
    super.initState();
    _logger.d("ProfileHeader initialized");
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadCarrera();
    // Small delay to show skeleton before fade in
    await Future.delayed(const Duration(milliseconds: 80));
    if (mounted) {
    }
  }

  Future<void> _loadCarrera() async {
    if (widget.estudiante != null) {
      try {
        final loadedCarrera = await Get.find<CarreraService>().getCarrera();
        if (mounted) {
          setState(() => carrera = loadedCarrera);
        }
      } catch (e) {
        _logger.e('Error loading carrera: $e');
       
      }
    }
  }

  @override
  void didUpdateWidget(ProfileHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.estudiante != widget.estudiante) {
      _loadCarrera();
    }
  }

  @override
  Widget build(BuildContext context) {
    final String firstName = capitalize(widget.estudiante!.nombreCompleto
        .split(' ')
        .firstWhere((word) => word.isNotEmpty, orElse: () => 'Nombre')
        .toLowerCase());

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Skeletonizer(
            enabled: widget.estudiante == null,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: AppTheme.colorScheme.primary.withOpacity(0.2),
              child: Text(
                firstName[0].toUpperCase(),
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.colorScheme.primary,
                ),
              ),
            ),
          ),
          Space.small,
          Skeletonizer(
            enabled: widget.estudiante == null,
            child: Text(
              firstName,
              style: StyleText.headline,
            ),
          ),
          Space.xSmall,
          Skeletonizer(
            enabled: widget.estudiante == null,
            child: Text(
              widget.estudiante?.nombreCompleto
                .split(' ')
                .map((word) => word.isNotEmpty 
                  ? '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}'
                  : '')
                .join(' ') ?? 'Nombre Apellido',
              style: StyleText.label,
            ),
          ),
          Space.xSmall,
          Skeletonizer(
            enabled: widget.estudiante == null,
            child: Text(
              (widget.estudiante?.correoUtem ?? 'correo@utem.cl').toLowerCase(),
              style: StyleText.description
            ),
          ),
          Space.xSmall,
          Skeletonizer(
            enabled: carrera == null,
            child: SizedBox(
              height: 40, 
              child: Text(
                carrera?.nombre ?? 'Carrera\nen Curso',  
                textAlign: TextAlign.center,
                style: StyleText.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}