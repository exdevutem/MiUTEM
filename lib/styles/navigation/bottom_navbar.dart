import 'package:flutter/material.dart';
import 'package:miutem/core/models/navigation/navigation_item.dart';
import 'package:miutem/screens/asignaturas/asignaturas_screen.dart';
import 'package:miutem/screens/home/home_screen.dart';
import 'package:miutem/screens/profile/profile_screen.dart';
import 'package:miutem/screens/tasklist/task_list_screen.dart'; 
import 'package:miutem/styles/theme/icons.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  int idx = 0;
  final List<NavigationItem> screens = [
    NavigationItem(destination: const HomeScreen(), label: "Inicio", icon: AppIcons.home),
    NavigationItem(destination: const AsignaturasScreen(), label: "Asignaturas", icon: AppIcons.subjects),
    NavigationItem(destination: const TaskListScreen(), label: "Apuntes", icon: AppIcons.notes),
    NavigationItem(destination: const ProfileScreen(), label: "Perfil", icon: AppIcons.profile),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    extendBody: true,
    bottomNavigationBar: NavigationBar(
      height: 65,
      elevation: 0,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      onDestinationSelected: (idx) => setState(() => this.idx = idx),
      selectedIndex: idx,
      destinations: screens.map((e) => NavigationDestination(
        selectedIcon: Icon(e.icon, fill: 1),
        icon: Icon(e.icon, weight: 600),
        label: e.label,
      )).toList(),
    ),
    body: IndexedStack(
      index: idx,
      children: screens.map((e) => SafeArea(
        minimum: const EdgeInsets.symmetric(vertical: 20),
        child: e.destination,
      )).toList(),
    ),
  );
}