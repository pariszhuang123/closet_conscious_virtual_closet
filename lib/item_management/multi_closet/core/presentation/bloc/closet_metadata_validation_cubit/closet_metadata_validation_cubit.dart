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
    String? monthsLater,
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

    if (closetType == 'disappear') {
      // Convert monthsLater to int
      final int? monthsLaterInt = monthsLater != null ? int.tryParse(monthsLater) : null;

      // Validate monthsLater as an integer
      if (monthsLaterInt == null || monthsLaterInt <= 0) {
        errors['monthsLater'] = 'invalidMonths';
      }
    }

    emit(state.copyWith(errorKeys: errors.isEmpty ? null : errors));
  }
}
