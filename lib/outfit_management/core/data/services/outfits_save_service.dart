import 'package:supabase_flutter/supabase_flutter.dart';

final supabaseClient = Supabase.instance.client;

Future<Map<String, dynamic>> reviewOutfit({
  required String outfitId,
  required String feedback,
  required List<String> itemIds,
  String comments = 'cc_none',
}) async {

  final response = await supabaseClient.rpc('review_outfit', params: {
    'p_outfit_id': outfitId,
    'p_feedback': feedback,
    'p_item_ids': itemIds,
    'p_outfit_comments': comments,
  });

  return response as Map<String, dynamic>;
}
