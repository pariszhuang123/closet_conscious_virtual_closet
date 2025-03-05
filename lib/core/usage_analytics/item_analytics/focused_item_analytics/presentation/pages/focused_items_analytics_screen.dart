import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/logger.dart';
import '../../../../../../item_management/core/presentation/bloc/fetch_item_image_cubit/fetch_item_image_cubit.dart';
import '../../../../core/presentation/bloc/navigate_to_item_cubit/navigate_to_item_cubit.dart';
import '../widgets/focused_item_analytics_image_with_additional_features.dart';
import '../../../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../../utilities/routes.dart';

class FocusedItemsAnalyticsScreen extends StatelessWidget {
  final bool isFromMyCloset;
  final String itemId;
  final CustomLogger logger = CustomLogger('FocusedItemsAnalyticsScreen');

  FocusedItemsAnalyticsScreen({super.key,
    required this.isFromMyCloset,
    required this.itemId});

  void _onImageTap(BuildContext context) {
    logger.i('Image tapped, navigating to EditItem');
    Navigator.pushNamed(
      context,
      AppRoutes.editItem, // Ensure this is correctly defined in your routes
      arguments: {'itemId': itemId}, // Pass itemId if needed
    );
  }

  void _onSummaryItemAnalyticsButtonPressed(BuildContext context) {
    logger.i('Summary Item Analytics Button Pressed, triggering navigation');
    context.read<NavigateToItemCubit>().navigateToItem(itemId);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
        listeners: [
          BlocListener<NavigateToItemCubit, NavigateToItemState>(
            listener: (context, state) {
              if (state is NavigateToItemSuccess) {
                logger.i('NavigateToItemSuccess - Navigating to SummaryItemAnalytics');
                Navigator.pushReplacementNamed(context, AppRoutes.summaryItemsAnalytics);
              } else if (state is NavigateToItemFailure) {
                logger.e('Failed to navigate to item analytics: ${state.error}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to load item analytics: ${state.error}')),
                );
              }
            },
          ),
        ],

      child: BlocBuilder<FetchItemImageCubit, FetchItemImageState>(
      builder: (context, state) {
        if (state is FetchItemImageLoading) {
          logger.d('Loading image...');
          return const Center(child: ClosetProgressIndicator());
        } else if (state is FetchItemImageError) {
          logger.e('Error fetching image: ${state.error}');
          return Center(child: Text(state.error));
        } else if (state is FetchItemImageSuccess) {
          logger.i('Image loaded successfully: ${state.imageUrl}');
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                FocusedItemAnalyticsImageWithAdditionalFeatures(
                  imageUrl: state.imageUrl,
                  onImageTap: () => _onImageTap(context), // Use the separate function
                  onSummaryItemAnalyticsButtonPressed: () => _onSummaryItemAnalyticsButtonPressed(context),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
      )
    );
  }
}
