part of 'view_items_bloc.dart';

abstract class ViewItemsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchItemsEvent extends ViewItemsEvent {
  final int page;

  FetchItemsEvent(this.page);

  @override
  List<Object?> get props => [page]; // Add all fields for comparison
}
