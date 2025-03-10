import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/logger.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../bloc/single_outfit_cubit/single_outfit_cubit.dart';
import '../bloc/related_outfits_cubit/related_outfits_cubit.dart';
import '../../../../../../outfit_management/core/data/models/outfit_data.dart';
import '../../../../../widgets/layout/carousel/carousel_outfit.dart';
import '../../../../../widgets/layout/list/outfit_list.dart';
import '../../../../../widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../../utilities/routes.dart';
import '../../../../../../generated/l10n.dart';
import '../../../../core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';
import '../../../../../paywall/data/feature_key.dart';
import '../../../../../core_enums.dart';

class RelatedOutfitAnalyticsScreen extends StatelessWidget {
  final bool isFromMyCloset;
  final String outfitId;

  static final _logger = CustomLogger('RelatedOutfitAnalyticsScreen');

  const RelatedOutfitAnalyticsScreen({
    super.key,
    required this.isFromMyCloset,
    required this.outfitId,
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
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.dailyCalendar,
                  arguments: {'outfitId': state.outfitId},
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
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.payment,
                    arguments: {
                      'featureKey': FeatureKey.usageAnalytics,
                      'isFromMyCloset': isFromMyCloset,
                      'previousRoute': AppRoutes.myCloset,
                      'nextRoute': AppRoutes.relatedOutfitAnalytics,
                    },
                  );
                } else if (state.accessStatus == AccessStatus.trialPending) {
                  _logger.i('Trial pending, navigating to trialStarted screen');
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.trialStarted,
                    arguments: {
                      'selectedFeatureRoute': AppRoutes.relatedOutfitAnalytics,
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
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: CarouselOutfit(
                      outfit: mainOutfit,
                      crossAxisCount: crossAxisCount,
                      isSelected: true,
                      onTap: () {
                        _logger.d('Tapped on main outfit: $outfitId');
                        context.read<OutfitFocusedDateCubit>().setFocusedDateForOutfit(outfitId);
                      },
                      useLargeHeight: false, // ✅ Pass dynamically
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
              style: Theme.of(context).textTheme.titleSmall, // ✅ Use titleMedium directly
            ),
          ),
        ),


// Divider using theme's dividerColor
        Divider(color: Theme.of(context).dividerColor, thickness: 2, height: 0),

        const SizedBox(height: 16),

        // ✅ Fetch & Display Related Outfits
        BlocBuilder<RelatedOutfitsCubit, RelatedOutfitsState>(
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
                  style: Theme.of(context).textTheme.titleLarge, // ✅ Consistent typography
                ),
              );
            } else if (relatedState is RelatedOutfitsSuccess) {
              final relatedOutfits = relatedState.relatedOutfits;

              return BlocBuilder<CrossAxisCountCubit, int>(
                builder: (context, crossAxisCount) {
                  return OutfitList<OutfitData>(
                    outfits: relatedOutfits,
                    crossAxisCount: crossAxisCount,
                    useLargeHeight: true, // ✅ Pass dynamically
                    onOutfitTap: (selectedOutfitId) {
                      _logger.d('Tapped related outfit: $selectedOutfitId');
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.relatedOutfitAnalytics,
                        arguments: selectedOutfitId,
                      );
                    },
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    )
    );
  }
}
