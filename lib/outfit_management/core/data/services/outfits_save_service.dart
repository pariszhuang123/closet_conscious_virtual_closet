import 'package:supabase_flutter/supabase_flutter.dart';

Future<Map<String, dynamic>> reviewOutfit({
  required String outfitId,
  required String feedback,
  required List<String> itemIds,
  String comments = 'cc_none',
}) async {
  final supabaseClient = Supabase.instance.client;

  final response = await supabaseClient.rpc('review_outfit', params: {
    'p_outfit_id': outfitId,
    'p_feedback': feedback,
    'p_item_ids': itemIds,
    'p_outfit_comments': comments,
  });

  if (response.error != null) {
    throw Exception('Error reviewing outfit: ${response.error!.message}');
  }

  return response.data as Map<String, dynamic>;
}
