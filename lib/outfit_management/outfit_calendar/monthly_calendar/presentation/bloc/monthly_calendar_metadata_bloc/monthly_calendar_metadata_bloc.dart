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
  final OutfitFetchService outfitFetchService;
  final OutfitSaveService outfitSaveService;
  final CustomLogger logger;

  List<CalendarMetadata> _metadataList = [];

  MonthlyCalendarMetadataBloc({
    required this.outfitFetchService,
    required this.outfitSaveService,
    CustomLogger? logger,
  })
      : logger = logger ?? CustomLogger('MonthlyCalendarMetadataBloc'),
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
    logger.d('Received FetchMonthlyCalendarMetadataEvent: $event');
    emit(MonthlyCalendarLoadingState());
    logger.d('Emitted MonthlyCalendarLoadingState');
    try {
      _metadataList = await outfitFetchService.fetchCalendarMetadata();

      final updatedMetadataList = _metadataList.map((metadata) {
        return metadata.copyWith(eventName: metadata.computedEventName);
      }).toList();

      logger.i('Fetched ${_metadataList.length} metadata entries');
      emit(MonthlyCalendarLoadedState(metadataList: updatedMetadataList));
      logger.d('Emitted MonthlyCalendarLoadedState');
    } catch (error) {
      logger.e('Error fetching metadata: $error');
      emit(MonthlyCalendarSaveFailureState(error.toString()));
      logger.d('Emitted MonthlyCalendarSaveFailureState');
    }
  }

  void _onUpdateMetadata(
      UpdateSelectedMetadataEvent event,
      Emitter<MonthlyCalendarMetadataState> emit) {
    logger.d('Received UpdateSelectedMetadataEvent: $event');
    if (state is MonthlyCalendarLoadedState) {
      final currentState = state as MonthlyCalendarLoadedState;
      final updatedMetadata = currentState.metadataList.first.copyWith(
        eventName: event.updatedMetadata.eventName,
        feedback: event.updatedMetadata.feedback,
        ignoreEventName: event.updatedMetadata.ignoreEventName,
        isCalendarSelectable: event.updatedMetadata.isCalendarSelectable,
        isOutfitActive: event.updatedMetadata.isOutfitActive,
      );
      emit(MonthlyCalendarLoadedState(metadataList: [updatedMetadata]));
      logger.d('Emitted MonthlyCalendarLoadedState with updated metadata');
    } else {
      logger.w('Cannot update metadata in non-loaded state: $state');
    }
  }

  Future<void> _onSaveMetadata(
      SaveMetadataEvent event,
      Emitter<MonthlyCalendarMetadataState> emit) async {
    logger.d('Received SaveMetadataEvent: $event');
    if (state is! MonthlyCalendarLoadedState) {
      logger.w('Save operation attempted in an invalid state: $state');
      emit(MonthlyCalendarSaveFailureState('Invalid state for saving metadata'));
      logger.d('Emitted MonthlyCalendarSaveFailureState');
      return;
    }

    final currentState = state as MonthlyCalendarLoadedState;
    final metadata = currentState.metadataList.first;

    emit(MonthlyCalendarSaveInProgressState());
    logger.d('Emitted MonthlyCalendarSaveInProgressState');
    try {
      final success = await outfitSaveService.saveCalendarMetadata(metadata);

      if (!success) {
        logger.e('Failed to save metadata');
        emit(MonthlyCalendarSaveFailureState('Failed to save metadata'));
        logger.d('Emitted MonthlyCalendarSaveFailureState');
        return;
      }

      logger.i('Metadata saved successfully: isCalendarSelectable = ${metadata.isCalendarSelectable}');
      emit(MonthlyCalendarSaveSuccessState());
      logger.d('Emitted MonthlyCalendarSaveSuccessState');

      // Re-emit the updated state to reflect changes
      emit(MonthlyCalendarLoadedState(metadataList: [metadata]));
      logger.d('Emitted MonthlyCalendarLoadedState after save');
    } catch (error) {
      logger.e('Error saving metadata: $error');
      emit(MonthlyCalendarSaveFailureState(error.toString()));
      logger.d('Emitted MonthlyCalendarSaveFailureState');
    }
  }

  Future<void> _onResetMetadata(ResetMetadataEvent event,
      Emitter<MonthlyCalendarMetadataState> emit) async {
    logger.d('ResetMetadataEvent triggered.');
    emit(MonthlyCalendarLoadingState());
    try {
      final success = await outfitSaveService.resetMonthlyCalendar();
      if (success) {
        logger.i('Monthly calendar reset successfully.');
        emit(MonthlyCalendarResetSuccessState());
      } else {
        logger.e('Failed to reset metadata.');
        emit(MonthlyCalendarSaveFailureState('Failed to reset metadata'));
      }
    } catch (error) {
      logger.e('Error during reset operation: $error');
      emit(MonthlyCalendarSaveFailureState(error.toString()));
    }
  }
}