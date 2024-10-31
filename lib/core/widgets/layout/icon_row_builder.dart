import 'package:flutter/material.dart';

import '../../core_enums.dart';
import '../button/text_type_button.dart';
import '../../data/type_data.dart';

List<Widget> buildIconRows(
    List<TypeData> typeDataList,
    List<String> selectedKeys,  // Holds selected values
    void Function(String) onTap,
    BuildContext context,
    bool isFromMyCloset,
    bool allowMultiSelection,  // New parameter for selection mode
    ) {
  List<Widget> rows = [];
  int index = 0;

  while (index < typeDataList.length) {
    // Determine the number of icons for the current row based on remaining items
    int remainingItems = typeDataList.length - index;
    int iconsInRow;

    if (remainingItems == 6) {
      iconsInRow = 3; // 3 + 3 layout for 6 items
    } else if (remainingItems == 7) {
      iconsInRow = 4; // 4 + 3 layout for 7 items
    } else {
      iconsInRow = remainingItems > 5 ? 5 : remainingItems; // Default case, max 5 per row
    }

    // Get the subset of icons for this row
    List<TypeData> rowIcons = typeDataList.sublist(index, index + iconsInRow);

    rows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowIcons.map((type) {
          final key = type.key;
          final label = type.getName(context);

          return TextTypeButton(
            key: UniqueKey(),
            dataKey: key,
            selectedKeys: selectedKeys,
            label: label,
            assetPath: type.assetPath,
            isFromMyCloset: isFromMyCloset,
            buttonType: ButtonType.primary,
            usePredefinedColor: type.usePredefinedColor,
            onPressed: () {
              // Handle selection based on single or multi-select mode
              List<String> updatedSelectedKeys = List.from(selectedKeys);
              if (allowMultiSelection) {
                if (updatedSelectedKeys.contains(key)) {
                  updatedSelectedKeys.remove(key); // Deselect
                } else {
                  updatedSelectedKeys.add(key); // Select
                }
              } else {
                updatedSelectedKeys = [key]; // Single-select mode
              }
              onTap(key); // Trigger the callback to update state with the new selection
            },
          );
        }).toList(),
      ),
    );
    index += iconsInRow;
  }
  return rows;
}
