import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/user/credencial/credencial_biblioteca.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/core/services/mi_utem/miutem_credencial_service.dart';
import 'package:miutem/core/utils/utils.dart';
import 'package:miutem/screens/credencial/widgets/credencial_back.dart';
import 'package:miutem/screens/credencial/widgets/credencial_biblioteca_back.dart';
import 'package:miutem/screens/credencial/widgets/credencial_biblioteca_front.dart';
import 'package:miutem/screens/credencial/widgets/credencial_front.dart';
import 'package:miutem/screens/credencial/widgets/flip_card.dart';
import 'package:miutem/styles/styles.dart';

enum TipoCredencial { institucional, sibutem }

class CredencialScreen extends StatefulWidget {
  const CredencialScreen({super.key});

  @override
  State<CredencialScreen> createState() => _CredencialScreenState();
}

class _CredencialScreenState extends State<CredencialScreen> {
  Estudiante? estudiante;
  CredencialBiblioteca? credencialBiblioteca;
  TipoCredencial _tipoCredencial = TipoCredencial.institucional;

  @override
  void initState() {
    super.initState();
    _loadEstudiante();
  }

  Future<void> _loadEstudiante({bool forceRefresh = false}) async {
    try {
      final est = await Get.find<AuthService>().login(forceRefresh: forceRefresh);
      if (mounted) setState(() => estudiante = est);
    } catch (e) {
      logger.e('Error loading estudiante: $e');
    }
  }

  Future<void> _loadCredencialBiblioteca() async {
    try {
      final cred = await Get.find<MiUTEMCredencialService>().getCredencialBiblioteca();
      if (mounted) setState(() => credencialBiblioteca = cred);
    } catch (e) {
      logger.e('Error loading credencial biblioteca: $e');
    }
  }

  void _onTipoCredencialChanged(Set<TipoCredencial> selected) {
    setState(() => _tipoCredencial = selected.first);
    if (_tipoCredencial == TipoCredencial.sibutem && credencialBiblioteca == null) {
      _loadCredencialBiblioteca();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            estudiante = null;
            credencialBiblioteca = null;
          });
          await _loadEstudiante(forceRefresh: true);
          if (_tipoCredencial == TipoCredencial.sibutem) {
            await _loadCredencialBiblioteca();
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Padding (16*2) + título (~34) + Space.medium (16) + segmented (~48) + Space.small (12) + Space.small (12) + hint text (~20)
            final cardHeight = constraints.maxHeight - 32 - 34 - 16 - 48 - 12 - 12 - 20;
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
                      Text('Credencial',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      Space.medium,
                      SizedBox(
                        width: double.infinity,
                        child: SegmentedButton<TipoCredencial>(
                          segments: const [
                            ButtonSegment(
                              value: TipoCredencial.institucional,
                              label: Text('Institucional'),
                            ),
                            ButtonSegment(
                              value: TipoCredencial.sibutem,
                              label: Text('SIBUTEM'),
                            ),
                          ],
                          selected: {_tipoCredencial},
                          onSelectionChanged: _onTipoCredencialChanged,
                        ),
                      ),
                      Space.small,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: _tipoCredencial == TipoCredencial.institucional ? FlipCard(
                          key: const ValueKey('institucional'),
                          front: CredencialFront(
                            usuario: estudiante,
                            availableHeight: cardHeight,
                          ),
                          back: CredencialBack(
                            availableHeight: cardHeight,
                          ),
                        ) : FlipCard(
                          key: const ValueKey('sibutem'),
                          front: CredencialBibliotecaFront(
                            credencial: credencialBiblioteca,
                            availableHeight: cardHeight,
                          ),
                          back: CredencialBibliotecaBack(
                            credencial: credencialBiblioteca,
                            estudiante: estudiante,
                            availableHeight: cardHeight,
                          ),
                        ),
                      ),
                      Space.small,
                      Center(
                        child: Text('Toca la credencial para voltear',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
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
