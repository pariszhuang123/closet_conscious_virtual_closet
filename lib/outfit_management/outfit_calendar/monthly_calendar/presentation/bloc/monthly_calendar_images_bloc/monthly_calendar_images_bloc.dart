import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/data/models/monthly_calendar_response.dart';
import '../../../../../../core/utilities/logger.dart';
import '../../../../../core/data/services/outfits_fetch_services.dart';
import '../../../../../core/data/services/outfits_save_services.dart';

part 'monthly_calendar_images_event.dart';
part 'monthly_calendar_images_state.dart';

class MonthlyCalendarImagesBloc
    extends Bloc<MonthlyCalendarImagesEvent, MonthlyCalendarImagesState> {
  final OutfitFetchService outfitFetchService;
  final OutfitSaveService outfitSaveService;
  final CustomLogger logger;

  MonthlyCalendarImagesBloc({
    required this.outfitFetchService,
    required this.outfitSaveService,
    CustomLogger? logger,
  })  : logger = logger ?? CustomLogger('MonthlyCalendarImagesBloc'),
        super(MonthlyCalendarImagesInitial()) {
    on<FetchMonthlyCalendarImages>(_onFetchMonthlyCalendarImages);
    on<UpdateFocusedDate>(_onUpdateFocusedDate);
    on<NavigateCalendarEvent>(_onNavigateCalendar);
  }


  Future<void> _onFetchMonthlyCalendarImages(
      FetchMonthlyCalendarImages event,
      Emitter<MonthlyCalendarImagesState> emit,
      ) async {
    emit(MonthlyCalendarImagesLoading());
    logger.d('Fetching monthly calendar images');

    try {
      // Fetch response which could be either a status string or a full response
      final result = await outfitFetchService.fetchMonthlyCalendarImages();

      result.match(
            (status) {
          // Handle different status cases
          if (status == 'no reviewed outfit') {
            logger.i('No reviewed outfit found');
            emit(NoReviewedOutfitState());
          } else if (status == 'no reviewed outfit with filter') {
            logger.i('No reviewed outfit found after applying filters');
            emit(NoFilteredReviewedOutfitState());
          } else {
            logger.e('Unexpected status: $status');
            emit(MonthlyCalendarImagesError('Unexpected status: $status'));
          }
        },
            (monthlyResponse) {
          // If full response is received, emit the success state
          logger.i('Fetched calendar data with ${monthlyResponse.calendarData.length} entries');

          emit(MonthlyCalendarImagesLoaded(
            calendarData: monthlyResponse.calendarData,
            focusedDate: monthlyResponse.focusedDate.toIso8601String(),
            startDate: monthlyResponse.startDate.toIso8601String(),
            endDate: monthlyResponse.endDate.toIso8601String(),
            isCalendarSelectable: monthlyResponse.isCalendarSelectable,
            hasPreviousOutfits: monthlyResponse.hasPreviousOutfits,
            hasNextOutfits: monthlyResponse.hasNextOutfits,
            selectedOutfitIds: event.selectedOutfitIds,  // Use selectedOutfitIds from event
          ));
        },
      );
    } catch (error) {
      logger.e('Error fetching calendar images: $error');
      emit(MonthlyCalendarImagesError('Failed to fetch calendar images.'));
    }
  }

  Future<void> _onUpdateFocusedDate(
      UpdateFocusedDate event,
      Emitter<MonthlyCalendarImagesState> emit,
      ) async {
    logger.d('Updating focused date using outfitId: ${event.outfitId}');

    try {
      final success = await outfitSaveService.updateFocusedDate(event.outfitId);

      if (success) {
        logger.i('Focused date updated successfully.');
        emit(FocusedDateUpdatedState(outfitId: event.outfitId));
      } else {
        logger.w('Failed to update focused date.');
        emit(FocusedDateUpdateFailedState('Failed to update focused date. Outfit may not exist or be unauthorized.'));
      }
    } catch (error) {
      logger.e('Error updating focused date: $error');
      emit(FocusedDateUpdateFailedState('An error occurred while updating focused date.'));
    }
  }

  Future<void> _onNavigateCalendar(
      NavigateCalendarEvent event,
      Emitter<MonthlyCalendarImagesState> emit) async {
    try {
      final success = await outfitSaveService.navigateCalendar(
        event.direction,
        event.navigationMode, // Use the navigationMode from the event
      );

      if (success) {
        logger.i('Navigation successful with selected outfits: ${event.selectedOutfitIds}');
        emit(MonthlyCalendarNavigationSuccessState(selectedOutfitIds: event.selectedOutfitIds));
      } else {
        logger.e('Navigation failed');
        emit(MonthlyCalendarSaveFailureState());
      }
    } catch (error) {
      logger.e('Error during calendar navigation: $error');
      emit(MonthlyCalendarSaveFailureState());
    }
  }

}
