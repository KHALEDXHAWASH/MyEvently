import 'package:evently_c14_online_sun/core/resources/assets_manager.dart';
import 'package:evently_c14_online_sun/data/data_model/categoryDM.dart';
import 'package:flutter/material.dart';

class ConstantManager {
  static const String weakPassword = "weak-password";
  static const String emailInUse = 'email-already-in-use';
  static List<CategoryDM> categories = [
    CategoryDM(
      id: "0",
      name: "All",
      icon: Icons.grid_3x3,
    ),
    CategoryDM(id: "1", name: "Sport", icon: Icons.sports_gymnastics_rounded),
    CategoryDM(id: "2", name: "BirthDay", icon: Icons.cake_rounded),
    CategoryDM(id: "3", name: "Meeting", icon: Icons.laptop_mac_rounded),
    CategoryDM(id: "4", name: "Gaming", icon: Icons.games_rounded),
    CategoryDM(id: "5", name: "Eating", icon: Icons.fastfood_rounded),
    CategoryDM(id: "6", name: "Holiday", icon: Icons.holiday_village_rounded),
    CategoryDM(id: "7", name: "Exhibition", icon: Icons.water_drop_outlined),
    CategoryDM(id: "8", name: "WorkShop", icon: Icons.workspaces_outlined)
  ];
  static List<CategoryDM> categoriesWithoutAll = [
    CategoryDM(
        id: "1",
        name: "Sport",
        icon: Icons.sports_gymnastics_rounded,
        imagePath: ImageAssets.sports),
    CategoryDM(
        id: "2",
        name: "BirthDay",
        icon: Icons.cake_rounded,
        imagePath: ImageAssets.birthday),
    CategoryDM(
        id: "3",
        name: "Meeting",
        icon: Icons.laptop_mac_rounded,
        imagePath: ImageAssets.meeting),
    CategoryDM(
        id: "4",
        name: "Gaming",
        icon: Icons.games_rounded,
        imagePath: ImageAssets.gaming),
    CategoryDM(
        id: "5",
        name: "Eating",
        icon: Icons.fastfood_rounded,
        imagePath: ImageAssets.eating),
    CategoryDM(
        id: "6",
        name: "Holiday",
        icon: Icons.holiday_village_rounded,
        imagePath: ImageAssets.holiday),
    CategoryDM(
        id: "7",
        name: "Exhibition",
        icon: Icons.water_drop_outlined,
        imagePath: ImageAssets.exhibition),
    CategoryDM(
        id: "8",
        name: "WorkShop",
        icon: Icons.workspaces_outlined,
        imagePath: ImageAssets.workshop)
  ];
}