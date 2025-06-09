import 'package:flutter/material.dart';
class CategoryDM {
  final String id;
  final String name;
  final IconData icon;
  final String? imagePath;

  CategoryDM(
      {required this.id,
        required this.name,
        required this.icon,
        this.imagePath});
}