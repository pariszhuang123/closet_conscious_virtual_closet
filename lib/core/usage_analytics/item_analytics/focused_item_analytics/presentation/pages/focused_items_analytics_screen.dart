import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/logger.dart';
import '../../../../../../item_management/core/presentation/bloc/fetch_item_image_cubit/fetch_item_image_cubit.dart';
import '../../../../core/presentation/bloc/navigate_to_item_cubit/navigate_to_item_cubit.dart';
import '../widgets/focused_item_analytics_image_with_additional_features.dart';
import '../../../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../../utilities/routes.dart';
import '../bloc/fetch_item_related_outfits_cubit.dart';
import '../../../../../widgets/layout/list/outfit_list.dart';
import '../../../../../../outfit_management/core/data/models/outfit_data.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../../../generated/l10n.dart';

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
          BlocListener<OutfitFocusedDateCubit, OutfitFocusedDateState>(
            listener: (context, state) {
              if (state is OutfitFocusedDateSuccess) {
                logger.i('✅ Focused date set successfully for outfitId: ${state.outfitId}');
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.dailyCalendar,
                  arguments: {'outfitId': state.outfitId}, // ✅ Pass as a Map
                );
              } else if (state is OutfitFocusedDateFailure) {
                logger.e('❌ Failed to set focused date: ${state.error}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
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

                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 0.0), // ✅ Adjusted padding
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      S.of(context).relatedOutfits, // ✅ Localized text
                      style: Theme.of(context).textTheme.titleSmall, // ✅ Use titleMedium directly
                    ),
                  ),
                ),


// Divider using theme's dividerColor
                Divider(color: Theme.of(context).dividerColor, thickness: 2, height: 0),

                const SizedBox(height: 16),

                /// **Fetch and Display Related Outfits**
                BlocBuilder<CrossAxisCountCubit, int>(
                  builder: (context, crossAxisCount) {
                    return BlocBuilder<FetchItemRelatedOutfitsCubit, FetchItemRelatedOutfitsState>(
                      builder: (context, outfitState) {
                        if (outfitState is FetchItemRelatedOutfitsLoading) {
                          return const Center(child: ClosetProgressIndicator());
                        } else if (outfitState is FetchItemRelatedOutfitsFailure) {
                          return Center(child: Text(outfitState.message));
                        } else if (outfitState is FetchItemRelatedOutfitsSuccess) {
                          final outfits = outfitState.outfits;
                          if (outfits.isEmpty) {
                            return Center(
                              child: Text(
                                S.of(context).noRelatedOutfitsItem, // ✅ Localized empty state text
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge, // ✅ Consistent typography
                              ),
                            );
                          }
                          return OutfitList<OutfitData>(
                            outfits: outfits,
                            crossAxisCount: crossAxisCount, // ✅ Uses dynamic cross-axis count
                            useLargeHeight: true, // ✅ Pass dynamically
                            onOutfitTap: (outfitId) {
                              logger.d('Tapped related outfit: $outfitId');
                              context.read<OutfitFocusedDateCubit>().setFocusedDateForOutfit(outfitId);
                            },
                          );
                        } else if (outfitState is NoItemRelatedOutfitsState) {
                          return const Center(child: Text("No related outfits found."));
                        }
                        return const SizedBox.shrink();
                      },
                    );
                  },
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
      ),
    );
  }
}
