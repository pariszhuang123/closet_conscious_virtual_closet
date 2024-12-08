part of 'selection_item_cubit.dart';

class SelectionItemState extends Equatable {
  final List<String> selectedItemIds;
  final bool hasSelectedItems;

  const SelectionItemState({
    this.selectedItemIds = const [],
    this.hasSelectedItems = false,
  });

  SelectionItemState copyWith({
    List<String>? selectedItemIds,
    bool? hasSelectedItems,
  }) {
    return SelectionItemState(
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      hasSelectedItems: hasSelectedItems ?? this.hasSelectedItems,
    );
  }

  @override
  List<Object?> get props => [selectedItemIds, hasSelectedItems];
}

class SelectionItemLoaded extends SelectionItemState {
  const SelectionItemLoaded({
    required super.selectedItemIds,
    required super.hasSelectedItems,
  });
}
