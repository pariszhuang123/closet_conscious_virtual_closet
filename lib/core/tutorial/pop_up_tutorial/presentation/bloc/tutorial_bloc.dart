import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/services/core_fetch_services.dart';
import '../../../../data/services/core_save_services.dart';

part 'tutorial_event.dart';
part 'tutorial_state.dart';

class TutorialBloc extends Bloc<TutorialEvent, TutorialState> {
  final CoreFetchService fetchService;
  final CoreSaveService saveService;

  TutorialBloc({required this.fetchService, required this.saveService}) : super(TutorialInitial()) {
    on<CheckTutorialStatus>(_onCheckTutorialStatus);
    on<SaveTutorialProgress>(_onSaveTutorialProgress);
  }

  Future<void> _onCheckTutorialStatus(
      CheckTutorialStatus event,
      Emitter<TutorialState> emit,
      ) async {
    final isFirstTime = await fetchService.isFirstTimeTutorial(tutorialInput: event.tutorialInput);
    if (isFirstTime) {
      emit(ShowTutorial());
    } else {
      emit(SkipTutorial());
    }
  }

  Future<void> _onSaveTutorialProgress(
      SaveTutorialProgress event,
      Emitter<TutorialState> emit,
      ) async {
    final result = await saveService.trackTutorialInteraction(
      tutorialInput: event.tutorialInput, // only this goes to RPC ✅
    );

    if (result) {
      emit(TutorialSaveSuccess(event.dismissedByButton)); // UI uses this ✅
    } else {
      emit(TutorialSaveFailure());
    }
  }
}
