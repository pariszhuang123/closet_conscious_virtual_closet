import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../data/services/core_fetch_services.dart';
import '../../../../data/services/core_save_services.dart';
import '../../../../core_enums.dart';
import '../../../../utilities/helper_functions/tutorial_helper.dart';
import '../../data/tutorial_feature_data.dart';
import '../../../../utilities/logger.dart';

part 'tutorial_event.dart';
part 'tutorial_state.dart';

class TutorialBloc extends Bloc<TutorialEvent, TutorialState> {
  final CoreFetchService coreFetchService;
  final CoreSaveService coreSaveService;
  final logger = CustomLogger('TutorialBloc');

  TutorialBloc({required this.coreFetchService, required this.coreSaveService})
      : super(TutorialInitial()) {
    on<CheckTutorialStatus>(_onCheckTutorialStatus);
    on<LoadTutorialFeatureData>(_onLoadTutorialFeatureData);
    on<SaveTutorialProgress>(_onSaveTutorialProgress);
  }

  Future<void> _onCheckTutorialStatus(
      CheckTutorialStatus event,
      Emitter<TutorialState> emit,
      ) async {
    logger.i('🔍 Checking if tutorial is first-time for: ${event.tutorialType}');
    try {
      final isFirstTime = await coreFetchService.isFirstTimeTutorial(
        tutorialInput: event.tutorialType.value,
      );
      logger.i('📘 Tutorial isFirstTime: $isFirstTime');
      if (isFirstTime) {
        emit(ShowTutorial(event.tutorialType));
        logger.i('🎬 Emitting ShowTutorial');
      } else {
        emit(SkipTutorial(event.tutorialType));
        logger.i('⏩ Emitting SkipTutorial');
      }
    } catch (e, stack) {
      logger.e('❌ Error during CheckTutorialStatus: $e\n$stack');
      emit(SkipTutorial(event.tutorialType));
    }
  }

  Future<void> _onLoadTutorialFeatureData(LoadTutorialFeatureData event,
      Emitter<TutorialState> emit,) async {
    emit(TutorialFeatureLoading());

    try {
      final tutorials = TutorialFeatureList.getTutorials(); // no context needed
      final feature = tutorials.firstWhere(
            (data) => data.tutorialType == event.tutorialType,
        orElse: () {
          logger.e('❌ Tutorial type not found: ${event.tutorialType}');
          throw Exception('Tutorial type not found');
        },
      );

      final matchingVideos = feature.videos
          .where((v) => v.journeyType == event.journeyType)
          .toList();

      logger.i('✅ Loaded ${matchingVideos.length} videos for ${event
          .tutorialType} & ${event.journeyType}');

      emit(TutorialFeatureLoaded(
        TutorialFeatureData(
          getTitle: feature.getTitle,
          tutorialType: feature.tutorialType,
          videos: matchingVideos,
        ),
      ));
    } catch (e) {
      logger.e('❌ Error loading tutorial feature data');
      emit(TutorialFeatureLoadFailure());
    }
  }

  Future<void> _onSaveTutorialProgress(SaveTutorialProgress event,
      Emitter<TutorialState> emit,) async {
    logger.i(
        '📝 Saving tutorial progress for input: ${event.tutorialInput} (${event
            .dismissType.name})');

    try {
      final result = await coreSaveService.trackTutorialInteraction(
        tutorialInput: event.tutorialInput,
      );

      if (result) {
        logger.i(
            '✅ Tutorial progress saved successfully (type: ${event.dismissType
                .name})');
        emit(TutorialSaveSuccess(event.dismissType));
      } else {
        logger.w('⚠️ Tutorial progress save failed — Supabase returned false');
        emit(TutorialSaveSuccess(event.dismissType));
      }
    } catch (e) {
      logger.e('❌ Exception while saving tutorial progress');
      emit(TutorialSaveFailure());
    }
  }
}