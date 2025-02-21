part of 'summary_items_bloc.dart';

abstract class SummaryItemsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchSummaryItemEvent extends SummaryItemsEvent {}


