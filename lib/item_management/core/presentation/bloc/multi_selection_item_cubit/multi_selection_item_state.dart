part of 'multi_selection_item_cubit.dart';

class MultiSelectionItemState extends Equatable {
  final List<String> selectedItemIds;
  final bool hasSelectedItems;

  const MultiSelectionItemState({
    this.selectedItemIds = const [],
    this.hasSelectedItems = false,
  });

  MultiSelectionItemState copyWith({
    List<String>? selectedItemIds,
    bool? hasSelectedItems,
  }) {
    return MultiSelectionItemState(
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      hasSelectedItems: hasSelectedItems ?? this.hasSelectedItems,
    );
  }

  @override
  List<Object?> get props => [selectedItemIds, hasSelectedItems];
}

class MultiSelectionItemLoaded extends MultiSelectionItemState {
  const MultiSelectionItemLoaded({
    required super.selectedItemIds,
    required super.hasSelectedItems,
  });
}
