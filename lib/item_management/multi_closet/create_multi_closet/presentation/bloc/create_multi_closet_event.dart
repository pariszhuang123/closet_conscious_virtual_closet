part of 'create_multi_closet_bloc.dart';

abstract class CreateMultiClosetEvent extends Equatable {
  const CreateMultiClosetEvent();

  @override
  List<Object?> get props => [];
}

class FieldChanged extends CreateMultiClosetEvent {
  final String fieldName;
  final dynamic value;

  const FieldChanged(this.fieldName, this.value);

  @override
  List<Object?> get props => [fieldName, value];
}

class ToggleSelectItem extends CreateMultiClosetEvent {
  final String itemId;

  const ToggleSelectItem(this.itemId);

  @override
  List<Object?> get props => [itemId];
}

class ClearSelectedItems extends CreateMultiClosetEvent {}

class ValidateClosetDetails extends CreateMultiClosetEvent {}

class CreateMultiClosetRequested extends CreateMultiClosetEvent {}
