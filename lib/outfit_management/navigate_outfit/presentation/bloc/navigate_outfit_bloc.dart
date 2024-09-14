import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utilities/logger.dart';
import '../../../core/data/services/outfits_fetch_service.dart';
import '../../../core/data/services/outfits_save_service.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../user_management/user_service_locator.dart';

part 'navigate_outfit_event.dart';
part 'navigate_outfit_state.dart';

class NavigateOutfitBloc extends Bloc<NavigateOutfitEvent, NavigateOutfitState> {
  final OutfitFetchService outfitFetchService;
  final OutfitSaveService outfitSaveService;
  final CustomLogger logger;
  final AuthBloc authBloc;

  NavigateOutfitBloc({required this.outfitFetchService, required this.outfitSaveService})
      : logger = CustomLogger('NavigateOutfitBlocLogger'),
        authBloc = locator<AuthBloc>(),
        super(InitialNavigateOutfitState()) {
    on<CheckNavigationToReviewEvent>(_onCheckNavigationToReview);
    on<TriggerNpsSurveyEvent>(_onTriggerNpsSurvey);
    on<FetchAndSaveClothingWornAchievementEvent>(_onFetchAndSaveClothingWornAchievement);
    on<FetchAndSaveNoBuyMilestoneAchievementEvent>(_onFetchAndSaveNoBuyMilestoneAchievement);
  }

  Future<void> _onCheckNavigationToReview(
      CheckNavigationToReviewEvent event,
      Emitter<NavigateOutfitState> emit) async {
    final userId = authBloc.userId;

    if (userId == null) {
      logger.e('Error: userId is null. Cannot proceed with navigation check.');
      return;
    }
    final outfitId = await outfitFetchService.fetchOutfitId(userId);

    if (outfitId != null) {
      logger.i('Emitting NavigateToReviewPageState with outfitId: $outfitId');
      emit(NavigateToReviewPageState(outfitId: outfitId));
    } else {
      logger.i('No outfitId found, continuing without navigation.');
    }
  }

  Future<void> _onTriggerNpsSurvey(
      TriggerNpsSurveyEvent event,
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
  Future<void> _onFetchAndSaveClothingWornAchievement(
      FetchAndSaveClothingWornAchievementEvent event,
      Emitter<NavigateOutfitState> emit,
      ) async {
    emit(FetchAndSaveClothingWornAchievementInProgressState());
    try {
      // Call the generalized fetch method, passing the appropriate RPC function name
      final achievementData  = await outfitFetchService.fetchAchievementData('fetch_clothes_worn_achievement_combined');

      if (achievementData != null && achievementData['badge_url'] != null) {
        final badgeUrl = achievementData['badge_url'] as String;

        logger.i('Achievement milestone processed, badge URL: $badgeUrl');

        emit(FetchAndSaveClothingAchievementMilestoneSuccessState(badgeUrl: badgeUrl)); // Emit success state with badge URL
      } else {
        logger.i('Failed to fetch achievement milestone.');
      }
    } catch (error) {
      logger.e('Error fetching achievement milestone: $error');
    }
  }

  Future<void> _onFetchAndSaveNoBuyMilestoneAchievement(
      FetchAndSaveNoBuyMilestoneAchievementEvent event,
      Emitter<NavigateOutfitState> emit,
      ) async {
    emit(FetchAndSaveNoBuyMilestoneAchievementInProgressState());
    try {
      // Call the generalized fetch method, passing the appropriate RPC function name
      final achievementData = await outfitFetchService.fetchAchievementData('fetch_milestone_achievements');

      if (achievementData != null && achievementData['badge_url'] != null) {
        final badgeUrl = achievementData['badge_url'] as String;
        logger.i('Achievement milestone processed, badge URL: $badgeUrl');

        emit(FetchAndSaveNoBuyMilestoneSuccessState(badgeUrl: badgeUrl));
      } else {
        logger.i('Failed to fetch achievement milestone.');
      }
    } catch (error) {
      logger.e('Error fetching achievement milestone: $error');
    }
  }

}
