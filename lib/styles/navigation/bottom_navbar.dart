import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:miutem/core/models/navigation/navigation_item.dart";
import "package:miutem/core/models/user/perfil.dart";
import "package:miutem/core/services/auth_service.dart";
import "package:miutem/screens/asignaturas/lista_asignaturas_screen.dart";
import "package:miutem/screens/credencial/credencial_screen.dart";
import "package:miutem/screens/home/home_screen.dart";
import "package:miutem/screens/profile/profile_screen.dart";
import "package:miutem/screens/tasklist/task_list_screen.dart";
import "package:miutem/styles/theme/icons.dart";
import "package:miutem/widgets/feature_flag.dart";

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  int idx = 0;
  final List<NavigationItem> allScreens = [
    NavigationItem(destination: const HomeScreen(), label: "Inicio", featureFlag: "bottom_navigation.home", icon: AppIcons.home),
    NavigationItem(destination: const AsignaturasScreen(), label: "Asignaturas", featureFlag: "bottom_navigation.asignaturas", icon: AppIcons.subjects, perfiles: [Perfil.estudiante]),
    NavigationItem(destination: const CredencialScreen(), label: "Credencial", featureFlag: "bottom_navigation.credencial", icon: AppIcons.credential),
    NavigationItem(destination: const TaskListScreen(), label: "Apuntes", featureFlag: "bottom_navigation.apuntes", icon: AppIcons.notes),
    NavigationItem(destination: const ProfileScreen(), label: "Perfil", featureFlag: "bottom_navigation.perfil", icon: AppIcons.profile),
  ];

  List<NavigationItem> get enabledScreens {
    return allScreens.where((screen) => FeatureFlag.evaluateSync(screen.featureFlag)).where((screen) => screen.perfiles.isNotEmpty ? FeatureFlag.evaluateProfileSync(screen.perfiles) : true).toList();
  }

  @override
  void initState() {
    super.initState();
    // Hydrate auth cache first so profile-gated tabs are available on first render.
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authService = Get.find<AuthService>();
      if (authService.cachedEstudiante == null) {
        try {
          await authService.login();
        } catch (_) {
          // Keep current behavior when login state is not available yet.
        }
      }

      if (!mounted) return;

      final enabled = enabledScreens;
      if (enabled.isNotEmpty && idx >= enabled.length) {
        setState(() {
          idx = 0;
        });
        return;
      }

      // Rebuild once to reflect profile-based tabs after auth cache hydration.
      setState(() {});
    });
  }

  void _onDestinationSelected(int selectedIdx) {
    final enabled = enabledScreens;
    if (selectedIdx >= 0 && selectedIdx < enabled.length) {
      setState(() {
        idx = selectedIdx;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = enabledScreens;

    // If no screens are enabled, show a fallback (this shouldn't happen in practice)
    if (enabled.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text("No navigation items available"),
        ),
      );
    }

    // Ensure current index is valid
    final currentIdx = idx >= enabled.length ? 0 : idx;

    return Scaffold(
      extendBody: true,
      bottomNavigationBar: NavigationBar(
        height: 65,
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        onDestinationSelected: _onDestinationSelected,
        selectedIndex: currentIdx,
        destinations: enabled.map((e) => NavigationDestination(
          selectedIcon: Icon(e.icon, fill: 1),
          icon: Icon(e.icon, weight: 600),
          label: e.label,
        )).toList(),
      ),
      body: IndexedStack(
        index: currentIdx,
        children: enabled.map((e) => SafeArea(
          minimum: const EdgeInsets.symmetric(vertical: 20),
          child: e.destination,
        )).toList(),
      ),
    );
  }
}