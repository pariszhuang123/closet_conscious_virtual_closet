part of 'related_outfits_cubit.dart';

abstract class RelatedOutfitsState {}

class RelatedOutfitsInitial extends RelatedOutfitsState {}

class RelatedOutfitsLoading extends RelatedOutfitsState {}

class RelatedOutfitsSuccess extends RelatedOutfitsState {
  final List<OutfitData> relatedOutfits;

  RelatedOutfitsSuccess(this.relatedOutfits);
}

class NoRelatedOutfitState extends RelatedOutfitsState {}

class RelatedOutfitsFailure extends RelatedOutfitsState {
  final String error;
  RelatedOutfitsFailure(this.error);
}
