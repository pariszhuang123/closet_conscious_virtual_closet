import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utilities/logger.dart';

part 'closet_metadata_validation_state.dart';

class ClosetMetadataValidationCubit extends Cubit<ClosetMetadataValidationState> {
  final CustomLogger logger;

  ClosetMetadataValidationCubit()
      : logger = CustomLogger('ClosetMetadataValidationCubit'),
        super(ClosetMetadataValidationState(closetType: 'permanent'));

  // Update closet name
  void updateClosetName(String name) {
    logger.i('Updating closet name: $name');
    emit(state.copyWith(closetName: name));
  }

  // Update closet type
  void updateClosetType(String type) {
    logger.i('Updating closet type: $type');
    emit(state.copyWith(closetType: type));
  }

  // Update public/private visibility
  void updateIsPublic(bool isPublic) {
    logger.i('Updating isPublic: $isPublic');
    emit(state.copyWith(isPublic: isPublic));
  }

  // Update months later
  void updateMonthsLater(int? months) {
    logger.i('Updating monthsLater: $months');
    emit(state.copyWith(monthsLater: months));
  }

  void validateFields() {
    logger.i('Validating closet details for closetName: ${state.closetName}');

    final errors = <String, String>{};
    if (state.closetName.isEmpty) errors['closetName'] = 'Closet name is required.';
    if (state.closetType == 'permanent' && state.isPublic == null) {
      errors['isPublic'] = 'Public visibility is required for permanent closets.';
    }
    if (state.closetType == 'temporary' && (state.monthsLater == null || state.monthsLater! < 0)) {
      errors['monthsLater'] = 'Valid monthsLater is required for temporary closets.';
    }
    emit(state.copyWith(errorKeys: errors.isEmpty ? null : errors));
  }
}
