part of 'monthly_calendar_metadata_bloc.dart';

abstract class MonthlyCalendarMetadataEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMonthlyCalendarMetadataEvent extends MonthlyCalendarMetadataEvent {}

class UpdateSelectedMetadataEvent extends MonthlyCalendarMetadataEvent {
  final CalendarMetadata updatedMetadata;

  UpdateSelectedMetadataEvent(this.updatedMetadata);

  @override
  List<Object?> get props => [updatedMetadata];
}

class SaveMetadataEvent extends MonthlyCalendarMetadataEvent {

}

class ResetMetadataEvent extends MonthlyCalendarMetadataEvent {}
