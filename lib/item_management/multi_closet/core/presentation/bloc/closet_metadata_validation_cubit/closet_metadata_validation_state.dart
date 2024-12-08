part of 'closet_metadata_validation_cubit.dart';

class ClosetMetadataValidationState {
  final Map<String, String>? errorKeys;

  const ClosetMetadataValidationState({this.errorKeys});

  factory ClosetMetadataValidationState.initial() => const ClosetMetadataValidationState();

  ClosetMetadataValidationState copyWith({Map<String, String>? errorKeys}) {
    return ClosetMetadataValidationState(
      errorKeys: errorKeys ?? this.errorKeys,
    );
  }

  bool get isValid => errorKeys == null || errorKeys!.isEmpty;

  @override
  String toString() {
    return 'ClosetMetadataValidationState(errorKeys: $errorKeys)';
  }
}
