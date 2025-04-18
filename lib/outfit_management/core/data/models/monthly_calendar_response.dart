import 'outfit_data.dart';
import '../../../../../core/utilities/logger.dart';

class MonthlyCalendarResponse {
  final String status;
  final DateTime focusedDate;
  final DateTime startDate;
  final DateTime endDate;
  final bool isCalendarSelectable;
  final bool hasPreviousOutfits;
  final bool hasNextOutfits;
  final List<CalendarData> calendarData;

  MonthlyCalendarResponse({
    required this.status,
    required this.focusedDate,
    required this.startDate,
    required this.endDate,
    required this.isCalendarSelectable,
    required this.hasPreviousOutfits,
    required this.hasNextOutfits,
    required this.calendarData,
  });

  /// Factory to parse Supabase response
  factory MonthlyCalendarResponse.fromMap(Map<String, dynamic> map) {
    final logger = CustomLogger('MonthlyCalendarResponse');
    try {
      logger.i('Parsing MonthlyCalendarResponse...');

      if (map['calendar_data'] != null && map['calendar_data'] is! List) {
        throw FormatException(
            'Invalid `calendar_data` format: expected List, got ${map['calendar_data'].runtimeType}');
      }

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

      final fullCalendarData = _populateAllDates(
        startDate: _parseDate(map['start_date'], 'start_date'),
        endDate: _parseDate(map['end_date'], 'end_date'),
        calendarData: rawCalendarData,
      );

      logger.i('Successfully parsed MonthlyCalendarResponse.');
      return MonthlyCalendarResponse(
        status: _validateString(map['status'], 'status'),
        focusedDate: _parseDate(map['focused_date'], 'focused_date'),
        startDate: _parseDate(map['start_date'], 'start_date'),
        endDate: _parseDate(map['end_date'], 'end_date'),
        isCalendarSelectable:
        _validateBool(map['is_calendar_selectable'], 'is_calendar_selectable'),
        hasPreviousOutfits:
        _validateBool(map['has_previous_outfits'], 'has_previous_outfits'),
        hasNextOutfits: _validateBool(map['has_next_outfits'], 'has_next_outfits'),
        calendarData: fullCalendarData,
      );
    } catch (e) {
      logger.e('Failed to parse MonthlyCalendarResponse: $e');
      rethrow;
    }
  }

  static DateTime _parseDate(dynamic date, String fieldName) {
    final logger = CustomLogger('MonthlyCalendarResponse._parseDate');
    if (date == null || date is! String) {
      logger.e('Invalid or missing $fieldName: $date');
      throw FormatException('Invalid or missing $fieldName: $date');
    }
    try {
      return DateTime.parse(date).toUtc();
    } catch (e) {
      logger.e('Failed to parse $fieldName as DateTime: $date');
      throw FormatException('Failed to parse $fieldName as DateTime: $date');
    }
  }

  static List<CalendarData> _populateAllDates({
    required DateTime startDate,
    required DateTime endDate,
    required List<CalendarData> calendarData,
  }) {
    final logger = CustomLogger('MonthlyCalendarResponse._populateAllDates');
    logger.i('Populating missing dates...');

    final normalizedCalendarData = calendarData.map((data) {
      final normalizedDate = DateTime.utc(data.date.year, data.date.month, data.date.day);
      return CalendarData(
        date: normalizedDate,
        outfitData: data.outfitData,
      );
    }).toList();

    final allDates = <DateTime>[];
    for (var date = DateTime.utc(startDate.year, startDate.month, startDate.day);
    date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
    date = date.add(const Duration(days: 1))) {
      allDates.add(date);
    }

    final calendarDataMap = {
      for (var entry in normalizedCalendarData) entry.date: entry,
    };

    return allDates.map((date) {
      final entry = calendarDataMap[date] ?? CalendarData(
        date: date,
        outfitData: OutfitData.empty(),
      );

      if (entry.outfitData.isNotEmpty) {
        logger.d('Date $date has an outfit.');
      } else {
        logger.w('Date $date is empty.');
      }

      return entry;
    }).toList();
  }

  static String _validateString(dynamic value, String fieldName) {
    final logger = CustomLogger('MonthlyCalendarResponse._validateString');
    if (value == null || value is! String || value.isEmpty) {
      logger.e('Invalid or missing $fieldName: $value');
      throw FormatException('Invalid or missing $fieldName: $value');
    }
    return value;
  }

  static bool _validateBool(dynamic value, String fieldName) {
    final logger = CustomLogger('MonthlyCalendarResponse._validateBool');
    if (value == null || value is! bool) {
      logger.e('Invalid or missing $fieldName: $value');
      throw FormatException('Invalid or missing $fieldName: $value');
    }
    return value;
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
    final logger = CustomLogger('CalendarData');
    try {
      logger.i('Parsing CalendarData...');
      final parsedDate = MonthlyCalendarResponse._parseDate(map['date'], 'date');
      final normalizedDate = DateTime.utc(parsedDate.year, parsedDate.month, parsedDate.day);

      final calendarData = CalendarData(
        date: normalizedDate,
        outfitData: map['outfit_data'] != null
            ? OutfitData.fromMap(map['outfit_data'] as Map<String, dynamic>)
            : OutfitData.empty(),
      );

      logger.i('Successfully parsed CalendarData for date: $normalizedDate');
      return calendarData;
    } catch (e) {
      logger.e('Failed to parse CalendarData: $e');
      rethrow;
    }
  }
}
