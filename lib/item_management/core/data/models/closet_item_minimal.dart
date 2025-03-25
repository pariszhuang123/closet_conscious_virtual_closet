import 'package:equatable/equatable.dart';
import '../../../../core/data/models/image_source.dart';

class ClosetItemMinimal extends Equatable {
  final String itemId;
  final ImageSource imageSource; // ✅ use wrapper instead of imageUrl
  final String name;
  final String? itemType;
  final double? pricePerWear;
  final bool isDisliked;  // Keep nullable internally
  final bool itemIsActive;

  const ClosetItemMinimal({
    required this.itemId,
    required this.imageSource, // ✅ wrapped image source
    required this.name,
    this.itemType,
    this.pricePerWear, // Renamed field
    this.isDisliked = false,
    this.itemIsActive = true
  });

  factory ClosetItemMinimal.fromMap(Map<String, dynamic> map) {
    return ClosetItemMinimal(
      itemId: map['item_id'] as String,
      imageSource: ImageSource.remote(map['image_url'] as String), // ✅ wrap remote URL
      name: map['name'] as String,
      itemType: map['item_type'] as String?, // Allow nullable casting
      pricePerWear: (map['price_per_wear'] as num?)?.toDouble(), // ✅ Convert to double safely
      isDisliked: map['is_disliked'] as bool? ?? false,  // Corrected line
      itemIsActive: (map.containsKey('item_is_active') && map['item_is_active'] != null)
          ? map['item_is_active'] as bool
          : true, // ✅ More explicit: Defaults to true only if missing
    );
  }

  ClosetItemMinimal copyWith({
    String? itemId,
    ImageSource? imageSource,
    String? name,
    String? itemType,
    double? pricePerWear, // Updated field
    bool? isDisliked,
    bool? itemIsActive
  }) {
    return ClosetItemMinimal(
      itemId: itemId ?? this.itemId,
        imageSource: imageSource ?? this.imageSource,
      name: name ?? this.name,
      itemType: itemType ?? this.itemType,
      pricePerWear: pricePerWear ?? this.pricePerWear, // Updated field
      isDisliked: isDisliked ?? this.isDisliked,
      itemIsActive: itemIsActive ?? this.itemIsActive
    );
  }

  @override
  List<Object?> get props => [itemId, imageSource, name, itemType, pricePerWear, isDisliked, itemIsActive];
}

