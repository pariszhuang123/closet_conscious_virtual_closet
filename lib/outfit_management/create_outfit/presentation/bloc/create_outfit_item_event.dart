part of 'create_outfit_item_bloc.dart';

abstract class CreateOutfitItemEvent extends Equatable {
  const CreateOutfitItemEvent();

  @override
  List<Object?> get props => [];
}

class FetchMoreItemsEvent extends CreateOutfitItemEvent {}

class SelectCategoryEvent extends CreateOutfitItemEvent {
  final OutfitItemCategory category;

  const SelectCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}

