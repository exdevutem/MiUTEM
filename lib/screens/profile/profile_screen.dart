import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/core/models/carrera.dart';
import 'package:miutem/core/services/carrera_service.dart';
import 'package:miutem/styles/styles.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  Estudiante? estudiante;
  Carrera? carrera;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final loadedCarrera = await Get.find<CarreraService>().getCarrera();
    setState(() {
      carrera = loadedCarrera;
      _loading = false;
    });
  }

  Future<void> _refreshData() async {
    setState(() => _loading = true);
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final String firstName = estudiante?.nombreCompleto
        .split(' ')
        .firstWhere((word) => word.isNotEmpty, orElse: () => 'Nombre')
        .toLowerCase() ?? 'Nombre';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil del Estudiante'),
        backgroundColor: Colors.blue[800],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Skeletonizer(
                enabled: _loading,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue[800],
                  child: Text(
                    estudiante?.nombreCompleto[0].toUpperCase() ?? '',
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Skeletonizer(
                enabled: _loading,
                child: Text(
                  estudiante?.nombreCompleto ?? '',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Skeletonizer(
                enabled: _loading,
                child: Text(
                  '$firstName, ${carrera?.nombre ?? 'Carrera no disponible'}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildInfoCard('Información Personal', [
                _buildInfoRow('Nombre', estudiante?.nombreCompleto ?? 'N/A'),
                _buildInfoRow('RUT', estudiante?.rut?.toString() ?? 'N/A'),
              ]),
              const SizedBox(height: 10),
              _buildInfoCard('Contacto', [
                _buildInfoRow('Email Institucional', estudiante?.correoUtem ?? 'N/A'),
                _buildInfoRow('Email Personal', estudiante?.correoPersonal ?? 'N/A'),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}

