import 'package:supabase_flutter/supabase_flutter.dart';

class Item {
  final String imageUrl;
  final String name;
  final DateTime updatedAt;

  Item({required this.imageUrl, required this.name, required this.updatedAt});

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      imageUrl: map['image_url'] as String,
      name: map['name'] as String,
      updatedAt: DateTime.parse(map['updated_at'] as String),
    );
  }
}

Future<List<Item>> fetchItems() async {
  final data = await Supabase.instance.client
      .from('items')
      .select('image_url, name, updated_at')
      .order('updated_at', ascending: false);

  return data.map((item) => Item.fromMap(item)).toList();
}
