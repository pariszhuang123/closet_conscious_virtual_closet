part of 'create_outfit_item_bloc.dart';

enum SaveStatus { initial, success, failure }

class CreateOutfitItemState extends Equatable {
  final Map<OutfitItemCategory, List<String>> selectedItemIds;
  final List<Item> items;
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
    List<Item>? items,
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

class Item extends Equatable {
  final String itemId;
  final String imageUrl;
  final String name;

  const Item({required this.itemId, required this.imageUrl, required this.name});

  @override
  List<Object?> get props => [itemId, imageUrl, name];
}
