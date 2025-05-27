import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utilities/logger.dart';
import '../../../../../outfit_management/core/data/services/outfits_fetch_services.dart';

part 'achievement_celebration_event.dart';
part 'achievement_celebration_state.dart';

class AchievementCelebrationBloc extends Bloc<AchievementCelebrationEvent, AchievementCelebrationState> {
  final OutfitFetchService outfitFetchService; // Still used for RPC
  final CustomLogger logger;

  AchievementCelebrationBloc({
    required this.outfitFetchService,
  })  : logger = CustomLogger('AchievementCelebrationBloc'),
        super(AchievementInitialState()) {
    on<AwardAchievementEvent>(_onAwardAchievement);
  }

  Future<void> _onAwardAchievement(
      AwardAchievementEvent event,
      Emitter<AchievementCelebrationState> emit,
      ) async {
    emit(AchievementInProgressState());

    try {
      final data = await outfitFetchService.fetchAchievementData('award_user_achievements');

      if (data != null &&
          data['badge_url'] != null &&
          data['achievement_name'] != null) {
        final badgeUrl = data['badge_url'] as String;
        final name = data['achievement_name'] as String;
        final featureStatus = data['feature_status'] as String? ?? 'none';
        logger.i('Achievement awarded: $name');
        emit(AchievementCelebrationSuccessState(badgeUrl, name, featureStatus));
      } else {
        emit(const AchievementFailureState('No new achievement.'));
      }
    } catch (e) {
      logger.e('Error awarding achievement', );
      emit(AchievementFailureState(e.toString()));
    }
  }
}
