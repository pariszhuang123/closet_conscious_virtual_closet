import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../utilities/logger.dart';
import '../../../../../../item_management/core/presentation/bloc/fetch_item_image_cubit/fetch_item_image_cubit.dart';
import '../widgets/focused_item_analytics_image_with_additional_features.dart';
import '../../../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../../utilities/app_router.dart';
import '../bloc/fetch_item_related_outfits_cubit.dart';
import '../../../../../widgets/layout/list/outfit_list.dart';
import '../../../../../../outfit_management/core/data/models/outfit_data.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../core_enums.dart';
import '../../../../core/presentation/bloc/focus_or_create_closet_bloc/focus_or_create_closet_bloc.dart';
import '../../../../../utilities/helper_functions/image_helper/image_helper.dart';
import '../../../../../theme/my_closet_theme.dart';
import '../../../../../theme/my_outfit_theme.dart';
import 'focused_item_analytics_listeners.dart';
import '../../../../../widgets/layout/bottom_nav_bar/analytics_bottom_nav_bar.dart';
import '../../../../../usage_analytics/core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';

class FocusedItemsAnalyticsScreen extends StatefulWidget {
  final bool isFromMyCloset;
  final String itemId;
  final List<String> selectedOutfitIds;

  const FocusedItemsAnalyticsScreen({
    super.key,
    required this.isFromMyCloset,
    required this.itemId,
    this.selectedOutfitIds = const [],
  });

  @override
  State<FocusedItemsAnalyticsScreen> createState() => _FocusedItemsAnalyticsScreenState();
}

class _FocusedItemsAnalyticsScreenState extends State<FocusedItemsAnalyticsScreen> {
  final CustomLogger logger = CustomLogger('FocusedItemsAnalyticsScreen');

  @override
  void initState() {
    super.initState();
    logger.i('Running initState logic for itemId: ${widget.itemId}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<UsageAnalyticsNavigationBloc>().add(CheckUsageAnalyticsAccessEvent());
    });
  }

  void _onImageTap(BuildContext context) {
    logger.i('Image tapped, navigating to EditItem');
    context.pushNamed(
      AppRoutesName.editItem,
      extra: widget.itemId,
    );
  }

  @override
  Widget build(BuildContext context) {
    logger.i('Building FocusedItemsAnalyticsScreen');

    final ThemeData effectiveTheme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme;

    return FocusedItemsAnalyticsListeners( // ✅ wrap everything
      isFromMyCloset: widget.isFromMyCloset,
      itemId: widget.itemId,
      logger: logger,
      child: Theme(
        data: effectiveTheme,
        child: PopScope(
          canPop: true,
          onPopInvokedWithResult: (bool didPop, Object? result) {
            logger.i('Pop invoked: didPop = $didPop, result = $result');
            if (!didPop) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.goNamed(AppRoutesName.summaryItemsAnalytics);
              });
            }
          },
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              leading: BackButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  if (navigator.canPop()) {
                    logger.i('BackButton: Navigator can pop, popping...');
                    navigator.pop();
                  } else {
                    logger.i('BackButton: Navigator cannot pop, going to MyCloset.');
                    context.goNamed(AppRoutesName.summaryItemsAnalytics);
                  }
                },
              ),
              title: Text(
                S.of(context).usageAnalyticsTitle,
                style: effectiveTheme.textTheme.titleMedium,
              ),
            ),
            body: BlocBuilder<FetchItemImageCubit, FetchItemImageState>(
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
                          onImageTap: () => _onImageTap(context),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              S.of(context).relatedOutfitsToAboveItem,
                              style: effectiveTheme.textTheme.bodyMedium,
                            ),
                          ),
                        ),
                        Divider(
                          color: effectiveTheme.dividerColor,
                          thickness: 2,
                          height: 0,
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: BlocBuilder<CrossAxisCountCubit, int>(
                            builder: (context, crossAxisCount) {
                              return BlocBuilder<FocusOrCreateClosetBloc, FocusOrCreateClosetState>(
                                builder: (context, focusState) {
                                  final outfitSelectionMode =
                                  (focusState is FocusOrCreateClosetLoaded && focusState.isCalendarSelectable)
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
                                              style: effectiveTheme.textTheme.titleMedium,
                                            ),
                                          );
                                        }

                                        return OutfitList<OutfitData>(
                                          outfits: outfits,
                                          crossAxisCount: crossAxisCount,
                                          outfitSelectionMode: outfitSelectionMode,
                                          selectedOutfitIds: widget.selectedOutfitIds,
                                          outfitSize: OutfitSize.relatedOutfitImage,
                                          getHeightForOutfitSize: ImageHelper.getHeightForOutfitSize,
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
                                            style: effectiveTheme.textTheme.titleMedium,
                                          ),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            bottomNavigationBar: AnalyticsBottomNavBar(
              currentIndex: widget.isFromMyCloset ? 0 : 1,
              isFromMyCloset: widget.isFromMyCloset,
            ),
          ),
        ),
      ),
    );
  }
}
