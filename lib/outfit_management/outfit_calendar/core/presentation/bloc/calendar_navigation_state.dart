part of 'calendar_navigation_bloc.dart';

abstract class CalendarNavigationState {}

class CalendarNavigationInitialState extends CalendarNavigationState {}

class CalendarAccessGrantedState extends CalendarNavigationState {}
class CalendarAccessDeniedState extends CalendarNavigationState {}

class CalendarNavigationErrorState extends CalendarNavigationState {}
