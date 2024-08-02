import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../core/utilities/logger.dart';
import '../../../create_outfit/presentation/bloc/create_outfit_item_bloc.dart';

final logger = CustomLogger('CreateOutfitItemFetchSupabaseService');

Future<List<ClosetItemMinimal>> fetchCreateOutfitItems(OutfitItemCategory category, int currentPage, int batchSize) async {
  try {
    logger.d('Fetching items for page: $currentPage with batch size: $batchSize and category: $category');
    final data = await Supabase.instance.client
        .from('items')
        .select('item_id, image_url, name, item_type, updated_at')
        .eq('status', 'active')
        .eq('item_type', category.toString().split('.').last)
        .order('updated_at', ascending: false)
        .range(currentPage * batchSize, (currentPage + 1) * batchSize - 1);

    logger.i('Fetched ${data.length} items');
    return data.map<ClosetItemMinimal>((item) => ClosetItemMinimal.fromMap(item)).toList();
  } catch (error) {
    logger.e('Error fetching items: $error');
    rethrow;
  }
}

