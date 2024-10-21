part of 'outfit_wear_bloc.dart';

abstract class OutfitWearEvent extends Equatable {
  const OutfitWearEvent();

  @override
  List<Object?> get props => [];
}

class LoadOutfitItems extends OutfitWearEvent {}

class TakeSelfie extends OutfitWearEvent {
  final String outfitId;

  const TakeSelfie(this.outfitId);

  @override
  List<Object?> get props => [outfitId];
}

class ShareOutfit extends OutfitWearEvent {}

class NavigateToStyleOn extends OutfitWearEvent {}

class CheckForOutfitImageUrl extends OutfitWearEvent {
  final String outfitId;

  const CheckForOutfitImageUrl(this.outfitId);

  @override
  List<Object> get props => [outfitId];
}

class ConfirmOutfitCreation extends OutfitWearEvent {
  final String outfitId;
  final String? eventName;

  const ConfirmOutfitCreation({
    required this.outfitId,
    this.eventName,
  });
}
