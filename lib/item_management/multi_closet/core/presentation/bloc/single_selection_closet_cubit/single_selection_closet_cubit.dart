import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../../core/utilities/logger.dart';

part 'single_selection_closet_state.dart';

class SingleSelectionClosetCubit extends Cubit<SingleSelectionClosetState> {
  final CustomLogger logger;

  SingleSelectionClosetCubit()
      : logger = CustomLogger('SingleSelectionClosetCubit'),
        super(const SingleSelectionClosetState());

  void selectCloset(String closetId) {
    logger.d('Closet selected: $closetId');
    emit(state.copyWith(selectedClosetId: closetId));
  }
}
