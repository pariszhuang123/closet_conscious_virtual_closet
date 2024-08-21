part of 'create_outfit_item_bloc.dart';

enum SaveStatus { initial, success, failure, inProgress }

class CreateOutfitItemState extends Equatable {
  final Map<OutfitItemCategory, List<String>> selectedItemIds;
  final List<ClosetItemMinimal> items;
  final OutfitItemCategory currentCategory; // Made non-nullable
  final SaveStatus saveStatus;
  final String? outfitId;
  final bool hasSelectedItems;

  const CreateOutfitItemState({
    this.selectedItemIds = const {},
    this.items = const [],
    required this.currentCategory, // Required in constructor
    this.saveStatus = SaveStatus.initial,
    this.outfitId,
    this.hasSelectedItems = false,
  });

  factory CreateOutfitItemState.initial() {
    return const CreateOutfitItemState(
      selectedItemIds: {},
      items: [],
      currentCategory: OutfitItemCategory.clothing, // Default value set here
      saveStatus: SaveStatus.initial,
      outfitId: null,
      hasSelectedItems: false,
    );
  }

  CreateOutfitItemState copyWith({
    Map<OutfitItemCategory, List<String>>? selectedItemIds,
    List<ClosetItemMinimal>? items,
    OutfitItemCategory? currentCategory, // Allow nullable input here for convenience
    SaveStatus? saveStatus,
    String? outfitId,
    bool? hasSelectedItems,
  }) {
    return CreateOutfitItemState(
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      items: items ?? this.items,
      currentCategory: currentCategory ?? this.currentCategory, // Default to the current value if null
      saveStatus: saveStatus ?? this.saveStatus,
      outfitId: outfitId ?? this.outfitId,
      hasSelectedItems: hasSelectedItems ?? this.hasSelectedItems,
    );
  }

  @override
  List<Object?> get props => [selectedItemIds, items, currentCategory, saveStatus, outfitId, hasSelectedItems];
}

class NpsSurveyTriggered extends CreateOutfitItemState {
  final int milestone;

  const NpsSurveyTriggered({
    required this.milestone,
  }) : super(
    currentCategory: OutfitItemCategory.clothing, // Use default value
    selectedItemIds: const {},
    items: const [],
    saveStatus: SaveStatus.initial,
    outfitId: null,
    hasSelectedItems: false,
  );
}
