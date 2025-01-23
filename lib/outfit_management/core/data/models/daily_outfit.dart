import '../../../../item_management/core/data/models/closet_item_minimal.dart';

class DailyOutfit {
  final String outfitId;
  final String? feedback;
  final bool reviewed;
  final bool isActive;
  final String? outfitImageUrl;
  final String? eventName;
  final List<ClosetItemMinimal> items;

  DailyOutfit({
    required this.outfitId,
    this.feedback,
    required this.reviewed,
    required this.isActive,
    this.outfitImageUrl,
    this.eventName,
    required this.items,
  });

  factory DailyOutfit.fromMap(Map<String, dynamic> map) {
    return DailyOutfit(
      outfitId: map['outfit_id'] as String,
      feedback: map['feedback'] as String?,
      reviewed: map['reviewed'] as bool,
      isActive: map['is_active'] as bool,
      outfitImageUrl: map['outfit_image_url'] as String?,
      eventName: map['event_name'] as String?,
      items: (map['items'] as List<dynamic>)
          .map((item) => ClosetItemMinimal.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

