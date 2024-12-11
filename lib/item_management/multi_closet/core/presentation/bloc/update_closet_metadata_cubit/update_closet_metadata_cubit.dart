import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/utilities/logger.dart';

part 'update_closet_metadata_state.dart';

class UpdateClosetMetadataCubit extends Cubit<UpdateClosetMetadataState> {
  final CustomLogger logger;

  UpdateClosetMetadataCubit()
      : logger = CustomLogger('UpdateClosetMetadataCubit'),
        super(const UpdateClosetMetadataState(closetType: 'permanent', closetName: ''));

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

  void updateMonthsLater(String? months) {
    logger.i('Updating monthsLater: $months');
    emit(state.copyWith(monthsLater: months));
  }
  
}
