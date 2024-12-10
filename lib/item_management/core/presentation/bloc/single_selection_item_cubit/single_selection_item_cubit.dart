import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/utilities/logger.dart';

part 'single_selection_item_state.dart';

class SingleSelectionItemCubit extends Cubit<SingleSelectionItemState> {
  final CustomLogger logger;

  SingleSelectionItemCubit()
      : logger = CustomLogger('SingleSelectionItemCubit'),
        super(const SingleSelectionItemState());

  void selectItem(String itemId) {
    logger.d('Item selected: $itemId');
    emit(state.copyWith(selectedItemId: itemId));
  }
}
