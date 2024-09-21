import 'package:flutter/material.dart';
import 'dart:io';
import '../../../theme/my_closet_theme.dart';
import '../../../../generated/l10n.dart';
import '../../../core_enums.dart';
import 'base/user_photo.dart';

class ImageDisplayWidget extends StatelessWidget {
  const ImageDisplayWidget({
    super.key,
    this.imageUrl,
    this.file,
    this.imageSize = ImageSize.itemInteraction, // Default size
  });

  final String? imageUrl;
  final File? file;
  final ImageSize imageSize; // Pass the image size for flexibility


  @override
  Widget build(BuildContext context) {

    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
      child: SizedBox(
        width: 175,
        height: 175,
        child: file != null
            ? Image.file(
          file!,
          fit: BoxFit.cover,
        )
            : imageUrl != null && imageUrl!.isNotEmpty
            ? (Uri.tryParse(imageUrl!)?.isAbsolute == true
            ? UserPhoto(
          imageUrl: imageUrl!,
          imageSize: imageSize, // Pass the desired size
        )
            : Image.file(
          File(imageUrl!),
          fit: BoxFit.cover,
        ))

            : Container(
          color: myClosetTheme.colorScheme.secondaryContainer,
          child: Center(
            child: Text(S.of(context).noImage), // Removed `const` keyword here
          ),
        ),
      ),
    );
  }
}
