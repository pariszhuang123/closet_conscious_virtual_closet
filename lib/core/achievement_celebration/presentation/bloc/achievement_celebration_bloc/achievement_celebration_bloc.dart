import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utilities/logger.dart';
import '../../../../../outfit_management/core/data/services/outfits_fetch_services.dart';
import '../../../../../item_management/core/data/services/item_fetch_service.dart';

part 'achievement_celebration_event.dart';
part 'achievement_celebration_state.dart';

class AchievementCelebrationBloc extends Bloc<AchievementCelebrationEvent, AchievementCelebrationState> {
  final OutfitFetchService outfitFetchService;
  final ItemFetchService itemFetchService;
  final CustomLogger logger;

  AchievementCelebrationBloc({
    required this.outfitFetchService,
    required this.itemFetchService,
  }) : logger = CustomLogger('AchievementCelebrationBloc'),
        super(AchievementInitialState()) {
    // Outfit Achievements
    on<FetchAndSaveClothingWornAchievementEvent>(_onFetchClothingWorn);
    on<FetchAndSaveNoBuyMilestoneAchievementEvent>(_onFetchNoBuyMilestone);
    on<FetchFirstOutfitCreatedAchievementEvent>(_onFetchFirstOutfit);
    on<FetchFirstSelfieTakenAchievementEvent>(_onFetchFirstSelfie);

    // Item Achievements
    on<FetchFirstItemUploadedAchievementEvent>(_onFetchFirstItemUploaded);
    on<FetchFirstItemPicEditedAchievementEvent>(_onFetchFirstItemPicEdited);
    on<FetchFirstItemGiftedAchievementEvent>(_onFetchFirstItemGifted);
    on<FetchFirstItemSoldAchievementEvent>(_onFetchFirstItemSold);
    on<FetchFirstItemSwapAchievementEvent>(_onFetchFirstItemSwap);
  }

  // === OUTFIT HANDLERS ===

  Future<void> _onFetchClothingWorn(
      FetchAndSaveClothingWornAchievementEvent event,
      Emitter<AchievementCelebrationState> emit,
      ) async {
    emit(AchievementInProgressState());
    await _handleFetchOutfitAchievement(
      emit,
      rpcFunctionName: 'fetch_clothes_worn_achievement_combined',
      successStateBuilder: (badgeUrl, name) =>
          ClothingWornAchievementSuccessState(badgeUrl, name),
    );
  }

  Future<void> _onFetchNoBuyMilestone(
      FetchAndSaveNoBuyMilestoneAchievementEvent event,
      Emitter<AchievementCelebrationState> emit,
      ) async {
    emit(AchievementInProgressState());
    await _handleFetchOutfitAchievement(
      emit,
      rpcFunctionName: 'fetch_milestone_achievements',
      successStateBuilder: (badgeUrl, name) =>
          NoBuyMilestoneAchievementSuccessState(badgeUrl, name),
    );
  }

  Future<void> _onFetchFirstOutfit(
      FetchFirstOutfitCreatedAchievementEvent event,
      Emitter<AchievementCelebrationState> emit,
      ) async {
    emit(AchievementInProgressState());
    await _handleFetchOutfitAchievement(
      emit,
      rpcFunctionName: 'first_outfit_created_achievement',
      successStateBuilder: (badgeUrl, name) =>
          FirstOutfitAchievementSuccessState(badgeUrl, name),
    );
  }

  Future<void> _onFetchFirstSelfie(
      FetchFirstSelfieTakenAchievementEvent event,
      Emitter<AchievementCelebrationState> emit,
      ) async {
    emit(AchievementInProgressState());
    await _handleFetchOutfitAchievement(
      emit,
      rpcFunctionName: 'first_selfie_taken_achievement',
      successStateBuilder: (badgeUrl, name) =>
          FirstSelfieAchievementSuccessState(badgeUrl, name),
    );
  }

  // === ITEM HANDLERS ===

  Future<void> _onFetchFirstItemUploaded(
      FetchFirstItemUploadedAchievementEvent event,
      Emitter<AchievementCelebrationState> emit,
      ) async {
    emit(AchievementInProgressState());
    await _handleFetchItemAchievement(
      emit,
      rpcFunctionName: 'first_item_upload_achievement',
      successStateBuilder: (badgeUrl, name) =>
          FirstItemUploadedAchievementSuccessState(badgeUrl, name),
    );
  }

  Future<void> _onFetchFirstItemPicEdited(
      FetchFirstItemPicEditedAchievementEvent event,
      Emitter<AchievementCelebrationState> emit,
      ) async {
    emit(AchievementInProgressState());
    await _handleFetchItemAchievement(
      emit,
      rpcFunctionName: 'first_item_pic_edited_achievement',
      successStateBuilder: (badgeUrl, name) =>
          FirstItemPicEditedAchievementSuccessState(badgeUrl, name),
    );
  }

  Future<void> _onFetchFirstItemGifted(
      FetchFirstItemGiftedAchievementEvent event,
      Emitter<AchievementCelebrationState> emit,
      ) async {
    emit(AchievementInProgressState());
    await _handleFetchItemAchievement(
      emit,
      rpcFunctionName: 'first_item_gifted_achievement',
      successStateBuilder: (badgeUrl, name) =>
          FirstItemGiftedAchievementSuccessState(badgeUrl, name),
    );
  }

  Future<void> _onFetchFirstItemSold(
      FetchFirstItemSoldAchievementEvent event,
      Emitter<AchievementCelebrationState> emit,
      ) async {
    emit(AchievementInProgressState());
    await _handleFetchItemAchievement(
      emit,
      rpcFunctionName: 'first_item_sold_achievement',
      successStateBuilder: (badgeUrl, name) =>
          FirstItemSoldAchievementSuccessState(badgeUrl, name),
    );
  }

  Future<void> _onFetchFirstItemSwap(
      FetchFirstItemSwapAchievementEvent event,
      Emitter<AchievementCelebrationState> emit,
      ) async {
    emit(AchievementInProgressState());
    await _handleFetchItemAchievement(
      emit,
      rpcFunctionName: 'first_item_swap_achievement',
      successStateBuilder: (badgeUrl, name) =>
          FirstItemSwapAchievementSuccessState(badgeUrl, name),
    );
  }

  // === HELPERS ===

  Future<void> _handleFetchOutfitAchievement(
      Emitter<AchievementCelebrationState> emit, {
        required String rpcFunctionName,
        required AchievementCelebrationState Function(String badgeUrl, String name)
        successStateBuilder,
      }) async {
    try {
      final data = await outfitFetchService.fetchAchievementData(rpcFunctionName);
      if (data != null && data['badge_url'] != null) {
        final badgeUrl = data['badge_url'] as String;
        final name = data['achievement_name'] as String;
        logger.i('Outfit achievement fetched: $name');
        emit(successStateBuilder(badgeUrl, name));
      } else {
        emit(const AchievementFailureState('No outfit achievement data.'));
      }
    } catch (e) {
      emit(AchievementFailureState(e.toString()));
    }
  }

  Future<void> _handleFetchItemAchievement(
      Emitter<AchievementCelebrationState> emit, {
        required String rpcFunctionName,
        required AchievementCelebrationState Function(String badgeUrl, String name)
        successStateBuilder,
      }) async {
    try {
      final data = await itemFetchService.fetchAchievementData(rpcFunctionName);
      if (data != null && data['badge_url'] != null) {
        final badgeUrl = data['badge_url'] as String;
        final name = data['achievement_name'] as String;
        logger.i('Item achievement fetched: $name');
        emit(successStateBuilder(badgeUrl, name));
      } else {
        emit(const AchievementFailureState('No item achievement data.'));
      }
    } catch (e) {
      emit(AchievementFailureState(e.toString()));
    }
  }
}
