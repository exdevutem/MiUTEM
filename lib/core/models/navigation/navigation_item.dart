import 'package:flutter/material.dart';

class NavigationItem {

  final Widget destination;
  final String label;
  final IconData icon;
  final IconData? iconSelected;

  NavigationItem({required this.destination, required this.label, required this.icon, this.iconSelected});
}