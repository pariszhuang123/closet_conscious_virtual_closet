part of 'view_items_bloc.dart';

abstract class ViewItemsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchItemsEvent extends ViewItemsEvent {
  final int page;
  final bool isPending;

  FetchItemsEvent(this.page, {required this.isPending});

  @override
  List<Object?> get props => [page, isPending]; // Add all fields for comparison
}
