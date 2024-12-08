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
  final String closetType; // 'permanent' or 'temporary'
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
                  focusedBorderColor: theme.colorScheme.primary,
                  enabledBorderColor: theme.colorScheme.secondary,
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    _logger.d('Closet name changed: $value');
                    context.read<ClosetMetadataCubit>().updateClosetName(value);
                  },
                ),
                const SizedBox(height: 16),

                // Closet Type Toggle
                PermanentClosetToggle(
                  isPermanent: metadataState.closetType == 'permanent',
                  onChanged: (value) {
                    final closetType = value ? 'permanent' : 'temporary';
                    _logger.d('Closet type changed to: $closetType');
                    context.read<ClosetMetadataCubit>().updateClosetType(closetType);
                  },
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
                ] else if (metadataState.closetType == 'temporary') ...[
                  CustomTextFormField(
                    controller: monthsController!,
                    labelText: S.of(context).months,
                    hintText: S.of(context).enterMonths,
                    labelStyle: theme.textTheme.bodyMedium,
                    focusedBorderColor: theme.colorScheme.primary,
                    enabledBorderColor: theme.colorScheme.secondary,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final months = int.tryParse(value);
                      _logger.d('Months input changed: $months');
                      context.read<ClosetMetadataCubit>().updateMonthsLater(months);
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

