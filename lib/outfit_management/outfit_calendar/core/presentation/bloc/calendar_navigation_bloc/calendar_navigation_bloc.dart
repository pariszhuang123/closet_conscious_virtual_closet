import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/core_enums.dart';
import '../../../../../../../core/data/services/core_fetch_services.dart';
import '../../../../../../../core/utilities/logger.dart';

part 'calendar_navigation_event.dart';
part 'calendar_navigation_state.dart';

class CalendarNavigationBloc extends Bloc<CalendarNavigationEvent, CalendarNavigationState> {
  final CoreFetchService coreFetchService;
  final CustomLogger logger;

  CalendarNavigationBloc({
    required this.coreFetchService,
  })  : logger = CustomLogger('CalendarNavigationBloc'),
        super(CalendarNavigationInitialState()){

    on<CheckCalendarAccessEvent>(_onCheckCalendarAccess);
  }


  Future<void> _onCheckCalendarAccess(
      CheckCalendarAccessEvent event, Emitter<CalendarNavigationState> emit) async {
    logger.i('Checking calendar feature access.');

    try {
      // Step 1: Check if user has access via milestones, purchases, etc.
      bool hasAccess = await coreFetchService.checkCalendarFeature();

      if (hasAccess) {
        emit(const CalendarAccessState(accessStatus: AccessStatus.granted));
        logger.i('User has access to calendar feature.');
        return;
      }

      // Step 2: If no access, check trial status
      logger.w('User does not have calendar access, checking trial status...');
      bool trialPending = await coreFetchService.isTrialPending();

      if (trialPending) {
        logger.i('Trial is pending. Navigating to trialStarted.');
        emit(const CalendarAccessState(accessStatus: AccessStatus.trialPending));
      } else {
        logger.i('Trial not pending. Navigating to payment screen.');
        emit(const CalendarAccessState(accessStatus: AccessStatus.denied));
      }
    } catch (error) {
      logger.e('Error checking calendar access: $error');
      emit(const CalendarAccessState(accessStatus: AccessStatus.error));
    }
  }
}
