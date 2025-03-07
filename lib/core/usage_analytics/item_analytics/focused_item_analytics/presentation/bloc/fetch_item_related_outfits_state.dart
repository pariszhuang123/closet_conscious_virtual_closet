part of 'fetch_item_related_outfits_cubit.dart';

abstract class FetchItemRelatedOutfitsState {}

class FetchItemRelatedOutfitsInitial extends FetchItemRelatedOutfitsState {}

class FetchItemRelatedOutfitsLoading extends FetchItemRelatedOutfitsState {}

class FetchItemRelatedOutfitsSuccess extends FetchItemRelatedOutfitsState {
  final List<OutfitData> outfits;
  FetchItemRelatedOutfitsSuccess(this.outfits);
}

class NoItemRelatedOutfitsState extends FetchItemRelatedOutfitsState {}

class FetchItemRelatedOutfitsFailure extends FetchItemRelatedOutfitsState {
  final String message;
  FetchItemRelatedOutfitsFailure(this.message);
}
