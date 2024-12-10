part of 'single_selection_cubit.dart';

class SingleSelectionState extends Equatable {
  final String? selectedItemId;

  const SingleSelectionState({this.selectedItemId});

  SingleSelectionState copyWith({String? selectedItemId}) {
    return SingleSelectionState(selectedItemId: selectedItemId);
  }

  @override
  List<Object?> get props => [selectedItemId];
}
