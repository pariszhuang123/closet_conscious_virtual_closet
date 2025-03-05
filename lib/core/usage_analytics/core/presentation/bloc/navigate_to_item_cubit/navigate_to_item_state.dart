part of 'navigate_to_item_cubit.dart';

abstract class NavigateToItemState {}

class NavigateToItemInitial extends NavigateToItemState {}

class NavigateToItemLoading extends NavigateToItemState {}

class NavigateToItemSuccess extends NavigateToItemState {}

class NavigateToItemFailure extends NavigateToItemState {
  final String error;
  NavigateToItemFailure(this.error);
}
