part of 'create_outfit_item_bloc.dart';

enum OutfitItemCategory { clothing, accessory, shoes }

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

class TriggerNpsSurveyEvent extends CreateOutfitItemEvent {
  final int milestone;

  const TriggerNpsSurveyEvent(this.milestone);

  @override
  List<Object> get props => [milestone];
}

class SaveNpsSurveyResultEvent extends CreateOutfitItemEvent {
  final String userId;
  final int score;
  final int milestone;

  const SaveNpsSurveyResultEvent({
    required this.userId,
    required this.score,
    required this.milestone,
  });

  @override
  List<Object> get props => [userId, score, milestone];
}
