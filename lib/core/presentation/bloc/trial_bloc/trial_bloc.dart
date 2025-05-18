import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/services/core_fetch_services.dart';
import '../../../core_enums.dart';
import '../../../utilities/logger.dart';

part 'trial_event.dart';
part 'trial_state.dart';

class TrialBloc extends Bloc<TrialEvent, TrialState> {
  final CoreFetchService coreFetchService;
  final CustomLogger logger = CustomLogger('TrialBloc');

  TrialBloc(this.coreFetchService) : super(TrialInitial()) {
    on<CheckTrialAccessEvent>(_onCheckTrialAccess);
    on<CheckTrialAccessByFeatureEvent>(_onCheckTrialAccessByFeature);
    on<ActivateTrialEvent>(_onActivateTrial);
    on<TrialEndedEvent>(_onTrialEnded);
  }

  Future<void> _onCheckTrialAccess(
      CheckTrialAccessEvent event, Emitter<TrialState> emit) async {
    logger.i('Checking trial access for all features...');
    List<TrialState> deniedStates = [];

    if (!await coreFetchService.accessFilterPage()) {
      logger.i('Filter feature denied');
      deniedStates.add(AccessFilterFeatureDenied());
    }
    if (!await coreFetchService.checkMultiClosetFeature()) {
      logger.i('MultiCloset feature denied');
      deniedStates.add(AccessMultiClosetFeatureDenied());
    }
    if (!await coreFetchService.accessCustomizePage()) {
      logger.i('Customize feature denied');
      deniedStates.add(AccessCustomizeFeatureDenied());
    }
    if (!await coreFetchService.checkCalendarFeature()) {
      logger.i('Calendar feature denied');
      deniedStates.add(AccessCalendarFeatureDenied());
    }
    if (!await coreFetchService.checkUsageAnalyticsFeature()) {
      logger.i('Usage Analytics feature denied');
      deniedStates.add(AccessUsageAnalyticsFeatureDenied());
    }
    if (!await coreFetchService.checkOutfitAccess()) {
      logger.i('Outfit Creation feature denied');
      deniedStates.add(AccessOutfitCreationFeatureDenied());
    }

    if (deniedStates.isNotEmpty) {
      logger.i('Access denied to one or more features. Emitting TrialAccessDenied');
      emit(TrialAccessDenied(deniedStates));
    } else {
      logger.i('Access granted to all features. Emitting TrialSuccess');
      emit(TrialSuccess());
    }
  }

  Future<void> _onCheckTrialAccessByFeature(
      CheckTrialAccessByFeatureEvent event, Emitter<TrialState> emit) async {
    logger.i('Checking trial access for feature: ${event.feature}');
    bool isDenied = false;
    TrialState? denialState;

    switch (event.feature) {
      case FeatureKey.filter:
        isDenied = !await coreFetchService.accessFilterPage();
        denialState = AccessFilterFeatureDenied();
        break;
      case FeatureKey.multicloset:
        isDenied = !await coreFetchService.checkMultiClosetFeature();
        denialState = AccessMultiClosetFeatureDenied();
        break;
      case FeatureKey.customize:
        isDenied = !await coreFetchService.accessCustomizePage();
        denialState = AccessCustomizeFeatureDenied();
        break;
      case FeatureKey.calendar:
        isDenied = !await coreFetchService.checkCalendarFeature();
        denialState = AccessCalendarFeatureDenied();
        break;
      case FeatureKey.usageAnalytics:
        isDenied = !await coreFetchService.checkUsageAnalyticsFeature();
        denialState = AccessUsageAnalyticsFeatureDenied();
        break;
      case FeatureKey.multiOutfit:
        isDenied = !await coreFetchService.checkOutfitAccess();
        denialState = AccessOutfitCreationFeatureDenied();
        break;
      default:
        logger.w('Unknown feature key: ${event.feature}');
        break;
    }

    if (isDenied && denialState != null) {
      logger.i('Feature ${event.feature} is denied. Checking trial status...');
      final isPending = await coreFetchService.isTrialPending();
      logger.i('Trial status isPending: $isPending');

      if (isPending) {
        logger.i('Trial is pending. Emitting TrialAccessDenied for feature ${event.feature}');
        emit(TrialAccessDenied([denialState]));
      } else {
        logger.i('Trial is not pending. Treating as normal access. Emitting TrialSuccess.');
        emit(TrialSuccess());
      }
    } else {
      logger.i('Feature ${event.feature} is allowed. Emitting TrialSuccess.');
      emit(TrialSuccess());
    }
  }

  Future<void> _onActivateTrial(
      ActivateTrialEvent event, Emitter<TrialState> emit) async {
    logger.i('Activating trial...');
    emit(TrialActivationInProgress());

    final bool trialStarted = await coreFetchService.trialStarted();

    if (trialStarted) {
      logger.i('Trial successfully activated.');
      emit(TrialActivated());
    } else {
      logger.w('Trial activation failed.');
      emit(TrialActivationFailed());
    }
  }

  Future<void> _onTrialEnded(
      TrialEndedEvent event, Emitter<TrialState> emit) async {
    try {
      logger.i('Ending trial...');
      final isUpdated = await coreFetchService.trialEnded();

      if (isUpdated) {
        logger.i('Trial ended successfully. Emitting TrialEndedSuccessState.');
        emit(TrialEndedSuccessState());
      } else {
        logger.i('Trial end update returned false. No state emitted.');
      }
    } catch (error) {
      logger.e('Error ending trial: $error');
    }
  }
}
