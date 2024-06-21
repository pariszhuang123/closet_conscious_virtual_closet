import 'package:flutter/material.dart';
import '../../core/data/models/closet_item_detailed.dart';

class EditItemArguments {
  final ClosetItemDetailed item;
  final ThemeData myClosetTheme;

  EditItemArguments({required this.item, required this.myClosetTheme});
}
