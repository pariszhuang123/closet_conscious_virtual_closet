import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/utilities/logger.dart';

part 'single_selection_outfit_state.dart';

class SingleSelectionOutfitCubit extends Cubit<SingleSelectionOutfitState> {
  final CustomLogger logger;

  SingleSelectionOutfitCubit()
      : logger = CustomLogger('SingleSelectionOutfitCubit'),
        super(const SingleSelectionOutfitState());

  void selectOutfit(String outfitId) {
    logger.d('Outfit selected: $outfitId');
    emit(state.copyWith(selectedOutfitId: outfitId));
  }
}
