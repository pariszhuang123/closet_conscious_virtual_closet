import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/form/custom_text_form.dart';
import '../widgets/permanent_closet_toggle.dart';
import '../widgets/public_private_toggle.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../core/presentation/bloc/update_closet_metadata_cubit/update_closet_metadata_cubit.dart';

class CreateMultiClosetMetadata extends StatefulWidget  {
  final TextEditingController closetNameController;
  final TextEditingController? monthsController;
  final String closetType; // 'permanent' or 'disappear'
  final bool isPublic; // true for public, false for private
  final ThemeData theme;
  final Map<String, String>? errorKeys;

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
  CreateMultiClosetMetadataState createState() => CreateMultiClosetMetadataState();
}

class CreateMultiClosetMetadataState extends State<CreateMultiClosetMetadata> {
  late String closetType;
  late bool isPublic;
  late Map<String, String> errorKeys;
  static final CustomLogger _logger = CustomLogger('CreateMultiClosetMetadata');


  @override
  void initState() {
    super.initState();
    closetType = widget.closetType;
    isPublic = widget.isPublic;
    errorKeys = widget.errorKeys ?? {};
  }

  String? _getLocalizedErrorMessage(String? errorKey) {
    if (errorKey == null) return null;

    switch (errorKey) {
      case 'closetNameCannotBeEmpty':
        return S.of(context).closetNameCannotBeEmpty;
      case 'reservedClosetNameError':
        return S.of(context).reservedClosetNameError;
      case 'publicPrivateSelectionRequired':
        return S.of(context).publicPrivateSelectionRequired;
      case 'invalidMonthsValue':
        return S.of(context).invalidMonthsValue;
      case 'monthsCannotExceed12':
        return S.of(context).monthsCannotExceed12;
      default:
        return S.of(context).unknownError;
    }
  }

@override
  Widget build(BuildContext context) {
    _logger.i('Rendering CreateMultiClosetMetadata widget');
    _logger.i('Error keys passed: ${widget.errorKeys}'); // Log the errors for debugging

    return BlocBuilder<UpdateClosetMetadataCubit, UpdateClosetMetadataState>(
      builder: (context, metadataState) {
        _logger.d('Current ClosetMetadataCubit State: $metadataState');

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
                  keyboardType: TextInputType.text,
                  errorText: _getLocalizedErrorMessage(widget.errorKeys?['closetName']),
                  onChanged: (value) {
                    _logger.d('Closet name changed: $value');
                    context.read<UpdateClosetMetadataCubit>().updateClosetName(value);
                  },
                ),
                const SizedBox(height: 8),

                // Closet Type Toggle
                PermanentClosetToggle(
                  isPermanent: metadataState.closetType == 'permanent',
                  onChanged: (value) {
                    final closetType = value ? 'permanent' : 'disappear';
                    _logger.d('Closet type changed to: $closetType');
                    context.read<UpdateClosetMetadataCubit>().updateClosetType(closetType);
                  },
                ),
                if (errorKeys['closetType'] != null) // Show closet type error if present
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      _getLocalizedErrorMessage(widget.errorKeys!['closetType']) ?? '',
                      style: TextStyle(color: widget.theme.colorScheme.error),
                    ),
                  ),
                const SizedBox(height: 8),

                // Conditional Metadata Fields
                if (metadataState.closetType == 'permanent') ...[
                  PublicPrivateToggle(
                    isPublic: metadataState.isPublic ?? false,
                    onChanged: (isPublic) {
                      _logger.d('Public/Private changed: $isPublic');
                      context.read<UpdateClosetMetadataCubit>().updateIsPublic(isPublic);
                    },
                  ),
                  if (errorKeys['isPublic'] != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        _getLocalizedErrorMessage(widget.errorKeys!['isPublic']) ?? '',
                        style: TextStyle(color: widget.theme.colorScheme.error),
                      ),
                    ),
                ] else if (metadataState.closetType == 'disappear') ...[
                  CustomTextFormField(
                    controller: widget.monthsController!,
                    labelText: S.of(context).months,
                    hintText: S.of(context).enterMonths,
                    labelStyle: widget.theme.textTheme.bodyMedium,
                    hintStyle: widget.theme.textTheme.bodyMedium,
                    focusedBorderColor: widget.theme.colorScheme.primary,
                    enabledBorderColor: widget.theme.colorScheme.secondary,
                    keyboardType: TextInputType.number,
                    errorText: _getLocalizedErrorMessage(widget.errorKeys?['monthsLater']),
                    onChanged: (value) {
                      _logger.d('Months input changed: $value');
                      context.read<UpdateClosetMetadataCubit>().updateMonthsLater(value);
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

