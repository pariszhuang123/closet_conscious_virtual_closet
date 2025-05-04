import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utilities/logger.dart';
import '../../../../../core/utilities/app_router.dart';
import '../../../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/core_enums.dart';

import '../../../core/presentation/bloc/calendar_navigation_bloc/calendar_navigation_bloc.dart';
import '../../../../../core/usage_analytics/core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../core/presentation/bloc/outfit_selection_bloc/outfit_selection_bloc.dart';
import '../bloc/daily_calendar_bloc.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';

final _logger = CustomLogger('DailyCalendarListeners');

class DailyCalendarListeners extends StatelessWidget {
  final Widget child;

  const DailyCalendarListeners({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DailyCalendarBloc, DailyCalendarState>(
          listener: (context, state) {
            if (state is DailyCalendarNavigationSuccessState) {
              _logger.i('✅ Navigation success: Navigating to DailyCalendar.');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.goNamed(
                  AppRoutesName.dailyCalendar,
                  extra: {'outfitId': DateTime.now().millisecondsSinceEpoch.toString()},
                );
              });
            } else if (state is DailyCalendarSaveFailureState) {
              _logger.e('❌ Navigation failed.');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.of(context).calendarNavigationFailed)),
              );
            }
          },
        ),
        BlocListener<CalendarNavigationBloc, CalendarNavigationState>(
          listener: (context, state) {
            if (state is CalendarAccessState) {
              if (state.accessStatus == AccessStatus.denied) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.goNamed(
                    AppRoutesName.payment,
                    extra: {
                      'featureKey': FeatureKey.calendar,
                      'isFromMyCloset': false,
                      'previousRoute': AppRoutesName.createOutfit,
                      'nextRoute': AppRoutesName.dailyCalendar,
                    },
                  );
                });
              } else if (state.accessStatus == AccessStatus.trialPending) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.goNamed(
                    AppRoutesName.trialStarted,
                    extra: {
                      'selectedFeatureRoute': AppRoutesName.dailyCalendar,
                      'isFromMyCloset': false,
                    },
                  );
                });
              } else if (state.accessStatus == AccessStatus.granted) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.read<DailyCalendarBloc>().add(const FetchDailyCalendarEvent());
                  context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
                });
              }
            }
          },
        ),
        BlocListener<OutfitSelectionBloc, OutfitSelectionState>(
          listener: (context, state) {
            if (state is ActiveItemsFetched) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.pushNamed(
                  AppRoutesName.createOutfit,
                  extra: {'selectedItemIds': state.activeItemIds},
                );
              });
            } else if (state is OutfitSelectionError) {
              _logger.e('Error fetching active items: ${state.message}');
              CustomSnackbar(
                message: S.of(context).failedToLoadItems,
                theme: Theme.of(context),
              ).show(context);
            }
          },
        ),
        BlocListener<OutfitFocusedDateCubit, OutfitFocusedDateState>(
          listener: (context, state) {
            if (state is OutfitFocusedDateSuccess) {
              _logger.i("✅ Focused date saved. Navigating to outfit details.");
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.pushNamed(
                  AppRoutesName.dailyDetailedCalendar,
                  extra: {'outfitId': state.outfitId},
                );
              });
            } else if (state is OutfitFocusedDateFailure) {
              _logger.e('❌ Failed to set focused date: ${state.error}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.of(context).calendarNavigationFailed)),
              );
            }
          },
        ),
      ],
      child: child,
    );
  }
}
