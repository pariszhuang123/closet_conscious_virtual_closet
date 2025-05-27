part of 'swap_closet_bloc.dart';

abstract class SwapClosetEvent extends Equatable {
  const SwapClosetEvent();

  @override
  List<Object?> get props => [];
}

class FetchAllClosetsEvent extends SwapClosetEvent {}

class ConfirmClosetSwapEvent extends SwapClosetEvent {
  final String? currentClosetId;
  final String newClosetId;
  final List<String> selectedItemIds;
  final String? closetName;
  final String? closetType;
  final bool? isPublic;
  final DateTime? validDate;

  const ConfirmClosetSwapEvent({
    this.currentClosetId,
    required this.newClosetId,
    required this.selectedItemIds,
    this.closetName,
    this.closetType,
    this.isPublic,
    this.validDate,
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
