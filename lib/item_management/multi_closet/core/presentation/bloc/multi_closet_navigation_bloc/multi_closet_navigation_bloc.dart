import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/data/services/core_fetch_services.dart';
import '../../../../../../core/data/services/core_save_services.dart';
import '../../../../../../core/utilities/logger.dart';
import '../../../../../../core/core_enums.dart';

part 'multi_closet_navigation_event.dart';
part 'multi_closet_navigation_state.dart';

class MultiClosetNavigationBloc extends Bloc<MultiClosetNavigationEvent, MultiClosetNavigationState> {
  final CoreFetchService coreFetchService;
  final CoreSaveService coreSaveService;
  final CustomLogger logger;

  MultiClosetNavigationBloc({
    required this.coreFetchService,
    required this.coreSaveService,
  })
      : logger = CustomLogger('MultiClosetNavigationBloc'),
        super(ViewMultiClosetNavigationState()) {
    on<NavigateToViewMultiCloset>((event, emit) {
      logger.d('Navigating to ViewMultiCloset.');
      emit(ViewMultiClosetNavigationState());
    });

    on<NavigateToCreateMultiCloset>((event, emit) {
      logger.d('Navigating to CreateMultiCloset.');
      emit(CreateMultiClosetNavigationState());
    });

    on<NavigateToEditAllMultiCloset>(_onNavigateToEditAllMultiCloset);

    on<NavigateToEditSingleMultiCloset>(_onNavigateToEditSingleMultiCloset);

    on<NavigateToFilterProvider>((event, emit) {
      logger.d('Navigating to FilterProvider.');
      emit(FilterProviderNavigationState());
    });

    on<NavigateToCustomizeProvider>((event, emit) {
      logger.d('Navigating to CustomizeProvider.');
      emit(CustomizeProviderNavigationState());
    });

    on<CheckMultiClosetAccessEvent>(_onCheckMultiClosetAccess);
  }

  Future<void> _onNavigateToEditAllMultiCloset(
      NavigateToEditAllMultiCloset event,
      Emitter<MultiClosetNavigationState> emit) async {
    logger.i('Starting navigation to EditAllMultiCloset.');
    try {
      await coreSaveService.updateAllClosetSharedPreference();
      logger.d('Shared preference for all closets updated successfully.');
      emit(EditAllMultiClosetNavigationState());
    } catch (error) {
      logger.e('Error navigating to EditAllMultiCloset: $error');
      emit(MultiClosetNavigationErrorState());
    }
  }

  Future<void> _onNavigateToEditSingleMultiCloset(
      NavigateToEditSingleMultiCloset event,
      Emitter<MultiClosetNavigationState> emit) async {
    logger.i('Starting navigation to EditSingleMultiCloset for closetId: ${event
        .closetId}.');
    try {
      await coreSaveService.updateSingleClosetSharedPreference(event.closetId);
      logger.d('Shared preference updated for closetId: ${event.closetId}.');
      emit(EditSingleMultiClosetNavigationState(event.closetId));
    } catch (error) {
      logger.e('Error navigating to EditSingleMultiCloset: $error');
      emit(MultiClosetNavigationErrorState());
    }
  }

  Future<void> _onCheckMultiClosetAccess(CheckMultiClosetAccessEvent event,
      Emitter<MultiClosetNavigationState> emit) async {
    logger.i('Checking if the user has access to the multi-closet feature.');

    try {
      // Step 1: Check if the user already has access via milestones, purchases, etc.
      bool hasMultiClosetAccess = await coreFetchService.checkMultiClosetFeature();

      if (hasMultiClosetAccess) {
        emit(const MultiClosetAccessState(accessStatus: AccessStatus.granted));
        logger.i(
            'User already has multi-closet access via milestones/purchase.');
        return;
      }

      // Step 2: If no access, check trial status
      logger.w(
          'User does not have multi-closet access, checking trial status...');
      bool trialPending = await coreFetchService.isTrialPending();

      if (trialPending) {
        logger.i('Trial is pending. Navigating to trialStarted.');
        emit(const MultiClosetAccessState(accessStatus: AccessStatus.trialPending));
      } else {
        logger.i('Trial not pending. Navigating to payment screen.');
        emit(const MultiClosetAccessState(accessStatus: AccessStatus.denied));
      }
    } catch (error) {
      logger.e('Error checking multi-closet access: $error');
      emit(const MultiClosetAccessState(accessStatus: AccessStatus.error));
    }
  }
}