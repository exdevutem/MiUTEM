import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miutem/core/models/preferencia.dart';
import 'package:miutem/core/services/service_manager.dart';
import 'package:miutem/core/utils/http/functions.dart';
import 'package:miutem/core/utils/theme.dart';
import 'package:miutem/widgets/navigation/bottom_navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // Oculta la barra de estado
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  
  // Esto hace que la app se construya debajo del status bar
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
    overlays: [SystemUiOverlay.top],
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Mi UTEM',
    debugShowCheckedModeBanner: false,
    theme: AppTheme.getTheme(context),
    darkTheme: AppTheme.getThemeDark(context),
    home: const BottomNavBar(),
  );
}
