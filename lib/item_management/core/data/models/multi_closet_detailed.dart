import 'package:equatable/equatable.dart';

class MultiClosetDetailed extends Equatable {
  final String? closetId; // Nullable for creation
  final String closetName;
  final String closetType; // 'permanent' or 'disappear'
  final bool isPublic; // Nullable for edit cases
  final int? monthsLater; // Applicable for disappearing closets
  final DateTime? validDate; // Can be calculated dynamically or chosen by the user
  final String? closetImage; // Optional for creation or editing

  const MultiClosetDetailed({
    this.closetId,
    required this.closetName,
    required this.closetType,
    required this.isPublic,
    this.monthsLater,
    this.validDate,
    this.closetImage,
  });

  factory MultiClosetDetailed.fromMap(Map<String, dynamic> map) {
    return MultiClosetDetailed(
      closetId: map['closet_id'] as String?,
      closetName: map['closet_name'] as String,
      closetType: map['closet_type'] as String,
      isPublic: map['is_public'] as bool,
      monthsLater: map['months_later'] as int?,
      validDate: map['valid_date'] != null
          ? DateTime.parse(map['valid_date'] as String)
          : null,
      closetImage: map['closet_image'] as String?,
    );
  }

  MultiClosetDetailed copyWith({
    String? closetId,
    String? closetName,
    String? closetType,
    bool? isPublic,
    int? monthsLater,
    DateTime? validDate,
    String? closetImage,
  }) {
    return MultiClosetDetailed(
      closetId: closetId ?? this.closetId,
      closetName: closetName ?? this.closetName,
      closetType: closetType ?? this.closetType,
      isPublic: isPublic ?? this.isPublic,
      monthsLater: monthsLater ?? this.monthsLater,
      validDate: validDate ?? this.validDate,
      closetImage: closetImage ?? this.closetImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'closet_id': closetId,
      'closet_name': closetName,
      'closet_type': closetType,
      'is_public': isPublic,
      'months_later': monthsLater,
      'valid_date': validDate?.toIso8601String(),
      'closet_image': closetImage,
    };
  }

  @override
  List<Object?> get props =>
      [closetId, closetName, closetType, isPublic, monthsLater, validDate, closetImage];
}
