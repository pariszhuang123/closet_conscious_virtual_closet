import 'package:equatable/equatable.dart';

class ClosetItemMinimal extends Equatable {
  final String itemId;
  final String imageUrl;
  final String name;
  final String itemType;
  final double amountSpent;
  final DateTime updatedAt;

  const ClosetItemMinimal({
    required this.itemId,
    required this.imageUrl,
    required this.name,
    required this.itemType,
    required this.amountSpent,
    required this.updatedAt});

  factory ClosetItemMinimal.fromMap(Map<String, dynamic> map) {
    return ClosetItemMinimal(
      itemId: map['item_id'] as String,
      imageUrl: map['image_url'] as String,
      name: map['name'] as String,
      itemType: map['item_type'] as String,
      amountSpent: (map['amount_spent'] ?? 0.0) as double,
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }

  @override
  List<Object?> get props => [itemId, imageUrl, name, itemType, amountSpent, updatedAt];
}
