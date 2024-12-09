part of 'save_outfit_items_bloc.dart';

abstract class SaveOutfitItemsEvent extends Equatable {
  const SaveOutfitItemsEvent();

  @override
  List<Object> get props => [];
}

class SaveOutfitEvent extends SaveOutfitItemsEvent {
  final List<String> selectedItemIds;

  const SaveOutfitEvent(this.selectedItemIds);

  @override
  List<Object> get props => [selectedItemIds];
}
