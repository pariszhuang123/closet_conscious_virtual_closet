import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../generated/l10n.dart';
import '../../../../../core/user_photo/presentation/widgets/base/user_photo.dart';
import '../../../../../core/core_enums.dart';
import '../bloc/reappear_closet_bloc.dart';
import '../../../../../core/utilities/app_router.dart';
import '../../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../../../core/utilities/logger.dart';

class ReappearClosetScreen extends StatelessWidget {
  final String closetId;
  final String closetName;
  final String closetImage;

  // Initialize a logger specific to ReappearClosetScreen
  static final CustomLogger _logger = CustomLogger('ReappearClosetScreen');

  const ReappearClosetScreen({
    super.key,
    required this.closetId,
    required this.closetName,
    required this.closetImage,
  });

  @override
  Widget build(BuildContext context) {
    _logger.i('Building ReappearClosetScreen with closetId: $closetId, closetName: $closetName');

    final theme = Theme.of(context);

    return PopScope<Object?>(
      canPop: false, // Disable the ability to pop this screen
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          // Log that the user attempted to go back
          _logger.w('Back navigation attempt detected.');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false, // Remove the back icon
          title: Text(S.of(context).closetReappearTitle),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                closetName, // Add a localized subtitle
                style: theme.textTheme.titleMedium, // Use a larger text style for emphasis
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20), // Add spacing

              // Display the closet image using UserPhoto
              if (closetImage.isNotEmpty)
                UserPhoto(
                  imageUrl: closetImage,
                  imageSize: ImageSize.selfie, // Choose appropriate size
                )
              else
                const Icon(Icons.image_not_supported, size: 150),
              const SizedBox(height: 20),

              // Dynamic message with closet name
              Text(
                S.of(context).closetReappearMessage(closetName),
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Button to view closet items
              ThemedElevatedButton(
                onPressed: () {
                  _logger.d('View Closet Items button clicked for closetId: $closetId');

                    // Dispatch event to update shared preferences
                    context.read<ReappearClosetBloc>().add(
                        UpdateReappearClosetSharedPreferenceEvent(
                            closetId: closetId));

                    _logger.i('Dispatched UpdateReappearClosetSharedPreferenceEvent for closetId: $closetId');

                    // Navigate to myCloset
                    context.goNamed(
                      AppRoutesName.myCloset,
                    );

                    _logger.i('Navigated to MyCloset screen.');
                },
                text: S.of(context).viewClosetItemsButton,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
