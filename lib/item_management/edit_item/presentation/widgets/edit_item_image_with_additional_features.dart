import 'package:flutter/material.dart';

import '../../../../core/user_photo/presentation/widgets/image_display_widget.dart';
import '../../presentation/widgets/edit_item_additional_feature.dart';

class EditItemImageWithAdditionalFeatures extends StatelessWidget {
  final String? imageUrl;
  final bool isChanged;
  final VoidCallback onImageTap;
  final VoidCallback onSwapPressed;
  final VoidCallback onMetadataPressed;


  const EditItemImageWithAdditionalFeatures({
    super.key,
    required this.imageUrl,
    required this.isChanged,
    required this.onImageTap,
    required this.onSwapPressed,
    required this.onMetadataPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: Stack(
        children: [
          Center(
            child: GestureDetector(
              onTap: onImageTap,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: ImageDisplayWidget(
                  imageUrl: imageUrl,
                ),
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 20,
            bottom: 0,
            child: EditItemAdditionalFeature(
              openMetadataSheet: onMetadataPressed,  // New callback
              openSwapSheet: onSwapPressed,  // Reusing the swap callback
            ),
          ),
        ],
      ),
    );
  }
}
