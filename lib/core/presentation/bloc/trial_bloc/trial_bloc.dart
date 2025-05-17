import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/services/core_fetch_services.dart';

part 'trial_event.dart';
part 'trial_state.dart';

class TrialBloc extends Bloc<TrialEvent, TrialState> {
  final CoreFetchService coreFetchService;


  TrialBloc(this.coreFetchService) : super(TrialInitial()) {
    on<CheckTrialAccessEvent>(_onCheckTrialAccess);
    on<ActivateTrialEvent>(_onActivateTrial);
    on<TrialEndedEvent>(_onTrialEnded);
  }

  Future<void> _onCheckTrialAccess(
      CheckTrialAccessEvent event, Emitter<TrialState> emit) async {
    List<TrialState> deniedStates = [];

    if (!await coreFetchService.accessFilterPage()) {
      deniedStates.add(AccessFilterFeatureDenied());
    }
    if (!await coreFetchService.checkMultiClosetFeature()) {
      deniedStates.add(AccessMultiClosetFeatureDenied());
    }
    if (!await coreFetchService.accessCustomizePage()) {
      deniedStates.add(AccessCustomizeFeatureDenied());
    }
    if (!await coreFetchService.checkCalendarFeature()) {
      deniedStates.add(AccessCalendarFeatureDenied());
    }
    if (!await coreFetchService.checkUsageAnalyticsFeature()) {
      deniedStates.add(AccessUsageAnalyticsFeatureDenied());
    }
    if (!await coreFetchService.checkOutfitAccess()) {
      deniedStates.add(AccessOutfitCreationFeatureDenied());
    }

    if (deniedStates.isNotEmpty) {
      emit(TrialAccessDenied(deniedStates));
    } else {
      emit(TrialSuccess());
    }
  }

  Future<void> _onActivateTrial(
      ActivateTrialEvent event, Emitter<TrialState> emit) async {
    emit(TrialActivationInProgress());

    final bool trialStarted = await coreFetchService.trialStarted();

    if (trialStarted) {
      emit(TrialActivated());
    } else {
      emit(TrialActivationFailed());
    }
  }

  Future<void> _onTrialEnded(
      TrialEndedEvent event,
      Emitter<TrialState> emit,
      ) async {
    try {
      // Call the service to validate and update trial features
      final isUpdated = await coreFetchService.trialEnded();

      if (isUpdated) {
        // Emit success state if the RPC returns true
        emit(TrialEndedSuccessState());
      }
      // Do nothing for false; it's not relevant for the UI in this case
    } catch (error) {
      // Log the error but do not emit a failure state since it doesn't matter here
    }
  }
}

