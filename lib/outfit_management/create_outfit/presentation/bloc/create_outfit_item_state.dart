part of 'create_outfit_item_bloc.dart';

enum SaveStatus { initial, success, failure, inProgress }

class CreateOutfitItemState extends Equatable {
  final Map<OutfitItemCategory, List<String>> selectedItemIds;
  final List<ClosetItemMinimal> items;
  final OutfitItemCategory? currentCategory;
  final SaveStatus saveStatus;
  final String? outfitId;

  const CreateOutfitItemState({
    this.selectedItemIds = const {},
    this.items = const [],
    this.currentCategory,
    this.saveStatus = SaveStatus.initial,
    this.outfitId,
  });

  factory CreateOutfitItemState.initial() {
    return const CreateOutfitItemState(
      selectedItemIds: {},
      items: [],
      currentCategory: OutfitItemCategory.clothing, // Set default category if needed
      saveStatus: SaveStatus.initial,
      outfitId: null,
    );
  }

  CreateOutfitItemState copyWith({
    Map<OutfitItemCategory, List<String>>? selectedItemIds,
    List<ClosetItemMinimal>? items,
    OutfitItemCategory? currentCategory,
    SaveStatus? saveStatus,
    String? outfitId, // Add outfitId to the copyWith method
  }) {
    return CreateOutfitItemState(
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      items: items ?? this.items,
      currentCategory: currentCategory ?? this.currentCategory,
      saveStatus: saveStatus ?? this.saveStatus,
      outfitId: outfitId ?? this.outfitId, // Assign the new outfitId if provided
    );
  }

  @override
  List<Object?> get props => [selectedItemIds, items, currentCategory, saveStatus, outfitId];
}
