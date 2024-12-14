part of 'swap_closet_bloc.dart';

abstract class SwapClosetEvent extends Equatable {
  const SwapClosetEvent();

  @override
  List<Object?> get props => [];
}

class FetchPermanentClosetsEvent extends SwapClosetEvent {}

class SelectNewClosetIdEvent extends SwapClosetEvent {
  final String newClosetId;

  const SelectNewClosetIdEvent(this.newClosetId);

  @override
  List<Object?> get props => [newClosetId];
}

class ConfirmClosetSwapEvent extends SwapClosetEvent {
  final String currentClosetId;
  final String newClosetId;
  final List<String> selectedItemIds;
  final String closetName;
  final String closetType;
  final bool isPublic;
  final DateTime validDate;

  const ConfirmClosetSwapEvent({
    required this.currentClosetId,
    required this.newClosetId,
    required this.selectedItemIds,
    required this.closetName,
    required this.closetType,
    required this.isPublic,
    required this.validDate,
  });

  @override
  List<Object?> get props => [
    currentClosetId,
    newClosetId,
    selectedItemIds,
    closetName,
    closetType,
    isPublic,
    validDate,
  ];
}
