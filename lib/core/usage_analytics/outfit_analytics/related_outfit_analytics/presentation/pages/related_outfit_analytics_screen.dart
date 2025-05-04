import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../utilities/logger.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../bloc/single_outfit_cubit/single_outfit_cubit.dart';
import '../bloc/related_outfits_cubit/related_outfits_cubit.dart';
import '../../../../../../outfit_management/core/data/models/outfit_data.dart';
import '../../../../../widgets/layout/carousel/carousel_outfit.dart';
import '../../../../../widgets/layout/list/outfit_list.dart';
import '../../../../../widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../../utilities/app_router.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../../core_enums.dart';
import '../../../../core/presentation/bloc/focus_or_create_closet_bloc/focus_or_create_closet_bloc.dart';
import '../../../../../usage_analytics/core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';
import '../../../../../utilities/helper_functions/image_helper/image_helper.dart';
import '../../../../../theme/my_closet_theme.dart';
import '../../../../../theme/my_outfit_theme.dart';
import 'related_outfit_analytics_listeners.dart';
import '../../../../../widgets/layout/bottom_nav_bar/analytics_bottom_nav_bar.dart';

class RelatedOutfitAnalyticsScreen extends StatefulWidget {
  final bool isFromMyCloset;
  final String outfitId;
  final List<String> selectedOutfitIds;

  const RelatedOutfitAnalyticsScreen({
    super.key,
    required this.isFromMyCloset,
    required this.outfitId,
    this.selectedOutfitIds = const [],
  });

  @override
  State<RelatedOutfitAnalyticsScreen> createState() => _RelatedOutfitAnalyticsScreenState();
}

class _RelatedOutfitAnalyticsScreenState extends State<RelatedOutfitAnalyticsScreen> {
  static final _logger = CustomLogger('RelatedOutfitAnalyticsScreen');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<UsageAnalyticsNavigationBloc>().add(CheckUsageAnalyticsAccessEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme;

    return RelatedOutfitAnalyticsListeners(
      isFromMyCloset: widget.isFromMyCloset,
      outfitId: widget.outfitId,
      logger: _logger,
      child: Theme(
        data: effectiveTheme,
        child: PopScope(
          canPop: true,
          onPopInvokedWithResult: (bool didPop, Object? result) {
            _logger.i('Pop invoked: didPop = $didPop, result = $result');
            if (!didPop) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.goNamed(AppRoutesName.summaryOutfitAnalytics);
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
                    _logger.i('BackButton: Navigator can pop, popping...');
                    navigator.pop();
                  } else {
                    _logger.i('BackButton: Navigator cannot pop, going to MyCloset.');
                    context.goNamed(AppRoutesName.summaryOutfitAnalytics);
                  }
                },
              ),
              title: Text(
                S.of(context).usageAnalyticsTitle,
                style: effectiveTheme.textTheme.titleMedium,
              ),
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                BlocBuilder<SingleOutfitCubit, SingleOutfitState>(
                  builder: (context, outfitState) {
                    if (outfitState is FetchOutfitLoading) {
                      return const Center(child: OutfitProgressIndicator());
                    } else if (outfitState is FetchOutfitFailure) {
                      return Center(child: Text('Error: ${outfitState.error}'));
                    } else if (outfitState is FetchOutfitSuccess) {
                      final mainOutfit = outfitState.outfit;

                      return BlocBuilder<CrossAxisCountCubit, int>(
                        builder: (context, crossAxisCount) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 80),
                            child: CarouselOutfit(
                              outfit: mainOutfit,
                              crossAxisCount: crossAxisCount,
                              outfitSize: OutfitSize.smallOutfitImage,
                              getHeightForOutfitSize: ImageHelper.getHeightForOutfitSize,
                              isSelected: true,
                              onTap: () {
                                _logger.d('Tapped on main outfit: $widget.outfitId');
                                context.read<OutfitFocusedDateCubit>().setFocusedDateForOutfit(widget.outfitId);
                              },
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      S.of(context).relatedOutfitsToAboveOutfit,
                      style: effectiveTheme.textTheme.bodyMedium,
                    ),
                  ),
                ),
                Divider(color: effectiveTheme.dividerColor, thickness: 2, height: 0),
                const SizedBox(height: 16),
                Expanded(
                  child: BlocBuilder<RelatedOutfitsCubit, RelatedOutfitsState>(
                    builder: (context, relatedState) {
                      if (relatedState is RelatedOutfitsLoading) {
                        return const Center(child: OutfitProgressIndicator());
                      } else if (relatedState is RelatedOutfitsFailure) {
                        return Center(child: Text('Error: ${relatedState.error}'));
                      } else if (relatedState is NoRelatedOutfitState) {
                        return Center(
                          child: Text(
                            S.of(context).noRelatedOutfits,
                            textAlign: TextAlign.center,
                            style: effectiveTheme.textTheme.titleMedium,
                          ),
                        );
                      } else if (relatedState is RelatedOutfitsSuccess) {
                        final relatedOutfits = relatedState.relatedOutfits;

                        return BlocBuilder<CrossAxisCountCubit, int>(
                          builder: (context, crossAxisCount) {
                            return BlocBuilder<FocusOrCreateClosetBloc, FocusOrCreateClosetState>(
                              builder: (context, focusState) {
                                final outfitSelectionMode =
                                (focusState is FocusOrCreateClosetLoaded && focusState.isCalendarSelectable)
                                    ? OutfitSelectionMode.multiSelection
                                    : OutfitSelectionMode.action;

                                return OutfitList<OutfitData>(
                                  outfits: relatedOutfits,
                                  crossAxisCount: crossAxisCount,
                                  outfitSelectionMode: outfitSelectionMode,
                                  selectedOutfitIds: widget.selectedOutfitIds,
                                  outfitSize: OutfitSize.relatedOutfitImage,
                                  getHeightForOutfitSize: ImageHelper.getHeightForOutfitSize,
                                  onAction: (selectedOutfitId) {
                                    _logger.d('Tapped related outfit: $selectedOutfitId');
                                    context.pushNamed(
                                      AppRoutesName.relatedOutfitAnalytics,
                                      extra: selectedOutfitId,
                                    );
                                  },
                                );
                              },
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
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
