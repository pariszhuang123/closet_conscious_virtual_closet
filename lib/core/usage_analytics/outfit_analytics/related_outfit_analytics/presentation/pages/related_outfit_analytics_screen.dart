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
import '../../../../core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';
import '../../../../../paywall/data/feature_key.dart';
import '../../../../../core_enums.dart';
import '../../../../core/presentation/bloc/focus_or_create_closet_bloc/focus_or_create_closet_bloc.dart';
import '../../../../../utilities/helper_functions/image_helper/image_helper.dart';

class RelatedOutfitAnalyticsScreen extends StatelessWidget {
  final bool isFromMyCloset;
  final String outfitId;
  final List<String> selectedOutfitIds;

  static final _logger = CustomLogger('RelatedOutfitAnalyticsScreen');

  const RelatedOutfitAnalyticsScreen({
    super.key,
    required this.isFromMyCloset,
    required this.outfitId,
    this.selectedOutfitIds = const [],
  });

  @override
  Widget build(BuildContext context) {
    _logger.d('Building RelatedOutfitAnalyticsScreen for outfitId: $outfitId');
    return MultiBlocListener(
        listeners: [
          BlocListener<OutfitFocusedDateCubit, OutfitFocusedDateState>(
            listener: (context, state) {
              if (state is OutfitFocusedDateSuccess) {
                _logger.i('✅ Focused date set successfully for outfitId: ${state.outfitId}');
                context.goNamed(
                  AppRoutesName.dailyCalendar,
                  extra: {'outfitId': state.outfitId},
                );
              } else if (state is OutfitFocusedDateFailure) {
                _logger.e('❌ Failed to set focused date: ${state.error}');
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
                  _logger.w('Access denied: Navigating to payment page');
                  context.goNamed(
                    AppRoutesName.payment,
                    extra: {
                      'featureKey': FeatureKey.usageAnalytics,
                      'isFromMyCloset': isFromMyCloset,
                      'previousRoute': AppRoutesName.myCloset,
                      'nextRoute': AppRoutesName.relatedOutfitAnalytics,
                    },
                  );
                } else if (state.accessStatus == AccessStatus.trialPending) {
                  _logger.i('Trial pending, navigating to trialStarted screen');
                  context.goNamed(
                    AppRoutesName.trialStarted,
                    extra: {
                      'selectedFeatureRoute': AppRoutesName.relatedOutfitAnalytics,
                      'isFromMyCloset': isFromMyCloset,
                    },
                  );
                }
              }
            },
          ),
        ],

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ✅ Fetch & Display Main Outfit
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
                      getHeightForOutfitSize: ImageHelper.getHeightForOutfitSize, // ✅ Pass function dynamically
                      isSelected: true,
                      onTap: () {
                        _logger.d('Tapped on main outfit: $outfitId');
                        context.read<OutfitFocusedDateCubit>().setFocusedDateForOutfit(outfitId);
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

        // ✅ Fetch & Display Related Outfits
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
                  S.of(context).noRelatedOutfits, // ✅ Localized empty state text
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium, // ✅ Consistent typography
                ),
              );
            } else if (relatedState is RelatedOutfitsSuccess) {
              final relatedOutfits = relatedState.relatedOutfits;

              return BlocBuilder<CrossAxisCountCubit, int>(
                  builder: (context, crossAxisCount) {
                    return BlocBuilder<
                        FocusOrCreateClosetBloc,
                        FocusOrCreateClosetState>(
                      builder: (context, focusState) {
                        final outfitSelectionMode = (focusState is FocusOrCreateClosetLoaded &&
                            focusState.isCalendarSelectable)
                            ? OutfitSelectionMode.multiSelection
                            : OutfitSelectionMode.action;

                        return OutfitList<OutfitData>(
                          outfits: relatedOutfits,
                          crossAxisCount: crossAxisCount,
                          outfitSelectionMode: outfitSelectionMode,
                          selectedOutfitIds: selectedOutfitIds,
                          outfitSize: OutfitSize.relatedOutfitImage,
                          getHeightForOutfitSize: ImageHelper.getHeightForOutfitSize, // ✅ Pass function dynamically
                          onAction: (selectedOutfitId) {
                            _logger.d(
                                'Tapped related outfit: $selectedOutfitId');
                            context.goNamed(
                              AppRoutesName.relatedOutfitAnalytics,
                              extra: selectedOutfitId,
                            );
                          },
                        );
                      },
                    );
                  }
              );
            }
            return const SizedBox.shrink();
          },
        ),
        )
      ],
    )
    );
  }
}
