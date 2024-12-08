part of 'closet_metadata_validation_cubit.dart';

class ClosetMetadataValidationState {
  final String closetName;
  final String closetType;
  final bool? isPublic;
  final int? monthsLater;
  final Map<String, String>? errorKeys;

  ClosetMetadataValidationState({
    this.closetName = '',
    required this.closetType,
    this.isPublic,
    this.monthsLater,
    this.errorKeys,
  });

  ClosetMetadataValidationState copyWith({
    String? closetName,
    String? closetType,
    bool? isPublic,
    int? monthsLater,
    Map<String, String>? errorKeys,
  }) {
    return ClosetMetadataValidationState(
      closetName: closetName ?? this.closetName,
      closetType: closetType ?? this.closetType,
      isPublic: isPublic ?? this.isPublic,
      monthsLater: monthsLater ?? this.monthsLater,
      errorKeys: errorKeys ?? this.errorKeys,
    );
  }
}

