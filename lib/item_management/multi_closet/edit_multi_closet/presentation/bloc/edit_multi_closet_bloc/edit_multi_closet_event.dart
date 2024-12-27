part of 'edit_multi_closet_bloc.dart';

abstract class EditMultiClosetEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditMultiClosetValidate extends EditMultiClosetEvent {
  final String closetName;
  final String closetType;
  final DateTime validDate;
  final bool? isPublic;
  final List<String>? itemIds;

  EditMultiClosetValidate({
    required this.closetName,
    required this.closetType,
    required this.validDate,
    this.isPublic,
    this.itemIds,
  });

  @override
  List<Object?> get props =>
      [closetName, closetType, isPublic, validDate, itemIds];

}

class EditMultiClosetUpdate extends EditMultiClosetEvent {
  final String closetName;
  final String closetType;
  final bool? isPublic;
  final DateTime? validDate;
  final String closetId;

  EditMultiClosetUpdate({
    required this.closetName,
    required this.closetType,
    this.isPublic,
    this.validDate,
    required this.closetId
  });

  @override
  List<Object?> get props =>
      [closetName, closetType, isPublic, validDate, closetId];
}

class EditMultiClosetSkipValidation extends EditMultiClosetEvent {}
