import 'package:flutter/material.dart';

import '../../../../../user_photo/presentation/widgets/image_display_widget.dart';

class FocusedItemAnalyticsImageWithAdditionalFeatures extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onImageTap;


  const FocusedItemAnalyticsImageWithAdditionalFeatures({
    super.key,
    required this.imageUrl,
    required this.onImageTap,
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
              child: ImageDisplayWidget(
                imageUrl: imageUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
