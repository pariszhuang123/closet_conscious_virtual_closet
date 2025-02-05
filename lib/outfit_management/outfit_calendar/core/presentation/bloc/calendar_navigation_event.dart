part of 'calendar_navigation_bloc.dart';

abstract class CalendarNavigationEvent {}

class CheckCalendarAccessEvent extends CalendarNavigationEvent {}

class CheckMultiClosetAccessEvent extends CalendarNavigationEvent {}
