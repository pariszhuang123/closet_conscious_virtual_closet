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
  final OutfitFetchService fetchService;
  final OutfitSaveService saveService;
  final CustomLogger logger;

  final List<String> _selectedOutfitIds = [];

  MonthlyCalendarImagesBloc({
    required this.fetchService,
    required this.saveService,
    CustomLogger? logger,
  })  : logger = logger ?? CustomLogger('MonthlyCalendarImagesBloc'),
        super(MonthlyCalendarImagesInitial()) {
    on<FetchMonthlyCalendarImages>(_onFetchMonthlyCalendarImages);
    on<CalendarInteraction>(_onCalendarInteraction);
    on<ToggleOutfitSelection>(_onToggleOutfitSelection);
    on<FetchActiveItems>(_onFetchActiveItems);
    on<UpdateFocusedDate>(_onUpdateFocusedDate);
  }

  Future<void> _onFetchMonthlyCalendarImages(
      FetchMonthlyCalendarImages event,
      Emitter<MonthlyCalendarImagesState> emit,
      ) async {
    emit(MonthlyCalendarImagesLoading());
    logger.d('Fetching monthly calendar images');

    try {
      final response = await fetchService.fetchMonthlyCalendarImages() as Map<String, dynamic>;

      final status = response['status'] as String;

      switch (status) {
        case 'no reviewed outfit':
          logger.i('No reviewed outfits found');
          emit(NoReviewedOutfit());
          break;

        case 'no reviewed outfit with filter':
          logger.i('No outfits matching the filters');
          emit(NoOutfitsMatchingFilter());
          break;

        case 'success':
          final calendarData = (response['calendar_data'] as List<dynamic>)
              .map((data) => CalendarData.fromMap(data as Map<String, dynamic>))
              .toList();
          final focusedDate = response['focused_date'] as String;
          final startDate = response['start_date'] as String;
          final endDate = response['end_date'] as String;

          logger.i('Fetched calendar data with $calendarData entries');
          emit(MonthlyCalendarImagesLoaded(calendarData, focusedDate, startDate, endDate));
          break;

        default:
          logger.e('Unexpected response status: $status');
          emit(MonthlyCalendarImagesError('Unexpected response status: $status'));
          break;
      }
    } catch (error) {
      logger.e('Error fetching calendar images: $error');
      emit(MonthlyCalendarImagesError('Failed to fetch calendar images.'));
    }
  }


  Future<void> _onCalendarInteraction(
      CalendarInteraction event,
      Emitter<MonthlyCalendarImagesState> emit,
      ) async {
    if (event.isCalendarSelectable) {
      // Outfit selection logic when selectable
      if (event.outfitId != null) {
        add(ToggleOutfitSelection(outfitId: event.outfitId!));
      } else {
        logger.d('Date selected without an outfit ID; no action triggered.');
        // No action needed if outfitId is null
      }
    } else {
      // Focused date update logic when not selectable
      if (event.outfitId != null) {
        add(UpdateFocusedDate(
          selectedDate: event.selectedDate,
          outfitId: event.outfitId!,
        ));
      } else {
        logger.d('Date selected without an outfit ID; no action triggered.');
        // No action needed if outfitId is null
      }
    }
  }

  void _onToggleOutfitSelection(
      ToggleOutfitSelection event,
      Emitter<MonthlyCalendarImagesState> emit,
      ) {
    if (_selectedOutfitIds.contains(event.outfitId)) {
      _selectedOutfitIds.remove(event.outfitId);
      logger.d('Deselected outfit ID: ${event.outfitId}');
    } else {
      _selectedOutfitIds.add(event.outfitId);
      logger.d('Selected outfit ID: ${event.outfitId}');
    }

    emit(OutfitSelectionUpdated(List.from(_selectedOutfitIds)));
  }

  Future<void> _onFetchActiveItems(
      FetchActiveItems event,
      Emitter<MonthlyCalendarImagesState> emit,
      ) async {
    if (_selectedOutfitIds.isEmpty) {
      logger.w('No outfits selected for fetching active items');
      emit(MonthlyCalendarImagesError('No outfits selected.'));
      return;
    }

    emit(MonthlyCalendarImagesLoading());
    logger.d('Fetching active items for selected outfits: $_selectedOutfitIds');

    try {
      final itemIds = await fetchService.getActiveItemsFromCalendar(_selectedOutfitIds);
      logger.i('Active items fetched successfully for selected outfits');
      emit(ActiveItemsFetched(itemIds));
    } catch (error) {
      logger.e('Error fetching active items: $error');
      emit(MonthlyCalendarImagesError('Failed to fetch active items.'));
    }
  }

  Future<void> _onUpdateFocusedDate(
      UpdateFocusedDate event,
      Emitter<MonthlyCalendarImagesState> emit,
      ) async {

    logger.d('Updating focused date: ${event.selectedDate} for outfit ID: ${event.outfitId}');
    try {
      final success = await saveService.updateFocusedDate(event.selectedDate.toIso8601String());

      if (success) {
        logger.i('Focused date updated successfully.');
        emit(FocusedDateUpdated());
      } else {
        logger.e('Failed to update focused date.');
        emit(FocusedDateUpdateFailed('Failed to update focused date.'));
      }
    } catch (error) {
      logger.e('Error updating focused date: $error');
      emit(FocusedDateUpdateFailed('An error occurred while updating focused date.'));
    }
  }
}
