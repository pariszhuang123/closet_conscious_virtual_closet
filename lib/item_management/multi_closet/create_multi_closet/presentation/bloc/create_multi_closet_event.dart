part of 'create_multi_closet_bloc.dart';

abstract class CreateMultiClosetEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateMultiClosetRequested extends CreateMultiClosetEvent {
  final String closetName;
  final String closetType;
  final bool? isPublic;
  final String? monthsLater;
  final List<String> itemIds;

  CreateMultiClosetRequested({
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
