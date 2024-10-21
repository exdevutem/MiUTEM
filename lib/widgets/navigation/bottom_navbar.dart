import 'package:flutter/material.dart';
import 'package:miutem/core/models/navigation/navigation_item.dart';
import 'package:miutem/screens/home/home_screen.dart';
import 'package:miutem/screens/profile/profile-idea.dart';
import 'package:miutem/widgets/icons.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  int idx = 0;
  final List<NavigationItem> screens = [
    NavigationItem(destination: const HomeScreen(), label: "Inicio", icon: AppIcons.home, iconSelected: AppIcons.home),
    NavigationItem(destination: const HomeScreen(), label: "Asignaturas", icon: AppIcons.subjects, iconSelected: AppIcons.subjects),
    NavigationItem(destination: const HomeScreen(), label: "Novedades", icon: AppIcons.updates, iconSelected: AppIcons.updates),
    NavigationItem(destination: const ProfileScreen(), label: "Perfil", icon: AppIcons.profile, iconSelected: AppIcons.profile),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    bottomNavigationBar: NavigationBar(
      onDestinationSelected: (idx) => setState(() => this.idx = idx),
      selectedIndex: idx,
      destinations: screens.map((e) => NavigationDestination(
        selectedIcon: Icon(e.iconSelected, fill: 1),
        icon: Icon(e.icon, weight: 600),
        label: e.label,
      )).toList(),
    ),
    body: SafeArea(child: screens[idx].destination),
  );
}

