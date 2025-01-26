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

  /// Factory to parse Supabase response
  factory MonthlyCalendarResponse.fromMap(Map<String, dynamic> map) {
    try {
      // Validate `calendar_data`
      if (map['calendar_data'] != null && map['calendar_data'] is! List) {
        throw FormatException(
            'Invalid `calendar_data` format: expected List, got ${map['calendar_data'].runtimeType}');
      }

      // Parse and validate raw calendar data
      final rawCalendarData = map['calendar_data'] != null
          ? (map['calendar_data'] as List)
          .map((data) {
        if (data is Map<String, dynamic>) {
          return CalendarData.fromMap(data);
        } else {
          throw FormatException('Invalid entry in `calendar_data`: $data');
        }
      })
          .toList()
          : <CalendarData>[];

      // Populate all dates in the range
      final fullCalendarData = _populateAllDates(
        startDate: _parseDate(map['start_date'], 'start_date'),
        endDate: _parseDate(map['end_date'], 'end_date'),
        calendarData: rawCalendarData,
      );

      // Validate required fields and return the parsed object
      return MonthlyCalendarResponse(
        status: _validateString(map['status'], 'status'),
        focusedDate: _parseDate(map['focused_date'], 'focused_date'),
        startDate: _parseDate(map['start_date'], 'start_date'),
        endDate: _parseDate(map['end_date'], 'end_date'),
        hasPreviousOutfits: _validateBool(map['has_previous_outfits'], 'has_previous_outfits'),
        hasNextOutfits: _validateBool(map['has_next_outfits'], 'has_next_outfits'),
        calendarData: fullCalendarData,
      );
    } catch (e) {
      throw FormatException('Failed to parse MonthlyCalendarResponse: $e');
    }
  }

  /// Parse dates safely
  static DateTime _parseDate(dynamic date, String fieldName) {
    if (date == null || date is! String) {
      throw FormatException('Invalid or missing $fieldName: $date');
    }
    try {
      return DateTime.parse(date);
    } catch (e) {
      throw FormatException('Failed to parse $fieldName as DateTime: $date');
    }
  }

  /// Validate string fields
  static String _validateString(dynamic value, String fieldName) {
    if (value == null || value is! String || value.isEmpty) {
      throw FormatException('Invalid or missing $fieldName: $value');
    }
    return value;
  }

  /// Validate boolean fields
  static bool _validateBool(dynamic value, String fieldName) {
    if (value == null || value is! bool) {
      throw FormatException('Invalid or missing $fieldName: $value');
    }
    return value;
  }

  /// Populate missing dates with default CalendarData
  static List<CalendarData> _populateAllDates({
    required DateTime startDate,
    required DateTime endDate,
    required List<CalendarData> calendarData,
  }) {
    final allDates = <DateTime>[];
    for (var date = startDate;
    date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
    date = date.add(const Duration(days: 1))) {
      allDates.add(date);
    }

    // Map existing data by date for quick lookup
    final calendarDataMap = {
      for (var entry in calendarData) entry.date: entry,
    };

    // Fill missing dates with default data
    return allDates.map((date) {
      return calendarDataMap[date] ??
          CalendarData(
            date: date,
            outfitData: OutfitData.empty(), // Default empty OutfitData
          );
    }).toList();
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
    try {
      return CalendarData(
        date: MonthlyCalendarResponse._parseDate(map['date'], 'date'),
        outfitData: map['outfit_data'] != null
            ? OutfitData.fromMap(map['outfit_data'] as Map<String, dynamic>)
            : OutfitData.empty(), // Use empty OutfitData if missing
      );
    } catch (e) {
      throw FormatException('Failed to parse CalendarData: $e');
    }
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

  /// Factory to parse OutfitData from Map
  factory OutfitData.fromMap(Map<String, dynamic> map) {
    try {
      return OutfitData(
        outfitId: MonthlyCalendarResponse._validateString(map['outfit_id'], 'outfit_id'),
        outfitImageUrl: map['outfit_image_url'] == 'cc_none'
            ? null
            : MonthlyCalendarResponse._validateString(map['outfit_image_url'], 'outfit_image_url'),
        items: (map['items'] != null && map['items'] is List)
            ? (map['items'] as List)
            .map((item) {
          if (item is Map<String, dynamic>) {
            return ClosetItemMinimal.fromMap(item);
          } else {
            throw FormatException('Invalid entry in `items`: $item');
          }
        })
            .toList()
            : [],
      );
    } catch (e) {
      throw FormatException('Failed to parse OutfitData: $e');
    }
  }

  /// Create an empty OutfitData object
  factory OutfitData.empty() {
    return OutfitData(
      outfitId: '', // Empty outfitId
      outfitImageUrl: null, // No image
      items: [], // No items
    );
  }

  /// Check if OutfitData is empty
  bool get isEmpty => outfitId.isEmpty && (items == null || items!.isEmpty);

  /// Check if OutfitData is not empty
  bool get isNotEmpty => !isEmpty;
}
