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

  EditMultiClosetValidate({
    required this.closetName,
    required this.closetType,
    required this.validDate,
    this.isPublic,
  });

  @override
  List<Object?> get props =>
      [closetName, closetType, isPublic, validDate];

}

class EditMultiClosetSwapped extends EditMultiClosetEvent {
  final String closetName;
  final String closetType;
  final bool? isPublic;
  final DateTime validDate;
  final List<String> itemIds;

  EditMultiClosetSwapped({
    required this.closetName,
    required this.closetType,
    this.isPublic,
    required this.validDate,
    required this.itemIds,
  });

  @override
  List<Object?> get props =>
      [closetName, closetType, isPublic, validDate, itemIds];
}

