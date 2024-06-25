class ClosetItemMinimal {
  final String itemId;
  final String imageUrl;
  final String name;
  final String itemType;
  final DateTime updatedAt;

  ClosetItemMinimal({
    required this.itemId,
    required this.imageUrl,
    required this.name,
    required this.itemType,
    required this.updatedAt});

  factory ClosetItemMinimal.fromMap(Map<String, dynamic> map) {
    return ClosetItemMinimal(
      itemId: map['item_id'] as String,
      imageUrl: map['image_url'] as String,
      name: map['name'] as String,
      itemType: map['item_type'] as String,
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}
