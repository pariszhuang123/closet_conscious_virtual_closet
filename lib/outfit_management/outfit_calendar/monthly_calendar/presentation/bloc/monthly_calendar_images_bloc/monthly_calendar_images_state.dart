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
  final bool isCalendarSelectable;
  final bool hasPreviousOutfits;
  final bool hasNextOutfits;
  final List<String> selectedOutfitIds;

  MonthlyCalendarImagesLoaded({
    required this.calendarData,
    required this.focusedDate,
    required this.startDate,
    required this.endDate,
    required this.isCalendarSelectable,
    required this.hasPreviousOutfits,
    required this.hasNextOutfits,
    this.selectedOutfitIds = const [],
  });

  @override
  List<Object?> get props => [
    calendarData,
    focusedDate,
    startDate,
    endDate,
    isCalendarSelectable,
    hasPreviousOutfits,
    hasNextOutfits,
    selectedOutfitIds,
  ];

  MonthlyCalendarImagesLoaded copyWith({
    List<CalendarData>? calendarData,
    String? focusedDate,
    String? startDate,
    String? endDate,
    bool? isCalendarSelectable,
    bool? hasPreviousOutfits,
    bool? hasNextOutfits,
    List<String>? selectedOutfitIds,
  }) {
    return MonthlyCalendarImagesLoaded(
      calendarData: calendarData ?? this.calendarData,
      focusedDate: focusedDate ?? this.focusedDate,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isCalendarSelectable: isCalendarSelectable ?? this.isCalendarSelectable,
      hasPreviousOutfits: hasPreviousOutfits ?? this.hasPreviousOutfits,
      hasNextOutfits: hasNextOutfits ?? this.hasNextOutfits,
      selectedOutfitIds: selectedOutfitIds ?? this.selectedOutfitIds, // ✅ Ordered selection
    );
  }
}


class NoReviewedOutfit extends MonthlyCalendarImagesState {}

class NoOutfitsMatchingFilter extends MonthlyCalendarImagesState {}

class MonthlyCalendarImagesError extends MonthlyCalendarImagesState {
  final String message;

  MonthlyCalendarImagesError(this.message);

  @override
  List<Object?> get props => [message];
}

class ActiveItemsFetched extends MonthlyCalendarImagesState {
  final List<String> activeItemIds; // ✅ Use item IDs instead of outfit IDs

  ActiveItemsFetched(this.activeItemIds);

  @override
  List<Object?> get props => [activeItemIds];
}

class FocusedDateUpdatedState extends MonthlyCalendarImagesState {
  final String outfitId;

  FocusedDateUpdatedState({required this.outfitId});

  @override
  List<Object?> get props => [outfitId];
}

class FocusedDateUpdateFailedState extends MonthlyCalendarImagesState {
  final String message;

  FocusedDateUpdateFailedState(this.message);

  @override
  List<Object?> get props => [message];
}

class MonthlyCalendarNavigationSuccessState extends MonthlyCalendarImagesState {
  final List<String> selectedOutfitIds;

  MonthlyCalendarNavigationSuccessState({required this.selectedOutfitIds});

  @override
  List<Object?> get props => [selectedOutfitIds];
}

class MonthlyCalendarSaveFailureState extends MonthlyCalendarImagesState {}
