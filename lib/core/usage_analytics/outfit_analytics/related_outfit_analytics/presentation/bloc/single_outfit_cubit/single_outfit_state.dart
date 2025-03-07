part of 'single_outfit_cubit.dart';

abstract class SingleOutfitState {}

class FetchOutfitInitial extends SingleOutfitState {}

class FetchOutfitLoading extends SingleOutfitState {}

class FetchOutfitSuccess extends SingleOutfitState {
  final OutfitData outfit;
  FetchOutfitSuccess(this.outfit);
}

class FetchOutfitFailure extends SingleOutfitState {
  final String error;
  FetchOutfitFailure(this.error);
}
