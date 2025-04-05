import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../utilities/logger.dart';
import '../../../../../../item_management/core/presentation/bloc/fetch_item_image_cubit/fetch_item_image_cubit.dart';
import '../../../../core/presentation/bloc/navigate_to_item_cubit/navigate_to_item_cubit.dart';
import '../widgets/focused_item_analytics_image_with_additional_features.dart';
import '../../../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../../utilities/app_router.dart';
import '../bloc/fetch_item_related_outfits_cubit.dart';
import '../../../../../widgets/layout/list/outfit_list.dart';
import '../../../../../../outfit_management/core/data/models/outfit_data.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';
import '../../../../../core_enums.dart';
import '../../../../core/presentation/bloc/focus_or_create_closet_bloc/focus_or_create_closet_bloc.dart';
import '../../../../../utilities/helper_functions/image_helper/image_helper.dart';

class FocusedItemsAnalyticsScreen extends StatelessWidget {
  final bool isFromMyCloset;
  final String itemId;
  final List<String> selectedOutfitIds;

  final CustomLogger logger = CustomLogger('FocusedItemsAnalyticsScreen');

  FocusedItemsAnalyticsScreen({super.key,
    required this.isFromMyCloset,
    required this.itemId,
    this.selectedOutfitIds = const [],
  });

  void _onImageTap(BuildContext context) {
    logger.i('Image tapped, navigating to EditItem');
    context.pushNamed(
      AppRoutesName.editItem, // Ensure this is correctly defined in your routes
      extra: itemId, // Pass itemId if needed
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
                context.goNamed(AppRoutesName.summaryItemsAnalytics);
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
                context.goNamed(
                  AppRoutesName.dailyCalendar,
                  extra: {'outfitId': state.outfitId}, // ✅ Pass as a Map
                );
              } else if (state is OutfitFocusedDateFailure) {
                logger.e('❌ Failed to set focused date: ${state.error}');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error)),
                );
              }
            },
          ),
          BlocListener<UsageAnalyticsNavigationBloc, UsageAnalyticsNavigationState>(
            listener: (context, state) {
              if (state is UsageAnalyticsAccessState) {
                if (state.accessStatus == AccessStatus.denied) {
                  logger.w('Access denied: Navigating to payment page');
                  context.goNamed(
                    AppRoutesName.payment,
                    extra: {
                      'featureKey': FeatureKey.usageAnalytics,
                      'isFromMyCloset': isFromMyCloset,
                      'previousRoute': AppRoutesName.myCloset,
                      'nextRoute': AppRoutesName.focusedItemsAnalytics,
                    },
                  );
                } else if (state.accessStatus == AccessStatus.trialPending) {
                  logger.i('Trial pending, navigating to trialStarted screen');
                  context.goNamed(
                    AppRoutesName.trialStarted,
                    extra: {
                      'selectedFeatureRoute': AppRoutesName.focusedItemsAnalytics,
                      'isFromMyCloset': isFromMyCloset,
                    },
                  );
                }
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
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),


// Divider using theme's dividerColor
                Divider(color: Theme.of(context).dividerColor, thickness: 2, height: 0),

                const SizedBox(height: 16),

                /// **Fetch and Display Related Outfits**
            Expanded(

            child: BlocBuilder<CrossAxisCountCubit, int>(
                builder: (context, crossAxisCount) {
                  return BlocBuilder<FocusOrCreateClosetBloc, FocusOrCreateClosetState>(
                    builder: (context, focusState) {
                      /// Determine outfit selection mode
                      final outfitSelectionMode = (focusState is FocusOrCreateClosetLoaded && focusState.isCalendarSelectable)
                          ? OutfitSelectionMode.multiSelection
                          : OutfitSelectionMode.action;

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
                                  S.of(context).noRelatedOutfitsItem,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              );
                            }

                            return OutfitList<OutfitData>(
                              outfits: outfits,
                              crossAxisCount: crossAxisCount,
                              outfitSelectionMode: outfitSelectionMode, // Pass mode here
                              selectedOutfitIds: selectedOutfitIds,
                              outfitSize: OutfitSize.relatedOutfitImage,
                              getHeightForOutfitSize: ImageHelper.getHeightForOutfitSize, // ✅ Pass function dynamically
                              onAction: (outfitId) {
                                logger.d('Tapped related outfit: $outfitId');
                                context.read<OutfitFocusedDateCubit>().setFocusedDateForOutfit(outfitId);
                              },
                            );
                          } else if (outfitState is NoItemRelatedOutfitsState) {
                            return Center(
                              child: Text(
                                S.of(context).noRelatedOutfitsItem,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                      },
                    );
                  },
                  )
                  ;}
                ),
            )],
            ),
          );
        }
        return const SizedBox.shrink();
      },
      ),
    );
  }
}
