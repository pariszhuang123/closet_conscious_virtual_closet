part of 'create_outfit_item_bloc.dart';

class CreateOutfitItemState extends Equatable {
  final Map<OutfitItemCategory, List<String>> selectedItemIds;
  final List<ClosetItemMinimal> items;
  final OutfitItemCategory currentCategory; // Made non-nullable
  final SaveStatus saveStatus;
  final String? outfitId;
  final bool hasSelectedItems;
  final bool hasReachedMax;
  final int currentPage;


  const CreateOutfitItemState({
    this.selectedItemIds = const {},
    this.items = const [],
    required this.currentCategory, // Required in constructor
    this.saveStatus = SaveStatus.initial,
    this.outfitId,
    this.hasSelectedItems = false,
    required this.hasReachedMax,
    required this.currentPage,

  });

  factory CreateOutfitItemState.initial() {
    return const CreateOutfitItemState(
      selectedItemIds: {},
      items: [],
      currentCategory: OutfitItemCategory.clothing, // Default value set here
      saveStatus: SaveStatus.initial,
      outfitId: null,
      hasSelectedItems: false,
      hasReachedMax: false,
      currentPage: 0,
    );
  }

  CreateOutfitItemState copyWith({
    Map<OutfitItemCategory, List<String>>? selectedItemIds,
    List<ClosetItemMinimal>? items,
    OutfitItemCategory? currentCategory, // Allow nullable input here for convenience
    SaveStatus? saveStatus,
    String? outfitId,
    bool? hasSelectedItems,
    bool? hasReachedMax,
    int? currentPage,

  }) {
    return CreateOutfitItemState(
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      items: items ?? this.items,
      currentCategory: currentCategory ?? this.currentCategory, // Default to the current value if null
      saveStatus: saveStatus ?? this.saveStatus,
      outfitId: outfitId ?? this.outfitId,
      hasSelectedItems: hasSelectedItems ?? this.hasSelectedItems,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props => [selectedItemIds, items, currentCategory, saveStatus, outfitId, hasSelectedItems, hasReachedMax, currentPage];
}

