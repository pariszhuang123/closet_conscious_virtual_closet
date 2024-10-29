import 'package:flutter/material.dart';

import '../../core_enums.dart';
import '../button/text_type_button.dart';
import '../../data/type_data.dart';

List<Widget> buildIconRows(
    List<TypeData> typeDataList,
    String? selectedKey,
    void Function(String) onTap,
    BuildContext context,
    bool isFromMyCloset,
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
            key: UniqueKey(), // Use a unique key for each button instance
            dataKey: key,
            selectedKey: selectedKey ?? '',
            label: label,
            assetPath: type.assetPath,
            isSelected: selectedKey == key,
            isFromMyCloset: isFromMyCloset,
            buttonType: ButtonType.primary,
            usePredefinedColor: type.usePredefinedColor,
            onPressed: () {
              onTap(key);
            },
          );
        }).toList(),
      ),
    );
    index += iconsInRow;
  }
  return rows;
}
