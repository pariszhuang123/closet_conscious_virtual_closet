import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/data/models/monthly_calendar_response.dart';
import '../../../../../../core/utilities/logger.dart';
import '../../../../../core/data/services/outfits_fetch_services.dart';
import '../../../../../core/data/services/outfits_save_services.dart';

part 'monthly_calendar_images_event.dart';
part 'monthly_calendar_images_state.dart';

List<String> _initialSelectedOutfits = [];

class MonthlyCalendarImagesBloc
    extends Bloc<MonthlyCalendarImagesEvent, MonthlyCalendarImagesState> {
  final OutfitFetchService fetchService;
  final OutfitSaveService saveService;
  final CustomLogger logger;

  MonthlyCalendarImagesBloc({
    required this.fetchService,
    required this.saveService,
    CustomLogger? logger,
  })  : logger = logger ?? CustomLogger('MonthlyCalendarImagesBloc'),
        super(MonthlyCalendarImagesInitial()) {
    on<SetInitialSelectedOutfits>(_onSetInitialSelectedOutfits);
    on<FetchMonthlyCalendarImages>(_onFetchMonthlyCalendarImages);
    on<ToggleOutfitSelection>(_onToggleOutfitSelection);
    on<FetchActiveItems>(_onFetchActiveItems);
    on<UpdateFocusedDate>(_onUpdateFocusedDate);
    on<NavigateCalendarEvent>(_onNavigateCalendar);
  }

  void _onSetInitialSelectedOutfits(
      SetInitialSelectedOutfits event,
      Emitter<MonthlyCalendarImagesState> emit,
      ) {
    final currentState = state;
    if (currentState is MonthlyCalendarImagesLoaded) {
      // If we are already loaded, just copy with new outfits
      emit(currentState.copyWith(selectedOutfitIds: event.selectedOutfitIds));
    } else {
      // If not loaded, stash them for when we do load
      _initialSelectedOutfits = event.selectedOutfitIds;
    }
    logger.d('Set initial selected outfits: ${event.selectedOutfitIds}');
  }


  Future<void> _onFetchMonthlyCalendarImages(
      FetchMonthlyCalendarImages event,
      Emitter<MonthlyCalendarImagesState> emit,
      ) async {
    emit(MonthlyCalendarImagesLoading());
    logger.d('Fetching monthly calendar images');

    try {
      // Fetch response which could be either a status string or a full response
      final result = await fetchService.fetchMonthlyCalendarImages();

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

          List<String> existingIds = [];
          if (state is MonthlyCalendarImagesLoaded) {
            existingIds =
                (state as MonthlyCalendarImagesLoaded).selectedOutfitIds;
          } else {
            // not loaded yet—use the “initial” stash
            existingIds = _initialSelectedOutfits;
          }

          emit(MonthlyCalendarImagesLoaded(
            calendarData: monthlyResponse.calendarData,
            focusedDate: monthlyResponse.focusedDate.toIso8601String(),
            startDate: monthlyResponse.startDate.toIso8601String(),
            endDate: monthlyResponse.endDate.toIso8601String(),
            isCalendarSelectable: monthlyResponse.isCalendarSelectable,
            hasPreviousOutfits: monthlyResponse.hasPreviousOutfits,
            hasNextOutfits: monthlyResponse.hasNextOutfits,
            selectedOutfitIds: existingIds, // keep existing selections
          ));
        },
      );
    } catch (error) {
      logger.e('Error fetching calendar images: $error');
      emit(MonthlyCalendarImagesError('Failed to fetch calendar images.'));
    }
  }

  void _onToggleOutfitSelection(
      ToggleOutfitSelection event,
      Emitter<MonthlyCalendarImagesState> emit,
      ) {
    final currentState = state;

    if (currentState is MonthlyCalendarImagesLoaded) {
      List<String> updatedSelectedOutfits = List.from(currentState.selectedOutfitIds);

      if (updatedSelectedOutfits.contains(event.outfitId)) {
        updatedSelectedOutfits.remove(event.outfitId);
        logger.d('Deselected outfit ID: ${event.outfitId}');
      } else {
        updatedSelectedOutfits.add(event.outfitId);
        logger.d('Selected outfit ID: ${event.outfitId}');
      }

      // Emit a new MonthlyCalendarImagesLoaded state with updated selected outfits
      emit(currentState.copyWith(selectedOutfitIds: updatedSelectedOutfits));
    }
  }

  Future<void> _onFetchActiveItems(
      FetchActiveItems event,
      Emitter<MonthlyCalendarImagesState> emit,
      ) async {
    if (event.selectedOutfitIds.isEmpty) {
      logger.w('No outfits selected for fetching active items');
      emit(MonthlyCalendarImagesError('No outfits selected.'));
      return;
    }

    emit(MonthlyCalendarImagesLoading());
    logger.d('Fetching active items for selected outfits: ${event.selectedOutfitIds}');

    try {
      final List<String> activeItemIds = await fetchService.getActiveItemsFromCalendar(event.selectedOutfitIds);
      logger.i('Active items fetched successfully for selected outfits');
      emit(ActiveItemsFetched(activeItemIds));
    } catch (error) {
      logger.e('Error fetching active items: $error');
      emit(MonthlyCalendarImagesError('Failed to fetch active items.'));
    }
  }

  Future<void> _onUpdateFocusedDate(
      UpdateFocusedDate event,
      Emitter<MonthlyCalendarImagesState> emit,
      ) async {
    logger.d('Updating focused date using outfitId: ${event.outfitId}');

    try {
      final success = await saveService.updateFocusedDate(event.outfitId);

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
      final success = await saveService.navigateCalendar(
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
