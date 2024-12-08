part of 'selection_item_cubit.dart';

class SelectionItemState {
  final List<String> selectedItemIds;
  final bool hasSelectedItems;

  SelectionItemState({this.selectedItemIds = const [], this.hasSelectedItems = false});

  SelectionItemState copyWith({
    List<String>? selectedItemIds,
    bool? hasSelectedItems,
  }) {
    return SelectionItemState(
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      hasSelectedItems: hasSelectedItems ?? this.hasSelectedItems,
    );
  }
}

