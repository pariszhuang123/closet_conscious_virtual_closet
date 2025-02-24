import '../../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../../../core/utilities/logger.dart';

class OutfitData {
  final String outfitId;
  final String? outfitImageUrl;
  final ClosetItemMinimal? item;
  final bool? isActive;

  OutfitData({
    required this.outfitId,
    this.outfitImageUrl,
    this.item,
    this.isActive = true,
  });

  factory OutfitData.fromMap(Map<String, dynamic> map) {
    final logger = CustomLogger('OutfitData');
    try {
      logger.i('Parsing OutfitData for outfitId: ${map['outfit_id']}');

      final dynamic itemsData = map['items'];

      // ✅ Debug: Print raw Supabase response for items
      logger.i('Raw items data: $itemsData');

      final outfitData = OutfitData(
        outfitId: _validateString(map['outfit_id'], 'outfit_id'),
        outfitImageUrl: map['outfit_image_url'] == 'cc_none'
            ? null
            : _validateString(map['outfit_image_url'], 'outfit_image_url'),

        // ✅ Handle both single object and list case
        item: (itemsData is List && itemsData.isNotEmpty)
            ? ClosetItemMinimal.fromMap(itemsData.first as Map<String, dynamic>)
            : (itemsData is Map<String, dynamic>)
            ? ClosetItemMinimal.fromMap(itemsData)
            : null,

        isActive: map['is_active'] as bool? ?? true,
      );

      logger.i('✅ Successfully parsed OutfitData: ${outfitData.outfitId}, item: ${outfitData.item?.name}');
      return outfitData;
    } catch (e) {
      logger.e('❌ Failed to parse OutfitData: $e');
      rethrow;
    }
  }

  factory OutfitData.empty() {
    final logger = CustomLogger('OutfitData.empty');
    logger.d('Creating empty OutfitData.');
    return OutfitData(
      outfitId: '',
      outfitImageUrl: null,
      item: null,
    );
  }

  bool get isEmpty => outfitId.isEmpty && (item == null);
  bool get isNotEmpty => !isEmpty;

  static String _validateString(dynamic value, String fieldName) {
    final logger = CustomLogger('OutfitData._validateString');
    if (value == null || value is! String || value.isEmpty) {
      logger.e('Invalid or missing $fieldName: $value');
      throw FormatException('Invalid or missing $fieldName: $value');
    }
    return value;
  }
}
