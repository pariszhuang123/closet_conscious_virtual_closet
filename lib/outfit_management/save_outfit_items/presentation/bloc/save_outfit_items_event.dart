part of 'save_outfit_items_bloc.dart';

abstract class SaveOutfitItemsEvent extends Equatable {
  const SaveOutfitItemsEvent();

  @override
  List<Object> get props => [];
}

class SetSelectedItemsEvent extends SaveOutfitItemsEvent {
  final List<String> selectedItemIds;

  const SetSelectedItemsEvent(this.selectedItemIds);

  @override
  List<Object> get props => [selectedItemIds];
}

class ToggleSelectItemEvent extends SaveOutfitItemsEvent {
  final String itemId;

  const ToggleSelectItemEvent(this.itemId);

  @override
  List<Object> get props => [itemId];
}

class ClearSelectedItemsEvent extends SaveOutfitItemsEvent {}

class SaveOutfitEvent extends SaveOutfitItemsEvent {}
