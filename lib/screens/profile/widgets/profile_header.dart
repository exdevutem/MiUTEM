import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:miutem/core/models/carrera.dart";
import "package:miutem/core/models/user/estudiante.dart";
import "package:miutem/core/models/user/perfil.dart";
import "package:miutem/core/services/carrera_service.dart";
import "package:miutem/core/utils/utils.dart";
import "package:miutem/styles/styles.dart";
import "package:miutem/widgets/feature_flag.dart";
import "package:miutem/widgets/user_avatar.dart";
import "package:skeletonizer/skeletonizer.dart";
import "package:logger/logger.dart";

class ProfileHeader extends StatefulWidget {
  final Estudiante? usuario;

  const ProfileHeader({super.key, required this.usuario});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  final Logger _logger = Logger();
  Carrera? carrera;

  @override
  void initState() {
    super.initState();
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
    if (widget.usuario?.perfiles.contains(Perfil.estudiante) == true) {
      try {
        final loadedCarrera = await Get.find<CarreraService>().getCarrera();
        if (mounted) {
          setState(() => carrera = loadedCarrera);
        }
      } catch (e) {
        _logger.e("Error loading carrera: $e");
      }
    }
  }

  @override
  void didUpdateWidget(ProfileHeader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.usuario != widget.usuario) {
      _loadCarrera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Skeletonizer(
            enabled: widget.usuario == null,
            child: UserAvatar(
              estudiante: widget.usuario,
              radius: 50,
            ),
          ),
          Space.small,
          Skeletonizer(
            enabled: widget.usuario == null,
            child: Text(widget.usuario?.primerNombre ?? "John",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Space.extraSmall,
          Skeletonizer(
            enabled: widget.usuario == null,
            child: Text(capitalize(widget.usuario?.nombreCompleto ?? "John Doe"),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Space.extraSmall,
          Skeletonizer(
            enabled: widget.usuario == null,
            child: Text((widget.usuario?.correoUtem ?? "correo@utem.cl").toLowerCase(),
              style: Theme.of(context).textTheme.bodyLarge
            ),
          ),
          Space.extraSmall,
          FeatureFlag.profiles(
            const [Perfil.estudiante],
            showProfileRestrictionMessage: false,
            child: Skeletonizer(
              enabled: carrera == null,
              child: SizedBox(
                height: 40,
                child: Text(carrera?.nombre ?? "Carrera\nen Curso",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}