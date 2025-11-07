import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/utilities/logger.dart';
import '../../../../core/data/services/outfits_fetch_services.dart';
import '../../../../../item_management/core/data/models/closet_item_minimal.dart';

part 'outfit_lottery_event.dart';
part 'outfit_lottery_state.dart';

class OutfitLotteryBloc extends Bloc<OutfitLotteryEvent, OutfitLotteryState> {
  final OutfitFetchService outfitFetchService;
  final CustomLogger logger;

  OutfitLotteryBloc({required this.outfitFetchService})
      : logger = CustomLogger('OutfitLotteryBlocLogger'),
        super(OutfitLotteryInitial()) {
    on<CheckIfShouldShowOutfitLottery>(_onCheckIfShouldShow);
    on<RunOutfitLottery>(_onRunOutfitLottery);
  }

  Future<void> _onCheckIfShouldShow(
      CheckIfShouldShowOutfitLottery event,
      Emitter<OutfitLotteryState> emit,
      ) async {
    logger.d('Received CheckIfShouldShowOutfitLottery event');
    emit(OutfitLotteryLoading());

    try {
      logger.d('Calling outfitFetchService.shouldShowOutfitLottery()');
      final shouldShow = await outfitFetchService.shouldShowOutfitLottery();
      logger.d('shouldShowOutfitLottery result: $shouldShow');
      emit(OutfitLotteryCheckResult(shouldShow));
    } catch (e, stack) {
      logger.e('Error in _onCheckIfShouldShow: $e\n$stack');
      emit(const OutfitLotteryFailure('Failed to check availability.'));
    }
  }

  Future<void> _onRunOutfitLottery(
      RunOutfitLottery event,
      Emitter<OutfitLotteryState> emit,
      ) async {
    logger.d(
      'Received RunOutfitLottery event | occasion: ${event.occasion}, '
          'season: ${event.season}, useAllClosets: ${event.useAllClosets}',
    );
    emit(OutfitLotteryLoading());

    try {
      logger.d('Calling outfitFetchService.runOutfitLottery()');
      final result = await outfitFetchService.runOutfitLottery(
        occasion: event.occasion,
        season: event.season,
        useAllClosets: event.useAllClosets,
      );

      final List<ClosetItemMinimal> items = (result['items'] as List?)
          ?.map((e) => ClosetItemMinimal.fromMap(e))
          .toList() ?? [];

      final List<String> suggestions = (result['suggestions'] as List?)?.cast<String>() ?? [];

      final Map<String, dynamic> parameters = (result['parameters'] as Map<String, dynamic>? ?? {});

      if (items.isEmpty) {
        throw OutfitFetchException(result['reason'] ?? 'No outfit generated');
      }

      logger.d('runOutfitLottery returned ${items.length} items');
      emit(OutfitLotterySuccess(items: items, suggestions: suggestions, parameters: parameters));
    } catch (e, stack) {
      logger.e('Error in _onRunOutfitLottery: $e\n$stack');
      emit(const OutfitLotteryFailure('Failed to run outfit lottery.'));
    }
  }
}
