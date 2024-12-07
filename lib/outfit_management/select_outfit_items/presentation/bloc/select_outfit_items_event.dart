part of 'select_outfit_items_bloc.dart';

abstract class SelectionOutfitItemsEvent extends Equatable {
  const SelectionOutfitItemsEvent();

  @override
  List<Object> get props => [];
}

class SetSelectedItemsEvent extends SelectionOutfitItemsEvent {
  final List<String> selectedItemIds;

  const SetSelectedItemsEvent(this.selectedItemIds);

  @override
  List<Object> get props => [selectedItemIds];
}

class ToggleSelectItemEvent extends SelectionOutfitItemsEvent {
  final String itemId;

  const ToggleSelectItemEvent(this.itemId);

  @override
  List<Object> get props => [itemId];
}

class ClearSelectedItemsEvent extends SelectionOutfitItemsEvent {}

class SaveOutfitEvent extends SelectionOutfitItemsEvent {}
