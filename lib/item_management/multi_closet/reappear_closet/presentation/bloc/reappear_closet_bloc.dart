import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/data/services/core_save_services.dart'; // Ensure the correct path

part 'reappear_closet_event.dart';
part 'reappear_closet_state.dart';


class ReappearClosetBloc extends Bloc<ReappearClosetEvent, ReappearClosetState> {
  final CoreSaveService coreSaveService;

  ReappearClosetBloc({
    required this.coreSaveService,
  }) : super(ReappearClosetInitialState()) {
    on<UpdateReappearClosetSharedPreferenceEvent>(_onUpdateSharedPreference);
  }

  // Update Shared Preferences
  Future<void> _onUpdateSharedPreference(
      UpdateReappearClosetSharedPreferenceEvent event,
      Emitter<ReappearClosetState> emit,
      ) async {
    try {
      await coreSaveService.updateSingleClosetSharedPreference(event.closetId);
      emit(ReappearClosetUpdatedState());
    } catch (error) {
      emit(ReappearClosetErrorState(error: error.toString()));
    }
  }
}
