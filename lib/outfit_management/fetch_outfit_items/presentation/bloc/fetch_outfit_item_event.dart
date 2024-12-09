part of 'fetch_outfit_item_bloc.dart';

abstract class FetchOutfitItemEvent extends Equatable {
  const FetchOutfitItemEvent();

  @override
  List<Object?> get props => [];
}

class FetchMoreItemsEvent extends FetchOutfitItemEvent {}

class SelectCategoryEvent extends FetchOutfitItemEvent {
  final OutfitItemCategory category;

  const SelectCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

