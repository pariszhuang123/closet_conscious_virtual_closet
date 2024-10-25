part of 'view_items_bloc.dart';

abstract class ViewItemsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchItemsEvent extends ViewItemsEvent {
  final int page;
  final int batchSize;

  FetchItemsEvent(this.page, this.batchSize);

  @override
  List<Object?> get props => [page, batchSize]; // Add all fields for comparison
}
