class OutfitItemMinimal {
  final String itemId;
  final String imageUrl;
  final String name;


  OutfitItemMinimal({
    required this.itemId,
    required this.imageUrl,
    required this.name});

  factory OutfitItemMinimal.fromMap(Map<String, dynamic> map) {
    return OutfitItemMinimal(
      itemId: map['item_id'] as String,
      imageUrl: map['image_url'] as String,
      name: map['name'] as String,
    );
  }
}
