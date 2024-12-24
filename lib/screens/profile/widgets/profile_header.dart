import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/carrera.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/services/carrera_service.dart';
import 'package:miutem/styles/styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileHeader extends StatefulWidget {
  final Estudiante? estudiante;

  const ProfileHeader({super.key, required this.estudiante});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  Carrera? carrera;
  bool _showElements = false;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Stop loading after a certain time
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() => _loading = false);
      }
    });
  }

  Future<void> _loadData() async {
    setState(() => _showElements = false);
    await _loadCarrera();
    // Small delay to show skeleton before fade in
    await Future.delayed(const Duration(milliseconds: 80));
    if (mounted) {
      setState(() {
        _showElements = true;
        _loading = false;
      });
    }
  }

  Future<void> _loadCarrera() async {
    if (widget.estudiante != null) {
      try {
        final loadedCarrera = await Get.find<CarreraService>().getCarrera();
        if (mounted) {
          setState(() => carrera = loadedCarrera);
        }
      // ignore: empty_catches
      } catch (e) {
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
    final String firstName = widget.estudiante?.nombreCompleto
        .split(' ')
        .firstWhere((word) => word.isNotEmpty, orElse: () => 'Nombre')
        .toLowerCase() ?? 'Nombre';

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedOpacity(
            opacity: _showElements ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Skeletonizer(
              enabled: _loading,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: AppTheme.colorScheme.primary.withOpacity(0.1),
                child: Text(
                  firstName.isNotEmpty ? firstName[0].toUpperCase() : '',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedOpacity(
            opacity: _showElements ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Skeletonizer(
              enabled: _loading,
              child: Text(
                firstName,
                style: StyleText.headline,
              ),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedOpacity(
            opacity: _showElements ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Skeletonizer(
              enabled: _loading,
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
          ),
          AnimatedOpacity(
            opacity: _showElements ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Skeletonizer(
              enabled: _loading,
              child: Text(
                (widget.estudiante?.correoUtem ?? 'correo@utem.cl').toLowerCase(),
                style: StyleText.description
              ),
            ),
          ),
          const SizedBox(height: 8),
          AnimatedOpacity(
            opacity: _showElements ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Skeletonizer(
              enabled: _loading,
              child: SizedBox(
                height: 40, // Adjust this value if needed for 2 lines
                child: Text(
                  carrera?.nombre ?? 'Carrera\nen Curso',  // Default text with 2 lines
                  textAlign: TextAlign.center,
                  style: StyleText.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}