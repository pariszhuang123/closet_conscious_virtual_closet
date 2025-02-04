part of 'monthly_calendar_images_bloc.dart';

abstract class MonthlyCalendarImagesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMonthlyCalendarImages extends MonthlyCalendarImagesEvent {}


class ToggleOutfitSelection extends MonthlyCalendarImagesEvent {
  final String outfitId;

  ToggleOutfitSelection({required this.outfitId});

  @override
  List<Object?> get props => [outfitId];
}

class FetchActiveItems extends MonthlyCalendarImagesEvent {
  final List<String> selectedOutfitIds;

  FetchActiveItems({required this.selectedOutfitIds});

  @override
  List<Object?> get props => [selectedOutfitIds];
}

class UpdateFocusedDate extends MonthlyCalendarImagesEvent {
  final DateTime selectedDate;

  UpdateFocusedDate({
    required this.selectedDate}); // Use named parameters

  @override
  List<Object?> get props => [selectedDate];
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
