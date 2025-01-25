import 'package:equatable/equatable.dart';

class ClosetItemMinimal extends Equatable {
  final String itemId;
  final String imageUrl;
  final String name;
  final String? itemType;

  const ClosetItemMinimal({
    required this.itemId,
    required this.imageUrl,
    required this.name,
    this.itemType,
  });

  factory ClosetItemMinimal.fromMap(Map<String, dynamic> map) {
    return ClosetItemMinimal(
      itemId: map['item_id'] as String,
      imageUrl: map['image_url'] as String,
      name: map['name'] as String,
      itemType: map['item_type'] as String?, // Allow nullable casting
    );
  }

  @override
  List<Object?> get props => [itemId, imageUrl, name, itemType];
}
