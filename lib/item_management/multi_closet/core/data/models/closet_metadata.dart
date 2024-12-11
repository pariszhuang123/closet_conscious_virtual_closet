class ClosetMetadata {
  final String closetType;
  final String closetName;
  final bool isPublic;
  final DateTime validDate;

  ClosetMetadata({
    required this.closetType,
    required this.closetName,
    required this.isPublic,
    required this.validDate,
  });

  // Factory constructor to create an instance from a JSON object
  factory ClosetMetadata.fromJson(Map<String, dynamic> json) {
    return ClosetMetadata(
      closetType: json['type'] as String, // Adjust key if it's different in the response
      closetName: json['closet_name'] as String,
      isPublic: json['is_public'] as bool,
      validDate: DateTime.parse(json['valid_date'] as String),
    );
  }

  // Method to convert an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'type': closetType,
      'closet_name': closetName,
      'is_public': isPublic,
      'valid_date': validDate.toIso8601String(),
    };
  }
  ClosetMetadata copyWith({
    String? closetType,
    String? closetName,
    bool? isPublic,
    DateTime? validDate,
  }) {
    return ClosetMetadata(
      closetType: closetType ?? this.closetType,
      closetName: closetName ?? this.closetName,
      isPublic: isPublic ?? this.isPublic,
      validDate: validDate ?? this.validDate,
    );
  }
}
