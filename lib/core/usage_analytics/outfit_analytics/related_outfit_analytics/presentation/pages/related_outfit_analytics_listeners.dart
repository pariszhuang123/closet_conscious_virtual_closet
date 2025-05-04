import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core_enums.dart';
import '../../../../../utilities/app_router.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../widgets/feedback/custom_snack_bar.dart';
import '../../../../core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';
import '../bloc/related_outfits_cubit/related_outfits_cubit.dart';
import '../../presentation/bloc/single_outfit_cubit/single_outfit_cubit.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../utilities/helper_functions/navigate_once_helper.dart';

class RelatedOutfitAnalyticsListeners extends StatefulWidget {
  final Widget child;
  final bool isFromMyCloset;
  final CustomLogger logger;
  final String outfitId;

  const RelatedOutfitAnalyticsListeners({
    super.key,
    required this.child,
    required this.isFromMyCloset,
    required this.logger,
    required this.outfitId,
  });

  @override
  State<RelatedOutfitAnalyticsListeners> createState() => _RelatedOutfitAnalyticsListenersState();
}

class _RelatedOutfitAnalyticsListenersState extends State<RelatedOutfitAnalyticsListeners> with NavigateOnceHelper {

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OutfitFocusedDateCubit, OutfitFocusedDateState>(
          listener: (context, state) {
            if (state is OutfitFocusedDateSuccess) {
              widget.logger.i('✅ Focused date set successfully for outfitId: ${state.outfitId}');
              navigateOnce(() {
                context.pushNamed(
                  AppRoutesName.dailyCalendar,
                  extra: {'outfitId': state.outfitId},
                );
              });
            } else if (state is OutfitFocusedDateFailure) {
              widget.logger.e('❌ Failed to set focused date: ${state.error}');
              CustomSnackbar(
                message: state.error,
                theme: Theme.of(context),
              ).show(context);
            }
          },
        ),
        BlocListener<UsageAnalyticsNavigationBloc, UsageAnalyticsNavigationState>(
          listener: (context, state) {
            if (state is UsageAnalyticsAccessState) {
              switch (state.accessStatus) {
                case AccessStatus.denied:
                  widget.logger.w('Access denied → payment');
                  navigateOnce(() {
                    context.goNamed(
                      AppRoutesName.payment,
                      extra: {
                        'featureKey': FeatureKey.usageAnalytics,
                        'isFromMyCloset': widget.isFromMyCloset,
                        'previousRoute': AppRoutesName.myCloset,
                        'nextRoute': AppRoutesName.relatedOutfitAnalytics,
                      },
                    );
                  });
                  break;
                case AccessStatus.trialPending:
                  widget.logger.i('Trial pending → trialStarted');
                  navigateOnce(() {
                    context.goNamed(
                      AppRoutesName.trialStarted,
                      extra: {
                        'selectedFeatureRoute': AppRoutesName.relatedOutfitAnalytics,
                        'isFromMyCloset': widget.isFromMyCloset,
                      },
                    );
                  });
                  break;
                case AccessStatus.granted:
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.read<SingleOutfitCubit>().fetchOutfit(widget.outfitId);
                    context.read<RelatedOutfitsCubit>().fetchRelatedOutfits(outfitId: widget.outfitId);
                    context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
                  });
                  break;
                default:
                  widget.logger.d('Unhandled access status: ${state.accessStatus}');
              }
            }
          },
        ),
      ],
      child: widget.child,
    );
  }
}
