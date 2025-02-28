part of 'filtered_outfits_cubit.dart';

abstract class FilteredOutfitsState {}
class FilteredOutfitsInitial extends FilteredOutfitsState {}
class FilteredOutfitsLoading extends FilteredOutfitsState {}
class FilteredOutfitsSuccess extends FilteredOutfitsState {
  final List<OutfitData> outfits;
  FilteredOutfitsSuccess(this.outfits);
}
class FilteredOutfitsFailure extends FilteredOutfitsState {
  final String message;
  FilteredOutfitsFailure(this.message);
}

