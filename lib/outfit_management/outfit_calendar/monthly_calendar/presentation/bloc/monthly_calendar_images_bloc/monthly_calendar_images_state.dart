part of 'monthly_calendar_images_bloc.dart';

abstract class MonthlyCalendarImagesState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MonthlyCalendarImagesInitial extends MonthlyCalendarImagesState {}

class MonthlyCalendarImagesLoading extends MonthlyCalendarImagesState {}

class MonthlyCalendarImagesLoaded extends MonthlyCalendarImagesState {
  final List<CalendarData> calendarData;
  final String focusedDate; // Add focusedDate
  final String startDate;   // Add startDate
  final String endDate;     // Add endDate

  MonthlyCalendarImagesLoaded(
      this.calendarData,
      this.focusedDate,
      this.startDate,
      this.endDate,
      );

  @override
  List<Object?> get props => [calendarData, focusedDate, startDate, endDate];
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
