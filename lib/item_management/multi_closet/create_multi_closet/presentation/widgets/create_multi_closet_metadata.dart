import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/form/custom_text_form.dart';
import '../widgets/permanent_closet_toggle.dart';
import '../widgets/public_private_toggle.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../core/presentation/bloc/closet_metadata_validation_cubit/closet_metadata_validation_cubit.dart';


class CreateMultiClosetMetadata extends StatelessWidget {
  final TextEditingController closetNameController;
  final TextEditingController? monthsController;
  final String closetType; // 'permanent' or 'temporary'
  final bool isPublic; // true for public, false for private
  final ThemeData theme;

  static final CustomLogger _logger = CustomLogger('CreateMultiClosetMetadata');

  const CreateMultiClosetMetadata({
    super.key,
    required this.closetNameController,
    this.monthsController,
    required this.closetType,
    required this.isPublic,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    _logger.i('Rendering CreateMultiClosetMetadata widget');

    return BlocBuilder<ClosetMetadataValidationCubit, ClosetMetadataValidationState>(
      builder: (context, state) {
        _logger.d('Current Bloc State: ${state.toString()}');

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
                    context.read<ClosetMetadataValidationCubit>().updateClosetName(value);
                  },
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      _logger.w('Closet name validation failed: cannot be empty');
                      return S.of(context).closetNameCannotBeEmpty;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Closet Type Toggle
                PermanentClosetToggle(
                  isPermanent: state.closetType == 'permanent',
                  onChanged: (value) {
                    final closetType = value ? 'permanent' : 'temporary';
                    _logger.d('Closet type changed to: $closetType');
                    context.read<ClosetMetadataValidationCubit>().updateClosetType(closetType);
                  },
                ),
                const SizedBox(height: 16),

                // Conditional Metadata Fields
                if (state.closetType == 'permanent') ...[
                  PublicPrivateToggle(
                    isPublic: state.isPublic ?? false,
                    onChanged: (isPublic) {
                      _logger.d('Public/Private changed: $isPublic');
                      context.read<ClosetMetadataValidationCubit>().updateIsPublic(isPublic);
                    },
                  ),
                ] else if (state.closetType == 'temporary') ...[
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
                      context.read<ClosetMetadataValidationCubit>().updateMonthsLater(months);
                    },
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        _logger.w('Months input validation failed: cannot be empty');
                        return S.of(context).monthsCannotBeEmpty;
                      }
                      final months = int.tryParse(value);
                      if (months == null || months <= 0) {
                        _logger.w('Months input validation failed: invalid value');
                        return S.of(context).invalidMonths;
                      }
                      return null;
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
