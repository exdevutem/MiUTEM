import 'package:flutter/material.dart';

class NavigationItem {

  final Widget destination;
  final String label;
  final String featureFlag;
  final IconData icon;

  NavigationItem({required this.destination, required this.label, required this.featureFlag, required this.icon});
}