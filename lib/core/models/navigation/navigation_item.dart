import "package:flutter/material.dart";
import "package:miutem/core/models/user/perfil.dart";

class NavigationItem {

  final Widget destination;
  final String label;
  final String featureFlag;
  final List<Perfil> perfiles;
  final IconData icon;

  NavigationItem({required this.destination, required this.label, required this.featureFlag, required this.icon, this.perfiles = const []});
}