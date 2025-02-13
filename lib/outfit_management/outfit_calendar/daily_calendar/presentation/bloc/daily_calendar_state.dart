part of 'daily_calendar_bloc.dart';

abstract class DailyCalendarState extends Equatable {
  const DailyCalendarState();

  @override
  List<Object?> get props => [];
}

class DailyCalendarLoading extends DailyCalendarState {}

class DailyCalendarLoaded extends DailyCalendarState {
  final List<DailyCalendarOutfit> dailyOutfits;
  final bool hasPreviousOutfits;
  final bool hasNextOutfits;
  final DateTime focusedDate; // ✅ Added this

  const DailyCalendarLoaded(
      this.dailyOutfits, {
        required this.hasPreviousOutfits,
        required this.hasNextOutfits,
        required this.focusedDate, // ✅ Added this
      });

  @override
  List<Object?> get props => [dailyOutfits, hasPreviousOutfits, hasNextOutfits, focusedDate];
}

class DailyCalendarNavigationSuccessState extends DailyCalendarState {}

class DailyCalendarSaveFailureState extends DailyCalendarState {}

class DailyCalendarError extends DailyCalendarState {
  final String message;

  const DailyCalendarError(this.message);

  @override
  List<Object?> get props => [message];
}
