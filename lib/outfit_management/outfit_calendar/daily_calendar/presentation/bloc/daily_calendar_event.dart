part of 'daily_calendar_bloc.dart';

abstract class DailyCalendarEvent extends Equatable {
  const DailyCalendarEvent();

  @override
  List<Object?> get props => [];
}

class FetchDailyCalendarEvent extends DailyCalendarEvent {

  const FetchDailyCalendarEvent();

  @override
  List<Object?> get props => [];
}

class NavigateCalendarEvent extends DailyCalendarEvent {
  final String direction;
  final String navigationMode;

  const NavigateCalendarEvent({
    required this.direction,
    this.navigationMode = 'detailed',
  });

  @override
  List<Object?> get props => [direction, navigationMode];
}
