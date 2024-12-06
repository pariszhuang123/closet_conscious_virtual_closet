part of 'create_multi_closet_bloc.dart';

class CreateMultiClosetState extends Equatable {
  final ClosetStatus status;
  final String closetName;
  final String closetType; // 'permanent' or 'temporary'
  final bool? isPublic;
  final int? monthsLater;
  final List<String> selectedItemIds;
  final bool hasSelectedItems;
  final Map<String, String>? errorKeys;
  final String? error;

  const CreateMultiClosetState({
    this.status = ClosetStatus.initial,
    this.closetName = '',
    this.closetType = 'permanent',
    this.isPublic,
    this.monthsLater,
    this.selectedItemIds = const [],
    this.hasSelectedItems = false,
    this.errorKeys,
    this.error,
  });

  CreateMultiClosetState copyWith({
    ClosetStatus? status,
    String? closetName,
    String? closetType,
    bool? isPublic,
    int? monthsLater,
    List<String>? selectedItemIds,
    bool? hasSelectedItems,
    Map<String, String>? errorKeys,
    String? error,
  }) {
    return CreateMultiClosetState(
      status: status ?? this.status,
      closetName: closetName ?? this.closetName,
      closetType: closetType ?? this.closetType,
      isPublic: isPublic ?? this.isPublic,
      monthsLater: monthsLater ?? this.monthsLater,
      selectedItemIds: selectedItemIds ?? this.selectedItemIds,
      hasSelectedItems: hasSelectedItems ?? this.hasSelectedItems,
      errorKeys: errorKeys,
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [status, closetName, closetType, isPublic, monthsLater, selectedItemIds, hasSelectedItems, errorKeys, error];
}
