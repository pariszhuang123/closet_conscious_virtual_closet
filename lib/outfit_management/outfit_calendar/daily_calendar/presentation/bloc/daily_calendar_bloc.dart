import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/data/services/outfits_save_services.dart';
import '../../../../core/data/services/outfits_fetch_services.dart';
import '../../../../core/data/models/daily_calendar_outfit.dart';
import '../../../../../core/utilities/logger.dart';

part 'daily_calendar_event.dart';
part 'daily_calendar_state.dart';

class DailyCalendarBloc extends Bloc<DailyCalendarEvent, DailyCalendarState> {
  final OutfitFetchService outfitFetchService;
  final OutfitSaveService outfitSaveService;
  static final _logger = CustomLogger('DailyCalendarBloc');

  DailyCalendarBloc({
    required this.outfitFetchService,
    required this.outfitSaveService,
  }) : super(DailyCalendarLoading()) {
    _logger.i('DailyCalendarBloc initialized');
    on<FetchDailyCalendarEvent>(_onFetchDailyCalendarForDate);
    on<NavigateCalendarEvent>(_onNavigateCalendar);
  }

  Future<void> _onFetchDailyCalendarForDate(
      FetchDailyCalendarEvent event,
      Emitter<DailyCalendarState> emit,
      ) async {
    _logger.d('Event received: FetchDailyCalendarEvent');

    try {
      emit(DailyCalendarLoading());
      _logger.d('State emitted: DailyCalendarLoading');

      // Fetch the full RPC response (not just outfits)
      final Map<String, dynamic> fetchResult = await outfitFetchService.fetchDailyCalendarOutfits();

      _logger.d('Raw response received: ${fetchResult.runtimeType} -> $fetchResult');

      // Extract metadata
      final bool hasPreviousOutfits = fetchResult['has_previous_outfits'] as bool? ?? false;
      final bool hasNextOutfits = fetchResult['has_next_outfits'] as bool? ?? false;
      final String focusedDateStr = fetchResult['focused_date'] as String;
      final DateTime focusedDate = DateTime.parse(focusedDateStr);

      _logger.d('Parsed response type: hasPreviousOutfits=$hasPreviousOutfits, '
          'hasNextOutfits=$hasNextOutfits, focusedDate=$focusedDate');

      // Extract and convert outfits
      final List<DailyCalendarOutfit> dailyOutfits = (fetchResult['outfits'] as List<dynamic>?)
          ?.map<DailyCalendarOutfit>((outfit) => DailyCalendarOutfit.fromMap(outfit as Map<String, dynamic>))
          .toList() ?? [];

      _logger.d('Outfits parsed successfully: ${dailyOutfits.length} items');

      // Emit new state
      emit(DailyCalendarLoaded(
        dailyOutfits,
        hasPreviousOutfits: hasPreviousOutfits,
        hasNextOutfits: hasNextOutfits,
        focusedDate: focusedDate, // Optional if needed later
      ));
      _logger.d('State emitted: DailyCalendarLoaded with ${dailyOutfits.length} outfits');
    } catch (error) {
      _logger.e('Error fetching daily outfits: $error');
      emit(DailyCalendarError(error.toString()));
      _logger.d('State emitted: DailyCalendarError');
    }
  }

  Future<void> _onNavigateCalendar(
      NavigateCalendarEvent event,
      Emitter<DailyCalendarState> emit) async {
    _logger.d('Event received: NavigateCalendarEvent - Direction: ${event.direction}, Mode: ${event.navigationMode}');

    try {
      final success = await outfitSaveService.navigateCalendar(
        event.direction,
        event.navigationMode, // Use the navigationMode from the event
      );

      if (success) {
        _logger.i('Navigation successful');
        emit(MonthlyCalendarNavigationSuccessState());
        _logger.d('State emitted: MonthlyCalendarNavigationSuccessState');
      } else {
        _logger.e('Navigation failed');
        emit(MonthlyCalendarSaveFailureState());
        _logger.d('State emitted: MonthlyCalendarSaveFailureState');
      }
    } catch (error) {
      _logger.e('Error during calendar navigation: $error');
      emit(MonthlyCalendarSaveFailureState());
      _logger.d('State emitted: MonthlyCalendarSaveFailureState');
    }
  }
}
