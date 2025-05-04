import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../utilities/logger.dart';
import '../../../../../utilities/app_router.dart';
import '../../../../../core_enums.dart';
import '../../../../core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';
import '../../../../core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../../../item_management/core/presentation/bloc/fetch_item_image_cubit/fetch_item_image_cubit.dart';
import '../bloc/fetch_item_related_outfits_cubit.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';


class FocusedItemsAnalyticsListeners extends StatelessWidget {
  final bool isFromMyCloset;
  final CustomLogger logger;
  final String itemId;
  final Widget child;

  const FocusedItemsAnalyticsListeners({
    super.key,
    required this.isFromMyCloset,
    required this.logger,
    required this.itemId,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OutfitFocusedDateCubit, OutfitFocusedDateState>(
          listener: (context, state) {
            if (state is OutfitFocusedDateSuccess) {
              logger.i('✅ Focused date set successfully for outfitId: ${state.outfitId}');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.pushNamed(
                  AppRoutesName.dailyCalendar,
                  extra: {'outfitId': state.outfitId},
                );
              });
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
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.goNamed(
                    AppRoutesName.payment,
                    extra: {
                      'featureKey': FeatureKey.usageAnalytics,
                      'isFromMyCloset': isFromMyCloset,
                      'previousRoute': AppRoutesName.myCloset,
                      'nextRoute': AppRoutesName.summaryItemsAnalytics,
                    },
                  );
                });
              } else if (state.accessStatus == AccessStatus.trialPending) {
                logger.i('Trial pending, navigating to trialStarted screen');
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.goNamed(
                    AppRoutesName.trialStarted,
                    extra: {
                      'selectedFeatureRoute': AppRoutesName.summaryItemsAnalytics,
                      'isFromMyCloset': isFromMyCloset,
                    },
                  );
                });
              } else if (state.accessStatus == AccessStatus.granted) {
                logger.i('Access granted: Fetching all summary & items');

                context.read<FetchItemImageCubit>().fetchItemImage(itemId);
                context.read<FetchItemRelatedOutfitsCubit>().fetchItemRelatedOutfits(itemId: itemId);
                context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
              }
            }
          },
        ),
      ],
      child: child,
    );
  }
}
