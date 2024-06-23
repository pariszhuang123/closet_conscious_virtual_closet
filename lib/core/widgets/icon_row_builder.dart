import 'package:flutter/material.dart';
import '../widgets/button/text_type_button.dart';
import '../data/type_data.dart';

List<Widget> buildIconRows(
    List<TypeData> typeDataList,
    String? selectedLabel,
    void Function(String) onTap,
    BuildContext context,
    ) {
  List<Widget> rows = [];
  int index = 0;
  while (index < typeDataList.length) {
    int end = (index + 5) > typeDataList.length ? typeDataList.length : (index + 5);
    List<TypeData> rowIcons = typeDataList.sublist(index, end);
    rows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowIcons.map((type) {
          final label = type.getName(context);
          return TextTypeButton(
            label: label,
            selectedLabel: selectedLabel ?? '',
            imageUrl: type.imageUrl!,
            isSelected: selectedLabel == label,
            onPressed: () {
              onTap(label);
            },
          );
        }).toList(),
      ),
    );
    index = end;
  }
  return rows;
}