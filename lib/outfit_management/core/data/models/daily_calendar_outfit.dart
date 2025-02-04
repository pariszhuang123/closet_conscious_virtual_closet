import '../../../../item_management/core/data/models/closet_item_minimal.dart';

class DailyCalendarOutfit {
  final String outfitId;
  final String feedback;
  final bool reviewed;
  final bool isActive;
  final String? outfitImageUrl;
  final String eventName;
  final String? outfitComments; // New field
  final List<ClosetItemMinimal> items;

  DailyCalendarOutfit({
    required this.outfitId,
    required this.feedback,
    required this.reviewed,
    required this.isActive,
    this.outfitImageUrl,
    required this.eventName,
    required this.outfitComments, // New field
    required this.items,
  });

  factory DailyCalendarOutfit.fromMap(Map<String, dynamic> map) {
    return DailyCalendarOutfit(
      outfitId: map['outfit_id'] as String,
      feedback: map['feedback'] as String,
      reviewed: map['reviewed'] as bool,
      isActive: map['is_active'] as bool,
      outfitImageUrl: map['outfit_image_url'] as String?,
      eventName: map['event_name'] as String,
      outfitComments: map['outfit_comments'] as String, // New field
      items: (map['items'] as List<dynamic>)
          .map((item) => ClosetItemMinimal.fromMap(item as Map<String, dynamic>))
          .toList(),
    );
  }
}
