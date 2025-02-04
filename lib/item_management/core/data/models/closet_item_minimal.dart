import 'package:equatable/equatable.dart';

class ClosetItemMinimal extends Equatable {
  final String itemId;
  final String imageUrl;
  final String name;
  final String? itemType;
  final bool isDisliked;  // Keep nullable internally
  final bool itemIsActive;

  const ClosetItemMinimal({
    required this.itemId,
    required this.imageUrl,
    required this.name,
    this.itemType,
    this.isDisliked = false,
    this.itemIsActive = true
  });

  factory ClosetItemMinimal.fromMap(Map<String, dynamic> map) {
    return ClosetItemMinimal(
      itemId: map['item_id'] as String,
      imageUrl: map['image_url'] as String,
      name: map['name'] as String,
      itemType: map['item_type'] as String?, // Allow nullable casting
      isDisliked: map['is_disliked'] as bool? ?? false,  // Corrected line
      itemIsActive: (map.containsKey('item_is_active') && map['item_is_active'] != null)
          ? map['item_is_active'] as bool
          : true, // ✅ More explicit: Defaults to true only if missing
    );
  }

  ClosetItemMinimal copyWith({
    String? itemId,
    String? imageUrl,
    String? name,
    String? itemType,
    bool? isDisliked,
    bool? itemIsActive
  }) {
    return ClosetItemMinimal(
      itemId: itemId ?? this.itemId,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      itemType: itemType ?? this.itemType,
      isDisliked: isDisliked ?? this.isDisliked,
      itemIsActive: itemIsActive ?? this.itemIsActive
    );
  }

  @override
  List<Object?> get props => [itemId, imageUrl, name, itemType, isDisliked, itemIsActive];
}

