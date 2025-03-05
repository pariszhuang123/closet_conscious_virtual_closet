import 'package:flutter/material.dart';

import '../../../../../user_photo/presentation/widgets/image_display_widget.dart';
import '../widgets/focused_item_analytics_additional_feature.dart';

class FocusedItemAnalyticsImageWithAdditionalFeatures extends StatelessWidget {
  final String? imageUrl;
  final VoidCallback onImageTap;
  final VoidCallback onSummaryItemAnalyticsButtonPressed;


  const FocusedItemAnalyticsImageWithAdditionalFeatures({
    super.key,
    required this.imageUrl,
    required this.onImageTap,
    required this.onSummaryItemAnalyticsButtonPressed,
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
          Positioned(
            right: 20,
            top: 20,
            bottom: 0,
            child: FocusedItemAnalyticsAdditionalFeature(
              onSummaryItemAnalyticsButtonPressed: onSummaryItemAnalyticsButtonPressed,  // New callback
            ),
          ),
        ],
      ),
    );
  }
}
