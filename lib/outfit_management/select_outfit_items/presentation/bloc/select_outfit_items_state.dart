part of 'select_outfit_items_bloc.dart';

class SelectionOutfitItemsState extends Equatable {
  final List<String> selectedItemIds; // Now a flat list of selected item IDs
  final bool hasSelectedItems;
  final SaveStatus saveStatus; // Still using SaveStatus from outfit_enums.dart
  final String? outfitId; // Stores the outfit ID if save is successful

  const SelectionOutfitItemsState({
    required this.selectedItemIds,
    required this.hasSelectedItems,
    this.saveStatus = SaveStatus.initial,
    this.outfitId,
  });

  // Factory method for the initial state
  factory SelectionOutfitItemsState.initial() {
    return const SelectionOutfitItemsState(
      selectedItemIds: [], // Now an empty list instead of a map
      hasSelectedItems: false,
      saveStatus: SaveStatus.initial,
      outfitId: null,
    );
  }

  // CopyWith method for updating state
  SelectionOutfitItemsState copyWith({
    List<String>? selectedItemIds,
    bool? hasSelectedItems,
    SaveStatus? saveStatus,
    String? outfitId,
  }) {
    return SelectionOutfitItemsState(
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      hasSelectedItems: hasSelectedItems ?? this.hasSelectedItems,
      saveStatus: saveStatus ?? this.saveStatus,
      outfitId: outfitId ?? this.outfitId,
    );
  }

  @override
  List<Object?> get props => [selectedItemIds, hasSelectedItems, saveStatus, outfitId];
}
