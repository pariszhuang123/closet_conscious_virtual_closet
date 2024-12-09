import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/form/custom_text_form.dart';
import '../widgets/permanent_closet_toggle.dart';
import '../widgets/public_private_toggle.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../core/presentation/bloc/closet_metadata_cubit/closet_metadata_cubit.dart';

class CreateMultiClosetMetadata extends StatelessWidget {
  final TextEditingController closetNameController;
  final TextEditingController? monthsController;
  final String closetType; // 'permanent' or 'disappear'
  final bool isPublic; // true for public, false for private
  final ThemeData theme;
  final Map<String, String>? errorKeys;

  static final CustomLogger _logger = CustomLogger('CreateMultiClosetMetadata');

  const CreateMultiClosetMetadata({
    super.key,
    required this.closetNameController,
    this.monthsController,
    required this.closetType,
    required this.isPublic,
    required this.theme,
    this.errorKeys,
  });

  @override
  Widget build(BuildContext context) {
    _logger.i('Rendering CreateMultiClosetMetadata widget');
    _logger.i('Error keys passed: $errorKeys'); // Log the errors for debugging

    return BlocBuilder<ClosetMetadataCubit, ClosetMetadataState>(
      builder: (context, metadataState) {
        _logger.d('Current ClosetMetadataCubit State: $metadataState');

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Closet Name Input
                CustomTextFormField(
                  controller: closetNameController,
                  labelText: S.of(context).closetName,
                  hintText: S.of(context).enterClosetName,
                  labelStyle: theme.textTheme.bodyMedium,
                  hintStyle: theme.textTheme.bodyMedium,
                  focusedBorderColor: theme.colorScheme.primary,
                  enabledBorderColor: theme.colorScheme.secondary,
                  keyboardType: TextInputType.text,
                  errorText: errorKeys?['closetName'],
                  onChanged: (value) {
                    _logger.d('Closet name changed: $value');
                    _logger.d('ClosetName errorKey: ${errorKeys?['closetName']}');
                    context.read<ClosetMetadataCubit>().updateClosetName(value);
                  },
                ),
                const SizedBox(height: 16),

                // Closet Type Toggle
                PermanentClosetToggle(
                  isPermanent: metadataState.closetType == 'permanent',
                  onChanged: (value) {
                    final closetType = value ? 'permanent' : 'disappear';
                    _logger.d('Closet type changed to: $closetType');
                    context.read<ClosetMetadataCubit>().updateClosetType(closetType);
                  },
                ),
                if (errorKeys?['closetType'] != null) // Show closet type error if present
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _translateError(errorKeys!['closetType']!, context),
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ),
                const SizedBox(height: 16),

                // Conditional Metadata Fields
                if (metadataState.closetType == 'permanent') ...[
                  PublicPrivateToggle(
                    isPublic: metadataState.isPublic ?? false,
                    onChanged: (isPublic) {
                      _logger.d('Public/Private changed: $isPublic');
                      context.read<ClosetMetadataCubit>().updateIsPublic(isPublic);
                    },
                  ),
                  if (errorKeys?['isPublic'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _translateError(errorKeys!['isPublic']!, context),
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                ] else if (metadataState.closetType == 'disappear') ...[
                  CustomTextFormField(
                    controller: monthsController!,
                    labelText: S.of(context).months,
                    hintText: S.of(context).enterMonths,
                    labelStyle: theme.textTheme.bodyMedium,
                    hintStyle: theme.textTheme.bodyMedium,
                    focusedBorderColor: theme.colorScheme.primary,
                    enabledBorderColor: theme.colorScheme.secondary,
                    keyboardType: TextInputType.number,
                    errorText: errorKeys?['monthsLater'] != null
                        ? _translateError(errorKeys!['monthsLater']!, context)
                        : null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return S.of(context).pleaseEnterMonths; // Validation for empty input
                      }
                      final parsedValue = int.tryParse(value);
                      if (parsedValue == null || parsedValue <= 0) {
                        return S.of(context).pleaseEnterValidMonths; // Validation for invalid input
                      }
                      return null; // No error if validation passes
                    },
                    onChanged: (value) {
                      _logger.d('Months input changed: $value');
                      context.read<ClosetMetadataCubit>().updateMonthsLater(value);
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}


/// Translate error keys to localized messages
String _translateError(String errorKey, BuildContext context) {
  switch (errorKey) {
    case 'closetNameCannotBeEmpty':
      return S.of(context).closetNameCannotBeEmpty;
    case 'reservedClosetNameError':
      return S.of(context).reservedClosetNameError;
    case 'publicPrivateSelectionRequired':
      return S.of(context).publicPrivateSelectionRequired;
    case 'invalidMonths':
      return S.of(context).invalidMonths;
    default:
      return S.of(context).unknownError;
  }
}
