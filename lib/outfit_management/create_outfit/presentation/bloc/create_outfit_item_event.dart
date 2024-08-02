part of 'create_outfit_item_bloc.dart';

enum OutfitItemCategory { clothing, accessory, shoes }

class CreateOutfitItemEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectItemEvent extends CreateOutfitItemEvent {
  final OutfitItemCategory category;
  final String itemId;
  final int position;
  final int limit;

  SelectItemEvent(this.category, this.itemId, this.position, this.limit);

  @override
  List<Object?> get props => [category, itemId, position, limit];
}

class SaveOutfitEvent extends CreateOutfitItemEvent {
  final Map<OutfitItemCategory, List<String>> selectedItemIds;

  SaveOutfitEvent(this.selectedItemIds);

  @override
  List<Object?> get props => [selectedItemIds];
}
