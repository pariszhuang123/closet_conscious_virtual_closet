import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/core_enums.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../data/services/outfits_fetch_services.dart';
import '../../../data/services/outfits_save_services.dart';
import '../../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../../user_management/user_service_locator.dart';
import '../../../../../core/data/services/core_fetch_services.dart';

part 'navigate_outfit_event.dart';
part 'navigate_outfit_state.dart';

class NavigateOutfitBloc extends Bloc<NavigateOutfitEvent, NavigateOutfitState> {
  final OutfitFetchService outfitFetchService;
  final OutfitSaveService outfitSaveService;
  final CoreFetchService coreFetchService;

  final CustomLogger logger;
  final AuthBloc authBloc;

  NavigateOutfitBloc(
      {required this.outfitFetchService, required this.outfitSaveService, required this.coreFetchService})
      : logger = CustomLogger('NavigateOutfitBlocLogger'),
        authBloc = locator<AuthBloc>(),
        super(InitialNavigateOutfitState()) {
    on<CheckNavigationToReviewEvent>(_onCheckNavigationToReview);
    on<TriggerNpsSurveyEvent>(_onTriggerNpsSurvey);
    on<CheckOutfitCreationAccessEvent>(
        _onCheckOutfitCreationAccess); // Add event handler

  }

  Future<void> _onCheckNavigationToReview(CheckNavigationToReviewEvent event,
      Emitter<NavigateOutfitState> emit) async {
    final userId = authBloc.userId;

    if (userId == null) {
      logger.e('Error: userId is null. Cannot proceed with navigation check.');
      return;
    }
    final response = await outfitFetchService.fetchOutfitId(
        userId); // Fetch response object

    if (response != null && response.outfitId != null) {
      logger.i('Emitting NavigateToReviewPageState with outfitId: ${response
          .outfitId}');
      emit(NavigateToReviewPageState(
          outfitId: response.outfitId!)); // Use only outfitId
    } else {
      logger.i('No outfitId found, continuing without navigation.');
    }
  }

  Future<void> _onTriggerNpsSurvey(TriggerNpsSurveyEvent event,
      Emitter<NavigateOutfitState> emit) async {
    logger.i('Received TriggerNpsSurveyEvent');

    try {
      final result = await outfitFetchService.fetchOutfitsCountAndNPS();
      logger.d('Fetched NPS survey data: $result');

      int outfitCount = result['outfits_created'];
      bool shouldShowNPS = result['milestone_triggered'];

      if (shouldShowNPS) {
        emit(NpsSurveyTriggeredState(milestone: outfitCount));
        logger.i('NPS survey triggered at outfitCount: $outfitCount');
      } else {
        logger.i('NPS survey not triggered; outfitCount: $outfitCount');
      }
    } catch (error) {
      logger.e('Error triggering NPS survey: $error');
    }
  }

  Future<void> _onCheckOutfitCreationAccess(
      CheckOutfitCreationAccessEvent event,
      Emitter<NavigateOutfitState> emit) async {
    logger.i('Checking if the user has access to create multiple outfits.');

    try {
      // Step 1: Check if the user already has access via milestones, purchases, etc.
      bool hasMultiOutfitAccess = await coreFetchService.checkOutfitAccess();

      if (hasMultiOutfitAccess) {
        emit(const MultiOutfitAccessState(accessStatus: AccessStatus.granted));
        logger.i('User already has multi-outfit creation access.');
        return;
      }

      // Step 2: If no access, check trial status
      logger.w(
          'User does not have multi-outfit access, checking trial status...');
      bool trialPending = await coreFetchService.isTrialPending();

      if (trialPending) {
        emit(const MultiOutfitAccessState(
            accessStatus: AccessStatus.trialPending));
        logger.i('Trial is pending. Navigating to trialStarted.');
      } else {
        emit(const MultiOutfitAccessState(accessStatus: AccessStatus.denied));
        logger.i('Trial not pending. Navigating to payment screen.');
      }
    } catch (error) {
      logger.e('Error checking multi-outfit access: $error');
      emit(const MultiOutfitAccessState(accessStatus: AccessStatus.error));
    }
  }
}