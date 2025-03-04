import 'package:equatable/equatable.dart';

class MultiClosetMinimal extends Equatable {
  final String closetId;
  final String closetName;
  final String closetImage;

  const MultiClosetMinimal({
    required this.closetId,
    required this.closetName,
    required this.closetImage,
  });

  factory MultiClosetMinimal.fromMap(Map<String, dynamic> map) {
    return MultiClosetMinimal(
      closetId: map['closet_id'] as String,
      closetName: map['closet_name'] as String,
      closetImage: map['closet_image'] as String,
    );
  }

  MultiClosetMinimal copyWith({
    String? closetName,
  }) {
    return MultiClosetMinimal(
      closetId: closetId,
      closetName: closetName ?? this.closetName,
      closetImage: closetImage,
    );
  }

  @override
  List<Object?> get props => [closetId, closetName, closetImage];
}
