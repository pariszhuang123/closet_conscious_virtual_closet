part of 'create_outfit_item_bloc.dart';

abstract class CreateOutfitItemEvent extends Equatable {
  const CreateOutfitItemEvent();

  @override
  List<Object?> get props => [];
}

class ToggleSelectItemEvent extends CreateOutfitItemEvent {
  final OutfitItemCategory category;
  final String itemId;

  const ToggleSelectItemEvent(this.category, this.itemId);

  @override
  List<Object> get props => [category, itemId];
}

class FetchMoreItemsEvent extends CreateOutfitItemEvent {}

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

