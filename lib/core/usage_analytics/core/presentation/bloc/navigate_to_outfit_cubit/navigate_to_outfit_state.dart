part of 'navigate_to_outfit_cubit.dart';

abstract class NavigateToOutfitState {}

class NavigateToOutfitInitial extends NavigateToOutfitState {}

class NavigateToOutfitLoading extends NavigateToOutfitState {}

class NavigateToOutfitSuccess extends NavigateToOutfitState {}

class NavigateToOutfitFailure extends NavigateToOutfitState {
  final String error;
  NavigateToOutfitFailure(this.error);
}
