import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:miutem/core/models/user/estudiante.dart";
import "package:miutem/core/models/user/perfil.dart";
import "package:miutem/core/services/auth_service.dart";
import "package:miutem/core/utils/utils.dart";
import "package:miutem/screens/credencial/widgets/credencial_back.dart";
import "package:miutem/screens/credencial/widgets/credencial_front.dart";
import "package:miutem/screens/credencial/widgets/flip_card.dart";
import "package:miutem/styles/styles.dart";
import "package:miutem/widgets/feature_flag.dart";

class CredencialScreen extends StatefulWidget {
  const CredencialScreen({super.key});

  @override
  State<CredencialScreen> createState() => _CredencialScreenState();
}

class _CredencialScreenState extends State<CredencialScreen> {
  Estudiante? estudiante;

  @override
  void initState() {
    super.initState();
    _loadEstudiante();
  }

  Future<void> _loadEstudiante({bool forceRefresh = false}) async {
    try {
      final est = await Get.find<AuthService>().login(
        forceRefresh: forceRefresh,
      );
      if (mounted) setState(() => estudiante = est);
    } catch (e) {
      logger.e("Error loading estudiante: $e");
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() => estudiante = null);
          await _loadEstudiante(forceRefresh: true);
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Padding (16*2) + título (~34) + Space.medium (16) + Space.small (12) + hint text (~20)
            final cardHeight =
                (constraints.maxHeight - 32 - 34 - 16 - 12 - 20)
                    .clamp(560.0, double.infinity)
                    .toDouble();
            return SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              clipBehavior: Clip.none,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Credencial",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Space.medium,
                      FeatureFlag.profiles(
                        const [Perfil.estudiante, Perfil.profesor],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: FlipCard(
                                front: CredencialFront(
                                  usuario: estudiante,
                                  availableHeight: cardHeight,
                                ),
                                back: CredencialBack(
                                  availableHeight: cardHeight,
                                ),
                              ),
                            ),
                            Space.small,
                            Center(
                              child: Text(
                                "Toca la credencial para voltear",
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    ),
  );
}
