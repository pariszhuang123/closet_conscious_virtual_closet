part of 'outfit_selection_bloc.dart';

abstract class OutfitSelectionState extends Equatable {
  const OutfitSelectionState();
  @override
  List<Object> get props => [];
}

class OutfitSelectionInitial extends OutfitSelectionState {}

class OutfitSelectionUpdated extends OutfitSelectionState {
  final List<String> selectedOutfitIds;
  const OutfitSelectionUpdated(this.selectedOutfitIds);

  @override
  List<Object> get props => [selectedOutfitIds];
}

class ActiveItemsLoading extends OutfitSelectionState {}

class ActiveItemsFetched extends OutfitSelectionState {
  final List<String> activeItemIds;
  const ActiveItemsFetched(this.activeItemIds);

  @override
  List<Object> get props => [activeItemIds];
}

class OutfitSelectionError extends OutfitSelectionState {
  final String message;
  const OutfitSelectionError(this.message);

  @override
  List<Object> get props => [message];
}
