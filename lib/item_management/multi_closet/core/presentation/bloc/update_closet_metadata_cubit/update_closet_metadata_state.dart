part of 'update_closet_metadata_cubit.dart';

class UpdateClosetMetadataState {
  final String closetName;
  final String closetType;
  final bool? isPublic; // Nullable to differentiate unselected
  final String? monthsLater;

  const UpdateClosetMetadataState({
    required this.closetName,
    required this.closetType,
    this.isPublic,
    this.monthsLater,
  });

  // Factory constructor for initial/default state
  factory UpdateClosetMetadataState.initial() => const UpdateClosetMetadataState(
    closetName: '',
    closetType: 'permanent',
    isPublic: null,
    monthsLater: null,
  );

  // Create a copy of the current state with updated fields
  UpdateClosetMetadataState copyWith({
    String? closetName,
    String? closetType,
    bool? isPublic,
    String? monthsLater,
  }) {
    return UpdateClosetMetadataState(
      closetName: closetName ?? this.closetName,
      closetType: closetType ?? this.closetType,
      isPublic: isPublic ?? this.isPublic,
      monthsLater: monthsLater ?? this.monthsLater,
    );
  }

  @override
  String toString() {
    return 'UpdateClosetMetadataState(closetName: $closetName, closetType: $closetType, isPublic: $isPublic, monthsLater: $monthsLater)';
  }
}
