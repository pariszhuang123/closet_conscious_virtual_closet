part of 'single_selection_closet_cubit.dart';

class SingleSelectionClosetState extends Equatable {
  final String? selectedClosetId;

  const SingleSelectionClosetState({this.selectedClosetId});

  SingleSelectionClosetState copyWith({String? selectedClosetId}) {
    return SingleSelectionClosetState(selectedClosetId: selectedClosetId);
  }

  @override
  List<Object?> get props => [selectedClosetId];
}
