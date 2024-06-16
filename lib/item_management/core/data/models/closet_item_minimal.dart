class ClosetItemMinimal {
  final String id;
  final String imageUrl;
  final String name;

  ClosetItemMinimal({required this.id, required this.imageUrl, required this.name});

  factory ClosetItemMinimal.fromMap(Map<String, dynamic> map) {
    return ClosetItemMinimal(
      id: map['id'] as String,
      imageUrl: map['imageUrl'] as String,
      name: map['name'] as String,
    );
  }
}
