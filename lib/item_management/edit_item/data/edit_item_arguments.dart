import 'package:flutter/material.dart';

class EditItemArguments {
  final ThemeData myClosetTheme;
  final String itemId;
  final String initialName;
  final double initialAmountSpent;
  final String? initialImageUrl;
  final String? initialItemType;
  final String? initialSpecificType;
  final String? initialClothingLayer;
  final String? initialOccasion;
  final String? initialSeason;
  final String? initialColour;
  final String? initialColourVariation;
  final TextEditingController itemNameController;
  final TextEditingController amountSpentController;

  EditItemArguments({
    required this.myClosetTheme,
    required this.itemId,
    required this.initialName,
    required this.initialAmountSpent,
    this.initialImageUrl,
    this.initialItemType,
    this.initialSpecificType,
    this.initialClothingLayer,
    this.initialOccasion,
    this.initialSeason,
    this.initialColour,
    this.initialColourVariation,
    required this.itemNameController,
    required this.amountSpentController,
  });
}
