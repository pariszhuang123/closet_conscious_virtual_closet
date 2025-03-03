import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../../core/utilities/logger.dart';
import '../../../../../../core/data/services/core_fetch_services.dart';
import '../../../../../../core/data/services/core_save_services.dart';

part 'focus_or_create_closet_event.dart';
part 'focus_or_create_closet_state.dart';

class FocusOrCreateClosetBloc extends Bloc<FocusOrCreateClosetEvent, FocusOrCreateClosetState> {
  final CoreFetchService coreFetchService;
  final CoreSaveService coreSaveService;
  final CustomLogger logger = CustomLogger('FocusOrCreateClosetBloc');

  FocusOrCreateClosetBloc({
    required this.coreFetchService,
    required this.coreSaveService,
  }) : super(FocusOrCreateClosetInitial()) {
    on<FetchFocusOrCreateCloset>(_onFetch);
    on<UpdateFocusOrCreateCloset>(_onUpdate);
  }

  Future<void> _onFetch(
      FetchFocusOrCreateCloset event, Emitter<FocusOrCreateClosetState> emit) async {
    try {
      emit(FocusOrCreateClosetLoading());
      final isSelectable = await coreFetchService.fetchCalendarSelection();
      emit(FocusOrCreateClosetLoaded(isCalendarSelectable: isSelectable));
    } catch (e) {
      logger.e('Error fetching focus/create closet state: $e');
      emit(FocusOrCreateClosetError());
    }
  }

  Future<void> _onUpdate(
      UpdateFocusOrCreateCloset event, Emitter<FocusOrCreateClosetState> emit) async {
    try {
      emit(FocusOrCreateClosetSaving());
      final success = await coreSaveService.saveCalendarSelection(event.isSelectable);
      if (success) {
        emit(FocusOrCreateClosetLoaded(isCalendarSelectable: event.isSelectable));
      } else {
        emit(FocusOrCreateClosetError());
      }
    } catch (e) {
      logger.e('Error updating focus/create closet state: $e');
      emit(FocusOrCreateClosetError());
    }
  }
}
