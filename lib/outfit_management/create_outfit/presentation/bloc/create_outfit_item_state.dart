part of 'create_outfit_item_bloc.dart';

class CreateOutfitItemState extends Equatable {
  final Map<OutfitItemCategory, List<String>> selectedItemIds;
  final Map<OutfitItemCategory, List<ClosetItemMinimal>> categoryItems; // Store items per category
  final Map<OutfitItemCategory, int> categoryPages; // Track page per category
  final Map<OutfitItemCategory, bool> categoryHasReachedMax; // Track hasReachedMax per category
  final OutfitItemCategory currentCategory;
  final SaveStatus saveStatus;
  final String? outfitId;
  final bool hasSelectedItems;

  const CreateOutfitItemState({
    this.selectedItemIds = const {},
    this.categoryItems = const {},
    this.categoryPages = const {},
    this.categoryHasReachedMax = const {},
    required this.currentCategory,
    this.saveStatus = SaveStatus.initial,
    this.outfitId,
    this.hasSelectedItems = false,
  });

  factory CreateOutfitItemState.initial() {
    return const CreateOutfitItemState(
      selectedItemIds: {},
      categoryItems: {},
      categoryPages: {},
      categoryHasReachedMax: {},
      currentCategory: OutfitItemCategory.clothing, // Default category
      saveStatus: SaveStatus.initial,
      outfitId: null,
      hasSelectedItems: false,
    );
  }

  CreateOutfitItemState copyWith({
    Map<OutfitItemCategory, List<String>>? selectedItemIds,
    Map<OutfitItemCategory, List<ClosetItemMinimal>>? categoryItems,
    Map<OutfitItemCategory, int>? categoryPages,
    Map<OutfitItemCategory, bool>? categoryHasReachedMax,
    OutfitItemCategory? currentCategory,
    SaveStatus? saveStatus,
    String? outfitId,
    bool? hasSelectedItems,
  }) {
    return CreateOutfitItemState(
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      categoryItems: categoryItems ?? this.categoryItems,
      categoryPages: categoryPages ?? this.categoryPages,
      categoryHasReachedMax: categoryHasReachedMax ?? this.categoryHasReachedMax,
      currentCategory: currentCategory ?? this.currentCategory,
      saveStatus: saveStatus ?? this.saveStatus,
      outfitId: outfitId ?? this.outfitId,
      hasSelectedItems: hasSelectedItems ?? this.hasSelectedItems,
    );
  }

  // Get the current page for the selected category
  int get currentPage => categoryPages[currentCategory] ?? 0;

  // Get the hasReachedMax flag for the selected category
  bool get hasReachedMax => categoryHasReachedMax[currentCategory] ?? false;

  @override
  List<Object?> get props => [
    selectedItemIds,
    categoryItems,
    categoryPages,
    categoryHasReachedMax,
    currentCategory,
    saveStatus,
    outfitId,
    hasSelectedItems,
  ];
}
