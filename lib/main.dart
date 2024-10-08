import 'package:flutter/material.dart';
import 'package:miutem/core/services/service_manager.dart';
import 'package:miutem/core/utils/theme.dart';
import 'package:miutem/screens/auth/login/login_screen.dart';

void main() async {
  await initServices();
  runApp(const MiUTEMApp());
}

class MiUTEMApp extends StatelessWidget {
  const MiUTEMApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi UTEM',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(context),
      darkTheme: AppTheme.getThemeDark(context),
      home: const LoginScreen(),
    );
  }
}