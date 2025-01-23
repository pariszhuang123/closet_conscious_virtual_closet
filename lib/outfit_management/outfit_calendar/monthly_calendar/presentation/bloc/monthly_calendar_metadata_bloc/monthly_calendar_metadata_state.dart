part of 'monthly_calendar_metadata_bloc.dart';

abstract class MonthlyCalendarMetadataState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MonthlyCalendarInitialState extends MonthlyCalendarMetadataState {}

class MonthlyCalendarLoadingState extends MonthlyCalendarMetadataState {}

class MonthlyCalendarLoadedState extends MonthlyCalendarMetadataState {
  final List<CalendarMetadata> metadataList;

  MonthlyCalendarLoadedState({required this.metadataList});

  MonthlyCalendarLoadedState copyWith({List<CalendarMetadata>? metadataList}) {
    return MonthlyCalendarLoadedState(
      metadataList: metadataList ?? this.metadataList,
    );
  }

  @override
  List<Object?> get props => [metadataList];
}

class MonthlyCalendarSaveInProgressState extends MonthlyCalendarMetadataState {}

class MonthlyCalendarSaveSuccessState extends MonthlyCalendarMetadataState {}

class MonthlyCalendarSaveFailureState extends MonthlyCalendarMetadataState {
  final String error;

  MonthlyCalendarSaveFailureState(this.error);

  @override
  List<Object?> get props => [error];
}

class MonthlyCalendarResetSuccessState extends MonthlyCalendarMetadataState {}
