import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/data/services/core_fetch_services.dart';
import '../../../../../../core/utilities/logger.dart';

part 'calendar_navigation_event.dart';
part 'calendar_navigation_state.dart';

class CalendarNavigationBloc extends Bloc<CalendarNavigationEvent, CalendarNavigationState> {
  final CoreFetchService fetchService;
  final CustomLogger logger;

  CalendarNavigationBloc({
    required this.fetchService,
  })  : logger = CustomLogger('CalendarNavigationBloc'),
        super(CalendarNavigationInitialState()){

    on<CheckCalendarAccessEvent>(_onCheckCalendarAccess);
  }

  Future<void> _onCheckCalendarAccess(
      CheckCalendarAccessEvent event, Emitter<CalendarNavigationState> emit) async {
    logger.i('Checking multi-closet access.');
    try {
      final hasAccess = await fetchService.checkCalendarFeature();
      logger.d('Multi-closet access check result: $hasAccess.');
      if (hasAccess) {
        emit(CalendarAccessGrantedState());
      } else {
        emit(CalendarAccessDeniedState());
      }
    } catch (error) {
      logger.e('Error checking multi-closet access: $error');
      emit(CalendarNavigationErrorState());
    }
  }
}
