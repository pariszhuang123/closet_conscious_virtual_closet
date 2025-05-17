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
import '../../../../../utilities/helper_functions/navigate_once_helper.dart';

class FocusedItemsAnalyticsListeners extends StatefulWidget {
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
  State<FocusedItemsAnalyticsListeners> createState() => _FocusedItemsAnalyticsListenersState();
}

class _FocusedItemsAnalyticsListenersState extends State<FocusedItemsAnalyticsListeners> with NavigateOnceHelper {

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UsageAnalyticsNavigationBloc, UsageAnalyticsNavigationState>(
          listener: (context, state) {
            if (state is UsageAnalyticsAccessState) {
              switch (state.accessStatus) {
                case AccessStatus.granted:
                  widget.logger.i('Access granted → fetching analytics');
                  navigateOnce(() {
                    context.read<FetchItemImageCubit>().fetchItemImage(widget.itemId);
                    context.read<FetchItemRelatedOutfitsCubit>().fetchItemRelatedOutfits(itemId: widget.itemId);
                    context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
                  });
                  break;

                case AccessStatus.denied:
                  widget.logger.w('Access denied → navigating to payment');
                  navigateOnce(() {
                    context.goNamed(
                      AppRoutesName.payment,
                      extra: {
                        'featureKey': FeatureKey.usageAnalytics,
                        'isFromMyCloset': widget.isFromMyCloset,
                        'previousRoute': AppRoutesName.myCloset,
                        'nextRoute': AppRoutesName.summaryItemsAnalytics,
                      },
                    );
                  });
                  break;

                case AccessStatus.trialPending:
                  widget.logger.i('Trial pending → navigating to trialStarted');
                  navigateOnce(() {
                    context.goNamed(
                      AppRoutesName.trialStarted,
                      extra: {
                        'selectedFeatureRoute': AppRoutesName.summaryItemsAnalytics,
                        'isFromMyCloset': widget.isFromMyCloset,
                      },
                    );
                  });
                  break;

                case AccessStatus.pending:
                case AccessStatus.error:
                  widget.logger.w('Access status: ${state.accessStatus}');
                  break;
              }
            }
          },
        ),
        BlocListener<OutfitFocusedDateCubit, OutfitFocusedDateState>(
          listener: (context, state) {
            if (state is OutfitFocusedDateSuccess) {
              widget.logger.i('✅ Focused date set for outfitId: ${state.outfitId}');
              context.pushNamed(
                AppRoutesName.dailyCalendar,
                extra: {'outfitId': state.outfitId},
              );
            } else if (state is OutfitFocusedDateFailure) {
              widget.logger.e('❌ Failed to set focused date: ${state.error}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
            }
          },
        ),
      ],
      child: widget.child,
    );
  }
}
