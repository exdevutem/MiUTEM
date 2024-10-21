import 'package:flutter/material.dart';
import 'package:miutem/core/models/user/estudiante.dart';
import 'package:miutem/widgets/navigation/top_navigation.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Estudiante? estudiante;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopNavigation(estudiante: estudiante),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
            ],
          ),
        ),
      );
}
