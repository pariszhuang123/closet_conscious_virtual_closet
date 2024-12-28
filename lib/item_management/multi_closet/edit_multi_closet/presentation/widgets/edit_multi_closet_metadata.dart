import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/form/custom_text_form.dart';
import '../../../create_multi_closet/presentation/widgets/permanent_closet_toggle.dart';
import '../../../create_multi_closet/presentation/widgets/public_private_toggle.dart';
import '../../../../../core/utilities/logger.dart';
import '../bloc/edit_closet_metadata_bloc/edit_closet_metadata_bloc.dart';

class EditMultiClosetMetadata extends StatefulWidget {
  final TextEditingController closetNameController;
  final ThemeData theme;
  final Map<String, String>? errorKeys;

  const EditMultiClosetMetadata({
    super.key,
    required this.closetNameController,
    required this.theme,
    this.errorKeys,
  });


  @override
  EditMultiClosetMetadataState createState() => EditMultiClosetMetadataState();
}

class EditMultiClosetMetadataState extends State<EditMultiClosetMetadata> {
  late TextEditingController _validDateController;
  static final CustomLogger _logger = CustomLogger('EditMultiClosetMetadata');

  @override
  void initState() {
    super.initState();
    _logger.i('Initializing EditMultiClosetMetadataState');
    final state = context.read<EditClosetMetadataBloc>().state;
    if (state is EditClosetMetadataAvailable && state.metadata.closetType == 'disappear') {
      _validDateController = TextEditingController(
        text: '${state.metadata.validDate.toLocal()}'.split(' ')[0],
      );
      _logger.d('Valid date initialized: ${state.metadata.validDate}');
    } else {
      _validDateController = TextEditingController();
      _logger.d('Valid date not initialized because closet type is not disappear');
    }
  }

  @override
  void didUpdateWidget(EditMultiClosetMetadata oldWidget) {
    super.didUpdateWidget(oldWidget);
    _logger.i('Widget updated');
    final state = context.read<EditClosetMetadataBloc>().state;
    if (state is EditClosetMetadataAvailable) {
      if (state.metadata.closetType == 'disappear') {
        _validDateController.text = '${state.metadata.validDate.toLocal()}'.split(' ')[0];
        _logger.d('Valid date controller updated: ${state.metadata.validDate}');
      } else {
        _validDateController.clear();
        _logger.d('Valid date controller cleared because closet type changed to permanent');
      }
    }
  }

  @override
  void dispose() {
    _logger.i('Disposing EditMultiClosetMetadataState');
    _validDateController.dispose();
    super.dispose();
  }

  String? _getLocalizedErrorMessage(String? errorKey) {
    if (errorKey == null) return null;

    switch (errorKey) {
      case 'closetNameCannotBeEmpty':
        return S.of(context).closetNameCannotBeEmpty;
      case 'reservedClosetNameError':
        return S.of(context).reservedClosetNameError;
      case 'validDateRequiredForDisappearCloset':
        return S.of(context).pleaseEnterValidDate;
      case 'dateCannotBeTodayOrEarlier':
        return S.of(context).dateCannotBeTodayOrEarlier;
      default:
        return null; // Fallback for unknown error keys
    }
  }


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EditClosetMetadataBloc, EditClosetMetadataState>(
      builder: (context, state) {
        _logger.d('Building widget with state: $state');
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
                    controller: widget.closetNameController,
                    labelText: S.of(context).closetName,
                    hintText: S.of(context).enterClosetName,
                    labelStyle: widget.theme.textTheme.bodyMedium,
                    hintStyle: widget.theme.textTheme.bodyMedium,
                    focusedBorderColor: widget.theme.colorScheme.primary,
                    enabledBorderColor: widget.theme.colorScheme.secondary,
                    errorText: _getLocalizedErrorMessage(widget.errorKeys?['closetName']),
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
                      setState(() {}); // Trigger a rebuild for toggle changes
                    },
                  ),
                  const SizedBox(height: 8),

                  // Conditional Metadata Fields
                  if (metadata.closetType == 'permanent') ...[
                    PublicPrivateToggle(
                      isPublic: metadata.isPublic,
                      onChanged: (isPublic) {
                        context.read<EditClosetMetadataBloc>().add(
                          MetadataChangedEvent(
                            updatedMetadata: metadata.copyWith(isPublic: isPublic),
                          ),
                        );
                      },
                    ),
                  ] else if (metadata.closetType == 'disappear') ...[
                    CustomTextFormField(
                      controller: _validDateController,
                      labelText: S.of(context).validDate,
                      hintText: S.of(context).selectDate,
                      labelStyle: widget.theme.textTheme.bodyMedium,
                      hintStyle: widget.theme.textTheme.bodyMedium,
                      focusedBorderColor: widget.theme.colorScheme.primary,
                      enabledBorderColor: widget.theme.colorScheme.secondary,
                      errorText: _getLocalizedErrorMessage(widget.errorKeys?['validDate']),
                      keyboardType: TextInputType.none,
                      onChanged: (_) {},
                      onTap: () async {
                        _logger.d('Date picker triggered');
                        final selectedDate = await showDatePicker(
                          context: context,
                          initialDate: metadata.validDate,
                          firstDate: DateTime(2024, 03, 11),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );

                        if (selectedDate != null && context.mounted) {
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
              style: TextStyle(color: widget.theme.colorScheme.error),
            ),
          );
        }

        // Fallback Widget
        return const SizedBox.shrink();
      },
    );
  }
}

