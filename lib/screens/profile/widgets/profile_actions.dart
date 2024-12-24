import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileActions extends StatefulWidget {
  const ProfileActions({super.key});

  @override
  State<ProfileActions> createState() => _ProfileActionsState();
}

class _ProfileActionsState extends State<ProfileActions> {
  bool _showElements = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _showElements = false);
    // Small delay to show skeleton before fade in
    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted) {
      setState(() => _showElements = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _showElements ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300),
      child: Skeletonizer(
        enabled: !_showElements,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ElevatedButton(
                  style: const ButtonStyle(elevation: WidgetStatePropertyAll(0)),
                  child: const Text('Editar Perfil'),
                  onPressed: () {
                    //TODO Editar Perfil (APODO, y lo que se pueda)
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  style: const ButtonStyle(
                    foregroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 104, 7, 0)),
                    backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 250, 186, 181)),
                    elevation: WidgetStatePropertyAll(0),
                  ),
                  child: const Text('Cerrar Sesión'),
                  onPressed: () => Get.find<AuthService>().logout(context: context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}