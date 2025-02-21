part of 'summary_items_bloc.dart';

abstract class SummaryItemsState extends Equatable {
  @override
  List<Object> get props => [];
}

class SummaryItemsInitial extends SummaryItemsState {}

class SummaryItemsLoading extends SummaryItemsState {}

class SummaryItemsLoaded extends SummaryItemsState {
  final int totalItems;
  final double totalItemCost;
  final double avgPricePerWear;

  SummaryItemsLoaded({
    required this.totalItems,
    required this.totalItemCost,
    required this.avgPricePerWear,
  });

  @override
  List<Object> get props => [totalItems, totalItemCost, avgPricePerWear];
}

class SummaryItemsError extends SummaryItemsState {
  final String message;

  SummaryItemsError(this.message);

  @override
  List<Object> get props => [message];
}
