import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/data/models/calendar_metadata.dart';
import '../../../../../../core/utilities/logger.dart';
import '../../../../../core/data/services/outfits_fetch_services.dart';
import '../../../../../core/data/services/outfits_save_services.dart';

part 'monthly_calendar_metadata_event.dart';
part 'monthly_calendar_metadata_state.dart';


class MonthlyCalendarMetadataBloc
    extends Bloc<MonthlyCalendarMetadataEvent, MonthlyCalendarMetadataState> {
  final OutfitFetchService fetchService;
  final OutfitSaveService saveService;
  final CustomLogger logger;

  List<CalendarMetadata> _metadataList = [];

  MonthlyCalendarMetadataBloc({
    required this.fetchService,
    required this.saveService,
    CustomLogger? logger,
  })  : logger = logger ?? CustomLogger('MonthlyCalendarMetadataBloc'),
        super(MonthlyCalendarInitialState()) {
    on<FetchMonthlyCalendarMetadataEvent>(_onFetchMetadata);
    on<UpdateSelectedMetadataEvent>(_onUpdateMetadata);
    on<SaveMetadataEvent>(_onSaveMetadata);
    on<ResetMetadataEvent>(_onResetMetadata);

    this.logger.i('MonthlyCalendarMetadataBloc initialized');
  }

  Future<void> _onFetchMetadata(
      FetchMonthlyCalendarMetadataEvent event,
      Emitter<MonthlyCalendarMetadataState> emit) async {
    emit(MonthlyCalendarLoadingState());
    logger.d('Fetching calendar metadata');
    try {
      _metadataList = await fetchService.fetchCalendarMetadata();

      final updatedMetadataList = _metadataList.map((metadata) {
        return metadata.copyWith(eventName: metadata.computedEventName);
      }).toList();

      logger.i('Fetched ${_metadataList.length} metadata entries');
      emit(MonthlyCalendarLoadedState(metadataList: updatedMetadataList));
    } catch (error) {
      logger.e('Error fetching metadata: $error');
      emit(MonthlyCalendarSaveFailureState(error.toString()));
    }
  }

  void _onUpdateMetadata(
      UpdateSelectedMetadataEvent event,
      Emitter<MonthlyCalendarMetadataState> emit) {
    if (state is MonthlyCalendarLoadedState) {
      final currentState = state as MonthlyCalendarLoadedState;

      // Update the specific metadata in the list
      final updatedMetadata = currentState.metadataList.first.copyWith(
        eventName: event.updatedMetadata.eventName,
        feedback: event.updatedMetadata.feedback,
        ignoreEventName: event.updatedMetadata.ignoreEventName,
        isCalendarSelectable: event.updatedMetadata.isCalendarSelectable,
        isOutfitActive: event.updatedMetadata.isOutfitActive,
      );


      // Emit the updated state
      emit(MonthlyCalendarLoadedState(metadataList: [updatedMetadata]));
    } else {
      logger.w('Cannot update metadata in non-loaded state');
    }
  }

  Future<void> _onSaveMetadata(
      SaveMetadataEvent event,
      Emitter<MonthlyCalendarMetadataState> emit) async {
    if (state is! MonthlyCalendarLoadedState) {
      logger.w('Save operation attempted in an invalid state');
      emit(MonthlyCalendarSaveFailureState('Invalid state for saving metadata'));
      return;
    }

    final currentState = state as MonthlyCalendarLoadedState;
    final metadata = currentState.metadataList.first; // Get the latest metadata

    emit(MonthlyCalendarSaveInProgressState());
    logger.d('Saving updated metadata: isCalendarSelectable = ${metadata.isCalendarSelectable}');

    try {
      final success = await saveService.saveCalendarMetadata(metadata);

      if (!success) {
        logger.e('Failed to save metadata');
        emit(MonthlyCalendarSaveFailureState('Failed to save metadata'));
        return;
      }

      logger.i('Metadata saved successfully: isCalendarSelectable = ${metadata.isCalendarSelectable}');
      emit(MonthlyCalendarSaveSuccessState());

      // Re-emit the updated state to reflect changes
      emit(MonthlyCalendarLoadedState(metadataList: [metadata]));
    } catch (error) {
      logger.e('Error saving metadata: $error');
      emit(MonthlyCalendarSaveFailureState(error.toString()));
    }
  }

  Future<void> _onResetMetadata(ResetMetadataEvent event,
      Emitter<MonthlyCalendarMetadataState> emit) async {
    emit(MonthlyCalendarLoadingState());
    logger.d('Resetting monthly calendar metadata');

    try {
      final success = await saveService.resetMonthlyCalendar();

      if (success) {
        logger.i('Monthly calendar reset successfully');
        emit(MonthlyCalendarResetSuccessState());
      } else {
        logger.e('Failed to reset monthly calendar metadata');
        emit(MonthlyCalendarSaveFailureState('Failed to reset metadata'));
      }
    } catch (error) {
      logger.e('Error during reset operation: $error');
      emit(MonthlyCalendarSaveFailureState(error.toString()));
    }
  }
}
