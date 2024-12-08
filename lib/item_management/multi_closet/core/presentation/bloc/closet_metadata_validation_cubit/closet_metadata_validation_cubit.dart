import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/utilities/logger.dart';

part 'closet_metadata_validation_state.dart';

class ClosetMetadataValidationCubit extends Cubit<ClosetMetadataValidationState> {
  final CustomLogger logger;

  ClosetMetadataValidationCubit()
      : logger = CustomLogger('ClosetMetadataValidationCubit'),
        super(ClosetMetadataValidationState.initial());

  void validateFields({
    required String closetName,
    required String closetType,
    bool? isPublic,
    int? monthsLater,
  }) {
    logger.i('Validating closet metadata fields');
    final errors = <String, String>{};

    // Validate closet name
    if (closetName.isEmpty) {
      errors['closetName'] = 'closetNameCannotBeEmpty';
    } else if (closetName == "cc_closet") {
      errors['closetName'] = 'reservedClosetNameError';
    }

    // Validate based on closet type
    if (closetType == 'permanent' && isPublic == null) {
      errors['isPublic'] = 'publicPrivateSelectionRequired';
    }

    if (closetType == 'temporary' && (monthsLater == null || monthsLater < 0)) {
      errors['monthsLater'] = 'invalidMonths';
    }

    emit(state.copyWith(errorKeys: errors.isEmpty ? null : errors));
  }
}
