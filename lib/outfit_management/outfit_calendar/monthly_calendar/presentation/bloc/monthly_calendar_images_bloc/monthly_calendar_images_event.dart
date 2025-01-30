part of 'monthly_calendar_images_bloc.dart';

abstract class MonthlyCalendarImagesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMonthlyCalendarImages extends MonthlyCalendarImagesEvent {}

class CalendarInteraction extends MonthlyCalendarImagesEvent {
  final bool isCalendarSelectable;
  final DateTime selectedDate;
  final String? outfitId; // Nullable outfitId

  CalendarInteraction({
    required this.isCalendarSelectable,
    required this.selectedDate,
    this.outfitId,
  });

  @override
  List<Object?> get props => [isCalendarSelectable, selectedDate, outfitId];
}


class ToggleOutfitSelection extends MonthlyCalendarImagesEvent {
  final String outfitId;

  ToggleOutfitSelection({required this.outfitId});

  @override
  List<Object?> get props => [outfitId];
}

class FetchActiveItems extends MonthlyCalendarImagesEvent {}

class UpdateFocusedDate extends MonthlyCalendarImagesEvent {
  final DateTime selectedDate;
  final String outfitId;

  UpdateFocusedDate({
    required this.selectedDate,
    required this.outfitId}); // Use named parameters

  @override
  List<Object?> get props => [selectedDate, outfitId];
}

class NavigateCalendarEvent extends MonthlyCalendarImagesEvent {
  final String direction;
  final String navigationMode;

  NavigateCalendarEvent({
    required this.direction,
  }) : navigationMode = 'monthly'; // Preset navigationMode to "monthly"

  @override
  List<Object?> get props => [direction, navigationMode];
}
