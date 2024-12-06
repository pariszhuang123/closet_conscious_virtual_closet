import 'package:equatable/equatable.dart';

class MultiCloset extends Equatable {
  final String closetId;
  final String closetName;
  final String closetImage;

  const MultiCloset({
    required this.closetId,
    required this.closetName,
    required this.closetImage,
  });

  factory MultiCloset.fromMap(Map<String, dynamic> map) {
    return MultiCloset(
      closetId: map['closet_id'] as String,
      closetName: map['closet_name'] as String,
      closetImage: map['closet_image'] as String,
    );
  }

  MultiCloset copyWith({
    String? closetName,
  }) {
    return MultiCloset(
      closetId: closetId,
      closetName: closetName ?? this.closetName,
      closetImage: closetImage,
    );
  }

  @override
  List<Object?> get props => [closetId, closetName, closetImage];
}
