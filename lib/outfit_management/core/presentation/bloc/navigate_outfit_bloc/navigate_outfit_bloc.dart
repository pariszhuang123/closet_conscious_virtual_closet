import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

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
  }

  Future<void> _onCheckNavigationToReview(CheckNavigationToReviewEvent event,
      Emitter<NavigateOutfitState> emit) async {
    final userId = authBloc.userId;

    if (userId == null) {
      logger.e('Error: userId is null. Cannot proceed with navigation check.');
      emit(const NavigateOutfitIdleState()); // emit idle so wrapper doesn't hang
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
      emit(const NoReviewNeededState()); // <<=== key change
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
}