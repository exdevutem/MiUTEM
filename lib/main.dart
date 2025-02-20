import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:miutem/core/models/config/user_config.dart';
import 'package:miutem/core/models/preferencia.dart';
import 'package:miutem/core/services/controllers/local_notifications_controller.dart';
import 'package:miutem/core/services/service_manager.dart';
import 'package:miutem/core/utils/http/functions.dart';
import 'package:miutem/styles/styles.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // Oculta la barra de estado
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  WidgetsFlutterBinding.ensureInitialized();
  await initServices();
  runApp(const MiUTEMApp());
}

class MiUTEMApp extends StatefulWidget {
  const MiUTEMApp({super.key});

  @override
  State<MiUTEMApp> createState() => _MiUTEMAppState();
}

class _MiUTEMAppState extends State<MiUTEMApp> {

  @override
  void initState() {
    isOffline().then((isOffline) => Preferencia.isOffline.set(isOffline ? 'true' : 'false'), onError: (err) => Preferencia.isOffline.set('true'));
    NotificationController.checkAndRequestNotificationPermissions();
    
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Mi UTEM',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.getTheme(context),
    darkTheme: AppTheme.getThemeDark(context),
    home: const Scaffold(body: BottomNavBar()),
  );
}