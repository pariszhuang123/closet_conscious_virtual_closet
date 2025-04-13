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
  final CoreFetchService fetchService;
  final CoreSaveService saveService;
  final logger = CustomLogger('TutorialBloc');

  TutorialBloc({required this.fetchService, required this.saveService})
      : super(TutorialInitial()) {
    on<CheckTutorialStatus>(_onCheckTutorialStatus);
    on<LoadTutorialFeatureData>(_onLoadTutorialFeatureData);
    on<SaveTutorialProgress>(_onSaveTutorialProgress);
  }

  Future<void> _onCheckTutorialStatus(CheckTutorialStatus event,
      Emitter<TutorialState> emit,) async {
    final isFirstTime = await fetchService.isFirstTimeTutorial(
      tutorialInput: event.tutorialType.value, // ✅ use the extension
    );
    if (isFirstTime) {
      emit(ShowTutorial());
    } else {
      emit(SkipTutorial());
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
      final result = await saveService.trackTutorialInteraction(
        tutorialInput: event.tutorialInput,
      );

      if (result) {
        logger.i(
            '✅ Tutorial progress saved successfully (type: ${event.dismissType
                .name})');
        emit(TutorialSaveSuccess(event.dismissType));
      } else {
        logger.w('⚠️ Tutorial progress save failed — Supabase returned false');
        emit(TutorialSaveFailure());
      }
    } catch (e) {
      logger.e('❌ Exception while saving tutorial progress');
      emit(TutorialSaveFailure());
    }
  }
}