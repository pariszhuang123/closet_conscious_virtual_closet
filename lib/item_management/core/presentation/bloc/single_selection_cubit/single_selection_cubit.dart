import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/utilities/logger.dart';

part 'single_selection_state.dart';

class SingleSelectionCubit extends Cubit<SingleSelectionState> {
  final CustomLogger logger;

  SingleSelectionCubit()
      : logger = CustomLogger('SingleSelectionCubit'),
        super(const SingleSelectionState());

  void selectItem(String itemId) {
    logger.d('Item selected: $itemId');
    emit(state.copyWith(selectedItemId: itemId));
  }
}
