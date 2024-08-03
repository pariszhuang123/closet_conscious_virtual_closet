part of 'create_outfit_item_bloc.dart';

enum SaveStatus { initial, success, failure, inProgress }

class CreateOutfitItemState extends Equatable {
  final Map<OutfitItemCategory, List<String>> selectedItemIds;
  final List<ClosetItemMinimal> items;
  final OutfitItemCategory? currentCategory;
  final SaveStatus saveStatus;

  const CreateOutfitItemState({
    this.selectedItemIds = const {},
    this.items = const [],
    this.currentCategory,
    this.saveStatus = SaveStatus.initial,
  });

  CreateOutfitItemState copyWith({
    Map<OutfitItemCategory, List<String>>? selectedItemIds,
    List<ClosetItemMinimal>? items,
    OutfitItemCategory? currentCategory,
    SaveStatus? saveStatus,
  }) {
    return CreateOutfitItemState(
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      items: items ?? this.items,
      currentCategory: currentCategory ?? this.currentCategory,
      saveStatus: saveStatus ?? this.saveStatus,
    );
  }

  @override
  List<Object?> get props => [selectedItemIds, items, currentCategory, saveStatus];
}
