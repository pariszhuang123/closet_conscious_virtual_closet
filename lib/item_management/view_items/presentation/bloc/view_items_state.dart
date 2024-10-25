part of 'view_items_bloc.dart';

abstract class ViewItemsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ItemsLoading extends ViewItemsState {}

class ItemsLoaded extends ViewItemsState {
  final List<ClosetItemMinimal> items;
  final int currentPage;

  ItemsLoaded(this.items, this.currentPage);

  @override
  List<Object> get props => [items, currentPage];
}

class ItemsError extends ViewItemsState {
  final String error;

  ItemsError(this.error);

  @override
  List<Object?> get props => [error];
}
