class ClosetMetadata {
  final String closetId;
  final String closetImage;
  final String closetType;
  final String closetName;
  final bool isPublic;
  final DateTime validDate;

  ClosetMetadata({
    required this.closetId,
    required this.closetImage,
    required this.closetType,
    required this.closetName,
    required this.isPublic,
    required this.validDate,
  });

  // Factory constructor to create an instance from a JSON object
  factory ClosetMetadata.fromJson(Map<String, dynamic> json) {
    return ClosetMetadata(
      closetId: json['closet_id'] as String,
      closetImage: json['closet_image'] as String,
      closetType: json['type'] as String,
      closetName: json['closet_name'] as String,
      isPublic: json['is_public'] as bool,
      validDate: DateTime.parse(json['valid_date'] as String),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'closet_id': closetId,
      'closet_image': closetImage,
      'type': closetType,
      'closet_name': closetName,
      'is_public': isPublic,
      'valid_date': validDate.toIso8601String(),
    };
  }
  ClosetMetadata copyWith({
    String? closetId,
    String? closetImage,
    String? closetType,
    String? closetName,
    bool? isPublic,
    DateTime? validDate,
  }) {
    return ClosetMetadata(
      closetId: closetId ?? this.closetId,
      closetImage: closetImage ?? this.closetImage,
      closetType: closetType ?? this.closetType,
      closetName: closetName ?? this.closetName,
      isPublic: isPublic ?? this.isPublic,
      validDate: validDate ?? this.validDate,
    );
  }
}
