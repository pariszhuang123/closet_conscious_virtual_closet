part of 'outfit_selection_bloc.dart';

abstract class OutfitSelectionEvent extends Equatable {
  const OutfitSelectionEvent();

  @override
  List<Object> get props => [];
}
class BulkToggleOutfitSelectionEvent extends OutfitSelectionEvent {
  final List<String> outfitIds;
  const BulkToggleOutfitSelectionEvent(this.outfitIds);

  @override
  List<Object> get props => [outfitIds];
}

class ToggleOutfitSelectionEvent extends OutfitSelectionEvent {
  final String outfitId;
  const ToggleOutfitSelectionEvent(this.outfitId);

  @override
  List<Object> get props => [outfitId];
}

class ClearOutfitSelectionEvent extends OutfitSelectionEvent {} // Reset selection

class SelectAllOutfitsEvent extends OutfitSelectionEvent {
  final List<String> allOutfitIds;

  const SelectAllOutfitsEvent(this.allOutfitIds);

  @override
  List<Object> get props => [allOutfitIds];
}

class FetchActiveItemsEvent extends OutfitSelectionEvent {
  final List<String> selectedOutfitIds;
  const FetchActiveItemsEvent(this.selectedOutfitIds);

  @override
  List<Object> get props => [selectedOutfitIds];
}

