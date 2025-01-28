part of 'monthly_calendar_images_bloc.dart';

abstract class MonthlyCalendarImagesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MonthlyCalendarImagesInitial extends MonthlyCalendarImagesState {}

class MonthlyCalendarImagesLoading extends MonthlyCalendarImagesState {}

class NoReviewedOutfitState extends MonthlyCalendarImagesState {}

class NoFilteredReviewedOutfitState extends MonthlyCalendarImagesState {}

class MonthlyCalendarImagesLoaded extends MonthlyCalendarImagesState {
  final List<CalendarData> calendarData;
  final String focusedDate;
  final String startDate;
  final String endDate;
  final bool hasPreviousOutfits;
  final bool hasNextOutfits;

  MonthlyCalendarImagesLoaded({
    required this.calendarData,
    required this.focusedDate,
    required this.startDate,
    required this.endDate,
    required this.hasPreviousOutfits,
    required this.hasNextOutfits,
  });

  @override
  List<Object?> get props =>
      [calendarData, focusedDate, startDate, endDate, hasPreviousOutfits, hasNextOutfits];
}

class NoReviewedOutfit extends MonthlyCalendarImagesState {}

class NoOutfitsMatchingFilter extends MonthlyCalendarImagesState {}

class MonthlyCalendarImagesError extends MonthlyCalendarImagesState {
  final String message;

  MonthlyCalendarImagesError(this.message);

  @override
  List<Object?> get props => [message];
}

class OutfitSelectionUpdated extends MonthlyCalendarImagesState {
  final List<String> selectedOutfitIds;

  OutfitSelectionUpdated(this.selectedOutfitIds);

  @override
  List<Object?> get props => [selectedOutfitIds];
}

class ActiveItemsFetched extends MonthlyCalendarImagesState {
  final List<String> selectedOutfitIds;

  ActiveItemsFetched(this.selectedOutfitIds);

  @override
  List<Object?> get props => [selectedOutfitIds];
}

class FocusedDateUpdated extends MonthlyCalendarImagesState {}

class FocusedDateUpdateFailed extends MonthlyCalendarImagesState {
  final String message;

  FocusedDateUpdateFailed(this.message);

  @override
  List<Object?> get props => [message];
}
