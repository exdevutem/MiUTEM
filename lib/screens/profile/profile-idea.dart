import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/services/auth_service.dart';
import 'package:miutem/core/utils/style_text.dart';

// Esta Screen está hecha a modo de prueba con IA, para sacar una idea inicial
class ProfileScreen extends StatelessWidget {
  final Estudiante? estudiante;
  const ProfileScreen({super.key, this.estudiante});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // Queda vacío para dejar el espacio
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 50,
          ),
          const SizedBox(height: 16),
          Text('Apodo',
            style: StyleText.headline,
          ),
          Text('Nombre Apellido',
            style: StyleText.label,
          ),
          Text('correo@utem.cl',
            style: StyleText.description
          ),
          const SizedBox(height: 8),
          Text('Nombre de la carrera',
            textAlign: TextAlign.center,
            style: StyleText.description,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton(
              style: const ButtonStyle(elevation: WidgetStatePropertyAll(0)),
              child: const Text('Editar Perfil'),
              onPressed: () {
                //todo Editar Perfil (APODO, y lo que se pueda)
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
    );
  }
}
