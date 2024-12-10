part of 'edit_multi_closet_bloc.dart';

abstract class EditMultiClosetEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditMultiClosetValidate extends EditMultiClosetEvent {
  final String closetName;
  final String closetType;
  final String? monthsLater;
  final bool? isPublic;

  EditMultiClosetValidate({
    required this.closetName,
    required this.closetType,
    this.monthsLater,
    this.isPublic,
  });

  @override
  List<Object?> get props =>
      [closetName, closetType, isPublic, monthsLater];

}

class EditMultiClosetSwapped extends EditMultiClosetEvent {
  final String closetName;
  final String closetType;
  final bool? isPublic;
  final String? monthsLater;
  final List<String> itemIds;

  EditMultiClosetSwapped({
    required this.closetName,
    required this.closetType,
    this.isPublic,
    this.monthsLater,
    required this.itemIds,
  });

  @override
  List<Object?> get props =>
      [closetName, closetType, isPublic, monthsLater, itemIds];
}

