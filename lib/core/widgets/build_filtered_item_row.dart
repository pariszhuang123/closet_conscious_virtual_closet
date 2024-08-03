import 'package:flutter/material.dart';
import '../../item_management/core/data/models/closet_item_minimal.dart';

List<Widget> buildFilteredItemRows(
    List<ClosetItemMinimal> items,
    List<String> selectedItems,
    void Function(String) onTap,
    BuildContext context,
    ) {
  List<Widget> rows = [];
  int index = 0;

  while (index < items.length) {
    int end = (index + 5) > items.length ? items.length : (index + 5);
    List<ClosetItemMinimal> rowItems = items.sublist(index, end);

    rows.add(
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowItems.map((item) {
          final key = item.itemId;
          return GestureDetector(
            onTap: () {
              onTap(key);
            },
            child: Card(
              shape: selectedItems.contains(key)
                  ? RoundedRectangleBorder(
                side: const BorderSide(color: Colors.green, width: 2.0),
                borderRadius: BorderRadius.circular(4.0),
              )
                  : null,
              child: Column(
                children: [
                  Image.network(item.imageUrl),
                  Text(item.name),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
    index = end;
  }
  return rows;
}
