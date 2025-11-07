import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../core/data/services/outfits_fetch_services.dart';

part 'ai_stylist_event.dart';
part 'ai_stylist_state.dart';

class AiStylistBloc extends Bloc<AiStylistEvent, AiStylistState> {
  final OutfitFetchService outfitFetchService;
  final CustomLogger logger;

  AiStylistBloc({required this.outfitFetchService})
      : logger = CustomLogger('AiStylistBlocLogger'),
        super(AiStylistInitial()) {
    on<CheckAiStylistEligibility>(_onCheckEligibility);
  }

  Future<void> _onCheckEligibility(
      CheckAiStylistEligibility event,
      Emitter<AiStylistState> emit,
      ) async {
    try {
      logger.d('Checking AI Stylist eligibility...');
      final result = await outfitFetchService.shouldShowAiStylist();
      emit(AiStylistEligibilityChecked(result));
    } catch (e) {
      logger.e('Error checking AI Stylist eligibility: $e');
      emit(AiStylistFailure('Failed to check eligibility.'));
    }
  }
}
