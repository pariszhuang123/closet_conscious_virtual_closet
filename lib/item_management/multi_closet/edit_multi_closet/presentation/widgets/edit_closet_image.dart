import 'package:flutter/material.dart';

import '../../../../../core/user_photo/presentation/widgets/image_display_widget.dart';
import '../../../../../core/core_enums.dart';

class EditClosetImage extends StatelessWidget {
  final String closetImage;
  final bool isChanged;
  final VoidCallback onImageTap;

  const EditClosetImage({
    super.key,
    required this.closetImage,
    required this.isChanged,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); // Access the current theme

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0, left: 6.0), // Add outer padding for spacing
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.25,
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: onImageTap,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 4.0), // Add consistent inner padding
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isChanged
                          ? theme.colorScheme.primary
                          : theme.colorScheme.secondary,
                      width: 2.0, // Border width
                    ),
                    borderRadius: BorderRadius.circular(10.0), // Match with image rounding
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0), // Slightly smaller radius for inner content
                    child: ImageDisplayWidget(
                      imageUrl: closetImage,
                      imageSize: ImageSize.closetMetadata,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
