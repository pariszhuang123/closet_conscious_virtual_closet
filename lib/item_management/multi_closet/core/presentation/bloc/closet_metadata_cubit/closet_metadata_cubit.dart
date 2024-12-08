import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/utilities/logger.dart';

part 'closet_metadata_state.dart';

class ClosetMetadataCubit extends Cubit<ClosetMetadataState> {
  final CustomLogger logger;

  ClosetMetadataCubit()
      : logger = CustomLogger('ClosetMetadataCubit'),
        super(const ClosetMetadataState(closetType: 'permanent', closetName: ''));

  void updateClosetName(String name) {
    logger.i('Updating closet name: $name');
    emit(state.copyWith(closetName: name));
  }

  void updateClosetType(String type) {
    logger.i('Updating closet type: $type');
    emit(state.copyWith(closetType: type));
  }

  void updateIsPublic(bool isPublic) {
    logger.i('Updating isPublic: $isPublic');
    emit(state.copyWith(isPublic: isPublic));
  }

  void updateMonthsLater(int? months) {
    logger.i('Updating monthsLater: $months');
    emit(state.copyWith(monthsLater: months));
  }
}
