import 'package:equatable/equatable.dart';

class ClosetItemMinimal extends Equatable {
  final String itemId;
  final String imageUrl;
  final String name;
  final String? itemType;
  final bool isDisliked;  // Keep nullable internally

  const ClosetItemMinimal({
    required this.itemId,
    required this.imageUrl,
    required this.name,
    this.itemType,
    this.isDisliked = false,
  });

  factory ClosetItemMinimal.fromMap(Map<String, dynamic> map) {
    return ClosetItemMinimal(
      itemId: map['item_id'] as String,
      imageUrl: map['image_url'] as String,
      name: map['name'] as String,
      itemType: map['item_type'] as String?, // Allow nullable casting
      isDisliked: map['is_disliked'] as bool? ?? false,  // Corrected line
    );
  }

  ClosetItemMinimal copyWith({
    String? itemId,
    String? imageUrl,
    String? name,
    String? itemType,
    bool? isDisliked,
  }) {
    return ClosetItemMinimal(
      itemId: itemId ?? this.itemId,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      itemType: itemType ?? this.itemType,
      isDisliked: isDisliked ?? this.isDisliked,
    );
  }

  @override
  List<Object?> get props => [itemId, imageUrl, name, itemType, isDisliked];
}

