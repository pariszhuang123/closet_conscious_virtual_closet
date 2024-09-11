import 'package:flutter/material.dart';
import '../../../core/widgets/button/navigation_type_button.dart';
import '../../../core/photo/presentation/widgets/image_display_widget.dart';
import '../../../core/theme/themed_svg.dart';

class EditItemImageWithAdditionalFeatures extends StatelessWidget {
  final String? imageUrl;
  final bool isChanged;
  final VoidCallback onImageTap;
  final VoidCallback onSwapPressed;
  final String swapLabel;
  final String assetPath;

  const EditItemImageWithAdditionalFeatures({
    super.key,
    required this.imageUrl,
    required this.isChanged,
    required this.onImageTap,
    required this.onSwapPressed,
    required this.swapLabel,
    required this.assetPath,
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
            right: 0,
            top: 0,
            bottom: 0,
            child: NavigationTypeButton(
              label: swapLabel,
              selectedLabel: '',
              onPressed: onSwapPressed,
              assetPath: assetPath,
              isFromMyCloset: true,
              buttonType: ButtonType.secondary,
              usePredefinedColor: false,
            ),
          ),
        ],
      ),
    );
  }
}
