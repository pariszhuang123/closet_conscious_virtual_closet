part of 'single_selection_outfit_cubit.dart';

class SingleSelectionOutfitState extends Equatable {
  final String? selectedOutfitId;

  const SingleSelectionOutfitState({this.selectedOutfitId});

  SingleSelectionOutfitState copyWith({String? selectedOutfitId}) {
    return SingleSelectionOutfitState(selectedOutfitId: selectedOutfitId);
  }

  @override
  List<Object?> get props => [selectedOutfitId];
}
