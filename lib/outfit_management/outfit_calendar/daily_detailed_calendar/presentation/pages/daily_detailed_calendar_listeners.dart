import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utilities/logger.dart';
import '../../../../../core/utilities/app_router.dart';
import '../../../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../../../generated/l10n.dart';

import '../../../daily_calendar/presentation/bloc/daily_calendar_bloc.dart';
import '../../../../../core/usage_analytics/core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../core/presentation/bloc/outfit_selection_bloc/outfit_selection_bloc.dart';

class DailyDetailedCalendarListeners extends StatelessWidget {
  final Widget child;
  final ThemeData theme;
  final String? outfitId;

  const DailyDetailedCalendarListeners({
    super.key,
    required this.child,
    required this.theme,
    required this.outfitId,
  });

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('DailyDetailedCalendarListeners');

    return MultiBlocListener(
      listeners: [
        BlocListener<DailyCalendarBloc, DailyCalendarState>(
          listener: (context, state) {
            if (state is DailyCalendarNavigationSuccessState) {
              logger.i('Navigation success, navigating to DailyDetailedCalendar.');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.goNamed(
                  AppRoutesName.dailyDetailedCalendar,
                  extra: {'outfitId': DateTime.now().millisecondsSinceEpoch.toString()},
                );
              });
            } else if (state is DailyCalendarSaveFailureState) {
              logger.e('Navigation failed.');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.of(context).calendarNavigationFailed)),
              );
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
              logger.e('Error fetching active items: ${state.message}');
              CustomSnackbar(
                message: S.of(context).failedToLoadItems,
                theme: theme,
              ).show(context);
            }
          },
        ),
        BlocListener<OutfitFocusedDateCubit, OutfitFocusedDateState>(
          listener: (context, state) {
            if (state is OutfitFocusedDateSuccess) {
              logger.i("✅ Focused date saved. Navigating to outfit details.");
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.pushNamed(
                  AppRoutesName.relatedOutfitAnalytics,
                  extra: outfitId,
                );
              });
            } else if (state is OutfitFocusedDateFailure) {
              logger.e('❌ Failed to set focused date: ${state.error}');
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
