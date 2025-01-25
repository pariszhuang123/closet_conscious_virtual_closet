import '../../../../item_management/core/data/models/closet_item_minimal.dart';

class MonthlyCalendarResponse {
  final String status;
  final DateTime focusedDate;
  final DateTime startDate;
  final DateTime endDate;
  final bool hasPreviousOutfits;
  final bool hasNextOutfits;
  final List<CalendarData> calendarData;

  MonthlyCalendarResponse({
    required this.status,
    required this.focusedDate,
    required this.startDate,
    required this.endDate,
    required this.hasPreviousOutfits,
    required this.hasNextOutfits,
    required this.calendarData,
  });

  factory MonthlyCalendarResponse.fromMap(Map<String, dynamic> map) {
    return MonthlyCalendarResponse(
      status: map['status'] as String,
      focusedDate: DateTime.parse(map['focused_date'] as String), // Parse
      startDate: DateTime.parse(map['start_date'] as String),     // Parse
      endDate: DateTime.parse(map['end_date'] as String),         // Parse
      hasPreviousOutfits: map['has_previous_outfits'] as bool,
      hasNextOutfits: map['has_next_outfits'] as bool,
      calendarData: map['calendar_data'] != null
          ? (map['calendar_data'] as List<dynamic>)
          .map((data) => CalendarData.fromMap(data as Map<String, dynamic>))
          .toList()
          : [],
    );
  }
}

class CalendarData {
  final DateTime date;
  final OutfitData outfitData;

  CalendarData({
    required this.date,
    required this.outfitData,
  });

  factory CalendarData.fromMap(Map<String, dynamic> map) {
    return CalendarData(
      date: DateTime.parse(map['date'] as String), // Parse
      outfitData: OutfitData.fromMap(map['outfit_data'] as Map<String, dynamic>),
    );
  }
}

class OutfitData {
  final String outfitId;
  final String? outfitImageUrl;
  final List<ClosetItemMinimal>? items;

  OutfitData({
    required this.outfitId,
    this.outfitImageUrl,
    this.items,
  });

  factory OutfitData.fromMap(Map<String, dynamic> map) {
    return OutfitData(
      outfitId: map['outfit_id'] as String,
      outfitImageUrl: map['outfit_image_url'] as String?,
      items: (map['items'] != null && map['items'] is List<dynamic>)
          ? (map['items'] as List<dynamic>)
          .map((item) => ClosetItemMinimal.fromMap(item as Map<String, dynamic>))
          .toList()
          : null, // Ensure items is null if the field is missing or invalid
    );
  }
}