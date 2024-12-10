part of 'single_selection_item_cubit.dart';

class SingleSelectionItemState extends Equatable {
  final String? selectedItemId;

  const SingleSelectionItemState({this.selectedItemId});

  SingleSelectionItemState copyWith({String? selectedItemId}) {
    return SingleSelectionItemState(selectedItemId: selectedItemId);
  }

  @override
  List<Object?> get props => [selectedItemId];
}
