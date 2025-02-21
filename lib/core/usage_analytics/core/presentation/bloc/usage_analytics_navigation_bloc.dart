import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core_enums.dart';
import '../../../../../../core/data/services/core_fetch_services.dart';
import '../../../../../../core/utilities/logger.dart';

part 'usage_analytics_navigation_event.dart';
part 'usage_analytics_navigation_state.dart';

class UsageAnalyticsNavigationBloc extends Bloc<UsageAnalyticsNavigationEvent, UsageAnalyticsNavigationState> {
  final CoreFetchService coreFetchService;
  final CustomLogger logger;

  UsageAnalyticsNavigationBloc({
    required this.coreFetchService,
  })  : logger = CustomLogger('UsageAnalyticsNavigationBloc'),
        super(UsageAnalyticsNavigationInitialState()){

    on<CheckUsageAnalyticsAccessEvent>(_onCheckUsageAnalyticsAccess);
  }


  Future<void> _onCheckUsageAnalyticsAccess(
      CheckUsageAnalyticsAccessEvent event, Emitter<UsageAnalyticsNavigationState> emit) async {
    logger.i('Checking UsageAnalytics feature access.');

    try {
      // Step 1: Check if user has access via milestones, purchases, etc.
      bool hasAccess = await coreFetchService.checkUsageAnalyticsFeature();

      if (hasAccess) {
        emit(const UsageAnalyticsAccessState(accessStatus: AccessStatus.granted));
        logger.i('User has access to UsageAnalytics feature.');
        return;
      }

      // Step 2: If no access, check trial status
      logger.w('User does not have UsageAnalytics access, checking trial status...');
      bool trialPending = await coreFetchService.isTrialPending();

      if (trialPending) {
        logger.i('Trial is pending. Navigating to trialStarted.');
        emit(const UsageAnalyticsAccessState(accessStatus: AccessStatus.trialPending));
      } else {
        logger.i('Trial not pending. Navigating to payment screen.');
        emit(const UsageAnalyticsAccessState(accessStatus: AccessStatus.denied));
      }
    } catch (error) {
      logger.e('Error checking UsageAnalytics access: $error');
      emit(const UsageAnalyticsAccessState(accessStatus: AccessStatus.error));
    }
  }
}
