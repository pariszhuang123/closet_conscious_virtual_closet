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
import '../../../../../core/utilities/helper_functions/navigate_once_helper.dart';

class DailyDetailedCalendarListeners extends StatefulWidget {
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
  State<DailyDetailedCalendarListeners> createState() => _DailyDetailedCalendarListenersState();
}

class _DailyDetailedCalendarListenersState extends State<DailyDetailedCalendarListeners> with NavigateOnceHelper{
  final _logger = CustomLogger('DailyDetailedCalendarListeners');

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<DailyCalendarBloc, DailyCalendarState>(
          listener: (context, state) {
            if (state is DailyCalendarNavigationSuccessState) {
              _logger.i('Navigation success → DailyDetailedCalendar');
              navigateOnce(() {
                context.goNamed(
                  AppRoutesName.dailyDetailedCalendar,
                  extra: {'outfitId': DateTime.now().millisecondsSinceEpoch.toString()},
                );
              });
            } else if (state is DailyCalendarSaveFailureState) {
              _logger.e('Navigation failure from calendar bloc');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.of(context).calendarNavigationFailed)),
              );
            }
          },
        ),
        BlocListener<OutfitSelectionBloc, OutfitSelectionState>(
          listener: (context, state) {
            if (state is ActiveItemsFetched) {
              _logger.i('Items fetched, navigating to create outfit');
              navigateOnce(() {
                context.pushNamed(
                  AppRoutesName.createOutfit,
                  extra: {'selectedItemIds': state.activeItemIds},
                );
              });
            } else if (state is OutfitSelectionError) {
              _logger.e('Item fetch failed: ${state.message}');
              CustomSnackbar(
                message: S.of(context).failedToLoadItems,
                theme: widget.theme,
              ).show(context);
            }
          },
        ),
        BlocListener<OutfitFocusedDateCubit, OutfitFocusedDateState>(
          listener: (context, state) {
            if (state is OutfitFocusedDateSuccess) {
              _logger.i('Focused date saved, navigating to analytics');
              navigateOnce(() {
                context.pushNamed(
                  AppRoutesName.relatedOutfitAnalytics,
                  extra: widget.outfitId,
                );
              });
            } else if (state is OutfitFocusedDateFailure) {
              _logger.e('Focused date failed: ${state.error}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.of(context).calendarNavigationFailed)),
              );
            }
          },
        ),
      ],
      child: widget.child,
    );
  }
}
