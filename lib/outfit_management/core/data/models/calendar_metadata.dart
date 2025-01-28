class CalendarMetadata {
  final String eventName;
  final bool ignoreEventName;
  final String feedback;
  final bool isCalendarSelectable;
  final String isOutfitActive;

  CalendarMetadata({
    required this.eventName,
    required this.ignoreEventName,
    required this.feedback,
    required this.isCalendarSelectable,
    required this.isOutfitActive,
  });

  factory CalendarMetadata.fromMap(Map<String, dynamic> map) {
    return CalendarMetadata(
      eventName: map['event_name'] as String,
      ignoreEventName: map['ignore_event_name'] as bool,
      feedback: map['feedback'] as String,
      isCalendarSelectable: map['is_calendar_selectable'] as bool,
      isOutfitActive: map['is_outfit_active'] as String,
    );
  }

  String get computedEventName {
    if (ignoreEventName) {
      return ""; // Return empty string
    }
    return eventName;
  }

  // Add copyWith method
  CalendarMetadata copyWith({
    String? eventName,
    bool? ignoreEventName,
    String? feedback,
    bool? isCalendarSelectable,
    String? isOutfitActive,
  }) {
    return CalendarMetadata(
      eventName: eventName ?? this.eventName,
      ignoreEventName: ignoreEventName ?? this.ignoreEventName,
      feedback: feedback ?? this.feedback,
      isCalendarSelectable: isCalendarSelectable ?? this.isCalendarSelectable,
      isOutfitActive: isOutfitActive ?? this.isOutfitActive,
    );
  }
}
