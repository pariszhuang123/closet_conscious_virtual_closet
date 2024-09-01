import 'package:flutter/material.dart';

import '../theme/themed_svg.dart';
import '../widgets/button/text_type_button.dart';
import '../data/type_data.dart';

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
    int end = (index + 5) > typeDataList.length ? typeDataList.length : (index + 5);
    List<TypeData> rowIcons = typeDataList.sublist(index, end);

    rows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rowIcons.map((type) {
          final key = type.key;
          final label = type.getName(context);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0.0), // Add horizontal padding
            child: TextTypeButton(
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
            ),
          );
        }).toList(),
      ),
    );
    index = end;
  }
  return rows;
}