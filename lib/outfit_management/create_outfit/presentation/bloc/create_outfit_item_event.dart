part of 'create_outfit_item_bloc.dart';

enum OutfitItemCategory { clothing, accessory, shoes }

abstract class CreateOutfitItemEvent extends Equatable {
  const CreateOutfitItemEvent();

  @override
  List<Object?> get props => [];
}

class SelectItemEvent extends CreateOutfitItemEvent {
  final OutfitItemCategory category;
  final String itemId;

  const SelectItemEvent(this.category, this.itemId);

  @override
  List<Object?> get props => [category, itemId];
}

class DeselectItemEvent extends CreateOutfitItemEvent {
  final OutfitItemCategory category;
  final String itemId;

  const DeselectItemEvent(this.category, this.itemId);

  @override
  List<Object?> get props => [category, itemId];
}

class SaveOutfitEvent extends CreateOutfitItemEvent {
  const SaveOutfitEvent();

  @override
  List<Object?> get props => [];
}

class SelectCategoryEvent extends CreateOutfitItemEvent {
  final OutfitItemCategory category;

  const SelectCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}
