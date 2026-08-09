import "dart:io";

import "package:adaptive_theme/adaptive_theme.dart";
import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:miutem/core/models/preferencia.dart";
import "package:miutem/core/services/controllers/local_notifications_controller.dart";
import "package:miutem/core/services/service_manager.dart";
import "package:miutem/core/utils/http/functions.dart";
import "package:miutem/styles/styles.dart";

void runMainApp(FirebaseOptions firebaseOptions) async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
    // Set window title to "Mi UTEM"
    SystemChrome.setApplicationSwitcherDescription(
      const ApplicationSwitcherDescription(
        label: "Mi UTEM",
        primaryColor: 0xFF000000, // Set the primary color to black
      ),
    );
  }

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // Oculta la barra de estado,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  await initServices(firebaseOptions);
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
    isOffline().then((isOffline) => Preferencia.isOffline.set(isOffline ? "true" : "false"), onError: (err) => Preferencia.isOffline.set("true"));
    NotificationController.checkAndRequestNotificationPermissions();

    super.initState();
  }

  @override
  Widget build(BuildContext context) => AdaptiveTheme(
    light: AppTheme.getTheme(context),
    dark: AppTheme.getThemeDark(context),
    initial: AdaptiveThemeMode.light,
    debugShowFloatingThemeButton: false,
    builder: (theme, darkTheme) => MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Mi UTEM",
      theme: theme,
      darkTheme: darkTheme,
      home: const Scaffold(body: BottomNavBar()),
    ),
  );
}
