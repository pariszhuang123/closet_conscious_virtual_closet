import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/user_photo/presentation/widgets/image_display_widget.dart';
import '../../presentation/widgets/edit_item_additional_feature.dart';
import '../../../core/presentation/bloc/fetch_item_image_cubit/fetch_item_image_cubit.dart';

class EditItemImageWithAdditionalFeatures extends StatelessWidget {
  final String? imageUrl;  // ✅ Add this parameter
  final VoidCallback onImageTap;
  final VoidCallback onSwapPressed;
  final VoidCallback onMetadataPressed;

  const EditItemImageWithAdditionalFeatures({
    super.key,
    required this.imageUrl,  // ✅ Ensure this is included
    required this.onImageTap,
    required this.onSwapPressed,
    required this.onMetadataPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FetchItemImageCubit, FetchItemImageState>(
      builder: (context, state) {
        String? imageUrl;

        if (state is FetchItemImageSuccess) {
          imageUrl = state.imageUrl;
        } else if (state is FetchItemImageError) {
          imageUrl = null; // Handle error case, could also show a placeholder
        }

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: Stack(
            children: [
              Center(
                child: GestureDetector(
                  onTap: onImageTap,
                  child: ImageDisplayWidget(
                    imageUrl: imageUrl, // Updated to dynamically listen to FetchItemImageCubit
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
      },
    );
  }
}
