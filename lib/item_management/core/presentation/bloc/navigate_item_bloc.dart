import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utilities/logger.dart';
import '../../../core/data/services/item_fetch_service.dart';
import '../../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../../user_management/user_service_locator.dart';

part 'navigate_item_event.dart';
part 'navigate_item_state.dart';

class NavigateItemBloc extends Bloc<NavigateItemEvent, NavigateItemState> {
  final ItemFetchService itemFetchService;
  final CustomLogger logger;
  final AuthBloc authBloc;

  NavigateItemBloc({
    ItemFetchService? itemFetchService,
    CustomLogger? logger,
    AuthBloc? authBloc,
  })  : itemFetchService = itemFetchService ?? ItemFetchService(),
        logger = logger ?? CustomLogger('NavigateItemBlocLogger'),
        authBloc = authBloc ?? locator<AuthBloc>(),
        super(InitialNavigateItemState()) {
    on<FetchFirstItemUploadedAchievementEvent>(_onFetchFirstItemUploadedAchievement);
    on<FetchFirstItemPicEditedAchievementEvent>(_onFetchFirstItemPicEditedAchievement);
    on<FetchFirstItemGiftedAchievementEvent>(_onFetchFirstItemGiftedAchievement);
    on<FetchFirstItemSoldAchievementEvent>(_onFetchFirstItemSoldAchievement);
    on<FetchFirstItemSwapAchievementEvent>(_onFetchFirstItemSwapAchievement);
  }

  Future<void> _onFetchFirstItemUploadedAchievement(
      FetchFirstItemUploadedAchievementEvent event,
      Emitter<NavigateItemState> emit,
      ) async {
    emit(FetchFirstItemUploadedAchievementInProgressState());
    await _fetchAchievement('first_item_upload_achievement', (badgeUrl, achievementName) {
      emit(FetchFirstItemUploadedMilestoneSuccessState(badgeUrl: badgeUrl, achievementName: achievementName));
    });
  }

  Future<void> _onFetchFirstItemPicEditedAchievement(
      FetchFirstItemPicEditedAchievementEvent event,
      Emitter<NavigateItemState> emit,
      ) async {
    emit(FetchFirstItemPicEditedAchievementInProgressState());
    await _fetchAchievement('first_item_pic_edited_achievement', (badgeUrl, achievementName) {
      emit(FetchFirstItemPicEditedMilestoneSuccessState(badgeUrl: badgeUrl, achievementName: achievementName));
    });
  }

  Future<void> _onFetchFirstItemGiftedAchievement(
      FetchFirstItemGiftedAchievementEvent event,
      Emitter<NavigateItemState> emit,
      ) async {
    emit(FetchFirstItemGiftedAchievementInProgressState());
    await _fetchAchievement('first_item_gifted_achievement', (badgeUrl, achievementName) {
      emit(FetchFirstItemGiftedMilestoneSuccessState(badgeUrl: badgeUrl, achievementName: achievementName));
    });
  }

  Future<void> _onFetchFirstItemSoldAchievement(
      FetchFirstItemSoldAchievementEvent event,
      Emitter<NavigateItemState> emit,
      ) async {
    emit(FetchFirstItemSoldAchievementInProgressState());
    await _fetchAchievement('first_item_sold_achievement', (badgeUrl, achievementName) {
      emit(FetchFirstItemSoldMilestoneSuccessState(badgeUrl: badgeUrl, achievementName: achievementName));
    });
  }

  Future<void> _onFetchFirstItemSwapAchievement(
      FetchFirstItemSwapAchievementEvent event,
      Emitter<NavigateItemState> emit,
      ) async {
    emit(FetchFirstItemSwapAchievementInProgressState());
    await _fetchAchievement('first_item_swap_achievement', (badgeUrl, achievementName) {
      emit(FetchFirstItemSwapMilestoneSuccessState(badgeUrl: badgeUrl, achievementName: achievementName));
    });
  }

  Future<void> _fetchAchievement(
      String achievementType,
      Function(String badgeUrl, String achievementName) successCallback,
      ) async {
    try {
      final achievementData = await itemFetchService.fetchAchievementData(achievementType);

      if (achievementData != null && achievementData['badge_url'] != null) {
        final badgeUrl = achievementData['badge_url'] as String;
        final achievementName = achievementData['achievement_name'] as String;

        logger.i('Achievement milestone processed: $achievementType, Badge URL: $badgeUrl');
        successCallback(badgeUrl, achievementName);
      } else {
        logger.i('Failed to fetch $achievementType milestone.');
      }
    } catch (error) {
      logger.e('Error fetching $achievementType milestone: $error');
    }
  }

}
