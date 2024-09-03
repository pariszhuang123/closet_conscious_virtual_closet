import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/utilities/logger.dart';
import '../../../core/data/services/outfits_fetch_service.dart';

part 'navigate_outfit_event.dart';
part 'navigate_outfit_state.dart';


class NavigateOutfitBloc extends Bloc<NavigateOutfitEvent, NavigateOutfitState> {
  final OutfitFetchService outfitFetchService;
  final CustomLogger logger;

  NavigateOutfitBloc({required this.outfitFetchService})
      : logger = CustomLogger('NavigateOutfitBlocLogger'),
        super(InitialNavigateOutfitState()) {
    on<CheckNavigationToReviewEvent>(_onCheckNavigationToReview);
    on<TriggerNpsSurveyEvent>(_onTriggerNpsSurvey);
  }

  Future<void> _onCheckNavigationToReview(
      CheckNavigationToReviewEvent event,
      Emitter<NavigateOutfitState> emit) async {
    final outfitId = await outfitFetchService.fetchOutfitId(event.userId);

    if (outfitId != null) {
      emit(NavigateToReviewPageState(outfitId: outfitId));
    } else {
      // You might emit a state or handle it differently if no navigation is required.
      logger.i('No outfitId found, continuing without navigation.');
    }
  }

  Future<void> _onTriggerNpsSurvey(
      TriggerNpsSurveyEvent event,
      Emitter<NavigateOutfitState> emit) async {
    try {
      final result = await outfitFetchService.fetchOutfitsCountAndNPS();
      int outfitCount = result['outfits_created'];
      bool shouldShowNPS = result['milestone_triggered'];

      if (shouldShowNPS) {
        emit(NpsSurveyTriggeredState(milestone: outfitCount));
      }
    } catch (error) {
      logger.e('Error triggering NPS survey: $error');
    }
  }
}
