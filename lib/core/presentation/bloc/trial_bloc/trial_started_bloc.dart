import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/services/core_fetch_services.dart';

part 'trial_started_event.dart';
part 'trial_started_state.dart';

class TrialBloc extends Bloc<TrialEvent, TrialState> {
  final CoreFetchService coreFetchService;


  TrialBloc(this.coreFetchService) : super(TrialInitial()) {
    on<CheckTrialAccessEvent>(_onCheckTrialAccess);
    on<ActivateTrialEvent>(_onActivateTrial);
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
}
