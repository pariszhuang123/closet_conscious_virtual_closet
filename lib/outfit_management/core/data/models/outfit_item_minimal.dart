import 'package:equatable/equatable.dart';

class OutfitItemMinimal extends Equatable {
  final String itemId;
  final String imageUrl;
  final String name;
  final bool isDisliked;

  const OutfitItemMinimal({
    required this.itemId,
    required this.imageUrl,
    required this.name,
    this.isDisliked = false,
  });

  // Factory constructor to create an instance from a map
  factory OutfitItemMinimal.fromMap(Map<String, dynamic> map) {
    return OutfitItemMinimal(
      itemId: map['item_id'] as String,
      imageUrl: map['image_url'] as String,
      name: map['name'] as String,
      isDisliked: map['is_disliked'] as bool? ?? false,  // Corrected line
    );
  }

  // CopyWith method to create a copy with modified fields
  OutfitItemMinimal copyWith({
    String? itemId,
    String? imageUrl,
    String? name,
    bool? isDisliked,
  }) {
    return OutfitItemMinimal(
      itemId: itemId ?? this.itemId,
      imageUrl: imageUrl ?? this.imageUrl,
      name: name ?? this.name,
      isDisliked: isDisliked ?? this.isDisliked,
    );
  }

  // Equatable props to optimize comparisons and rebuilds
  @override
  List<Object?> get props => [itemId, imageUrl, name, isDisliked];
}
