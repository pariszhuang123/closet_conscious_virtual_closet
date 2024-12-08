part of 'closet_metadata_cubit.dart';

class ClosetMetadataState {
  final String closetName;
  final String closetType;
  final bool? isPublic; // Nullable to differentiate unselected
  final String? monthsLater;

  const ClosetMetadataState({
    required this.closetName,
    required this.closetType,
    this.isPublic,
    this.monthsLater,
  });

  // Factory constructor for initial/default state
  factory ClosetMetadataState.initial() => const ClosetMetadataState(
    closetName: '',
    closetType: 'permanent',
    isPublic: null,
    monthsLater: null,
  );

  // Create a copy of the current state with updated fields
  ClosetMetadataState copyWith({
    String? closetName,
    String? closetType,
    bool? isPublic,
    String? monthsLater,
  }) {
    return ClosetMetadataState(
      closetName: closetName ?? this.closetName,
      closetType: closetType ?? this.closetType,
      isPublic: isPublic ?? this.isPublic,
      monthsLater: monthsLater ?? this.monthsLater,
    );
  }

  @override
  String toString() {
    return 'ClosetMetadataState(closetName: $closetName, closetType: $closetType, isPublic: $isPublic, monthsLater: $monthsLater)';
  }
}
