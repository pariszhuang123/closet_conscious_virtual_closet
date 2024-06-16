class ClosetItemDetailed {
  final String id;
  final String imageUrl;
  final String name;
  final String description;
  final String category;
  // Add more fields as required for editing

  ClosetItemDetailed({
    required this.id,
    required this.imageUrl,
    required this.name,
    required this.description,
    required this.category,
  });

  factory ClosetItemDetailed.fromMap(Map<String, dynamic> map) {
    return ClosetItemDetailed(
      id: map['id'] as String,
      imageUrl: map['imageUrl'] as String,
      name: map['name'] as String,
      description: map['description'] as String,
      category: map['category'] as String,
    );
  }
}
