import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/form/custom_text_form.dart';
import '../../../create_multi_closet/presentation/widgets/permanent_closet_toggle.dart';
import '../../../create_multi_closet/presentation/widgets/public_private_toggle.dart';
import '../../../../../core/utilities/logger.dart';
import '../bloc/edit_closet_metadata_bloc/edit_closet_metadata_bloc.dart';

class EditMultiClosetMetadata extends StatelessWidget {
  final TextEditingController closetNameController;
  final ThemeData theme;
  final Map<String, String>? errorKeys;

  static final CustomLogger _logger = CustomLogger('EditMultiClosetMetadata');

  const EditMultiClosetMetadata({
    super.key,
    required this.closetNameController,
    required this.theme,
    this.errorKeys,
  });

  @override
  Widget build(BuildContext context) {
    _logger.i('Rendering EditMultiClosetMetadata widget');
    _logger.i('Error keys passed: $errorKeys'); // Log the errors for debugging

    return BlocBuilder<EditClosetMetadataBloc, EditClosetMetadataState>(
      builder: (context, state) {
        if (state is EditClosetMetadataAvailable) {
          final metadata = state.metadata;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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
                      context.read<EditClosetMetadataBloc>().add(
                        MetadataChangedEvent(
                          updatedMetadata: metadata.copyWith(closetName: value),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),

                  // Closet Type Toggle
                  PermanentClosetToggle(
                    isPermanent: metadata.closetType == 'permanent',
                    onChanged: (value) {
                      final closetType = value ? 'permanent' : 'disappear';
                      _logger.d('Closet type changed to: $closetType');
                      context.read<EditClosetMetadataBloc>().add(
                        MetadataChangedEvent(
                          updatedMetadata: metadata.copyWith(closetType: closetType),
                        ),
                      );
                    },
                  ),
                  if (errorKeys?['closetType'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _translateError(errorKeys!['closetType']!, context),
                        style: TextStyle(color: theme.colorScheme.error),
                      ),
                    ),
                  const SizedBox(height: 8),

                  // Conditional Metadata Fields
                  if (metadata.closetType == 'permanent') ...[
                    PublicPrivateToggle(
                      isPublic: metadata.isPublic,
                      onChanged: (isPublic) {
                        _logger.d('Public/Private changed: $isPublic');
                        context.read<EditClosetMetadataBloc>().add(
                          MetadataChangedEvent(
                            updatedMetadata: metadata.copyWith(isPublic: isPublic),
                          ),
                        );
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
                  ] else if (metadata.closetType == 'disappear') ...[
                    CustomTextFormField(
                      controller: TextEditingController(
                        text: '${metadata.validDate.toLocal()}'.split(' ')[0], // No null check needed
                      ),
                      labelText: S.of(context).validDate,
                      hintText: S.of(context).selectDate,
                      labelStyle: theme.textTheme.bodyMedium,
                      hintStyle: theme.textTheme.bodyMedium,
                      focusedBorderColor: theme.colorScheme.primary,
                      enabledBorderColor: theme.colorScheme.secondary,
                      errorText: errorKeys?['validDate'],
                      keyboardType: TextInputType.none, // Prevent keyboard from showing up
                      onChanged: (_) {}, // No need for onChanged since we are using onTap
                      onTap: () async {
                        _logger.d('Date picker triggered');
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: metadata.validDate,
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );

                        if (selectedDate != null && context.mounted) { // Check if the widget is still in the tree
                          _logger.d('Valid date selected: $selectedDate');
                          context.read<EditClosetMetadataBloc>().add(
                            MetadataChangedEvent(
                              updatedMetadata: metadata.copyWith(validDate: selectedDate),
                            ),
                          );
                        }
                      },

                    ),
                  ],
                ],
              ),
            ),
          );
        }

        if (state is EditClosetMetadataLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EditClosetMetadataFailure) {
          return Center(
            child: Text(
              state.errorMessage,
              style: TextStyle(color: theme.colorScheme.error),
            ),
          );
        }

        // Fallback Widget
        return const SizedBox.shrink();
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
    default:
      return S.of(context).unknownError;
  }
}
