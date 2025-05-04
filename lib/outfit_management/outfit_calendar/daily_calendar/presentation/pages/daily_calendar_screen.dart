import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/theme/my_outfit_theme.dart';
import '../../../../../core/widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../bloc/daily_calendar_bloc.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../widgets/daily_calendar_carousel.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/logger.dart';
import '../widgets/daily_feature_container.dart';
import '../../../../../core/utilities/app_router.dart';
import '../../../core/presentation/bloc/calendar_navigation_bloc/calendar_navigation_bloc.dart';
import '../../../../../core/usage_analytics/core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../core/presentation/bloc/outfit_selection_bloc/outfit_selection_bloc.dart';
import 'daily_calendar_listeners.dart';

class DailyCalendarScreen extends StatefulWidget {
  final ThemeData myOutfitTheme;
  final String? outfitId;

  const DailyCalendarScreen({
    super.key,
    required this.myOutfitTheme,
    this.outfitId,
  });

  @override
  State<DailyCalendarScreen> createState() => _DailyCalendarScreenState();
}

class _DailyCalendarScreenState extends State<DailyCalendarScreen> {
  static final _logger = CustomLogger('DailyCalendarScreen');

  @override
  void initState() {
    super.initState();

    // ⏱️ Initial event triggers (previously in Provider)
    context.read<CalendarNavigationBloc>().add(CheckCalendarAccessEvent());

    _logger.i('Initial events triggered from initState');
  }

  void _onArrangeButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedItemIds = context
        .read<MultiSelectionItemCubit>()
        .state
        .selectedItemIds;
    context.pushNamed(
      AppRoutesName.customize,
      extra: {
        'isFromMyCloset': true,
        'selectedItemIds': selectedItemIds,
        'returnRoute': AppRoutesName.dailyCalendar,
      },
    );
  }

  void _onCreateOutfitButtonPressed(BuildContext context, bool isFromMyCloset) {
    final dailyCalendarBloc = context.read<DailyCalendarBloc>();
    final outfitSelectionBloc = context.read<OutfitSelectionBloc>();

    final state = dailyCalendarBloc.state;
    if (state is DailyCalendarLoaded) {
      final allOutfitIds = state.dailyOutfits.map((outfit) => outfit.outfitId)
          .toList();
      outfitSelectionBloc.add(SelectAllOutfitsEvent(allOutfitIds));
      outfitSelectionBloc.add(FetchActiveItemsEvent(allOutfitIds));
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.i('Building DailyCalendarScreen');

    return DailyCalendarListeners( // ✅ Wrap everything
        child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) {
      _logger.i('Pop invoked: didPop = $didPop, result = $result');
      if (!didPop) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.goNamed(AppRoutesName.monthlyCalendar);
        });
      }
    },
      child: Theme(
        data: myOutfitTheme, // ✅ Apply your custom theme
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
                  _logger.i(
                      'BackButton: Navigator cannot pop, going to MonthlyCalendar.');
                  context.goNamed(AppRoutesName.monthlyCalendar);
                }
              },
            ),
            title: Text(
              S
                  .of(context)
                  .calendarFeatureTitle,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium, // Now will use myOutfitTheme
            ),
          ),
            body: BlocBuilder<DailyCalendarBloc, DailyCalendarState>(
              builder: (context, dailyCalendarState) {
                if (dailyCalendarState is DailyCalendarLoading) {
                  return const Center(child: OutfitProgressIndicator());
                } else if (dailyCalendarState is DailyCalendarError) {
                  return Center(
                      child: Text('Error: ${dailyCalendarState.message}'));
                } else if (dailyCalendarState is DailyCalendarLoaded) {
                  final outfits = dailyCalendarState.dailyOutfits;
                  final formattedDate = DateFormat('dd/MM/yyyy').format(
                      dailyCalendarState.focusedDate);

                  if (outfits.isEmpty) {
                    return Center(child: Text(S
                        .of(context)
                        .noItemsInCloset));
                  }

                  return BlocBuilder<CrossAxisCountCubit, int>(
                    builder: (context, crossAxisCount) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DailyFeatureContainer(
                            theme: myOutfitTheme,
                            onArrangeButtonPressed: () =>
                                _onArrangeButtonPressed(context, false),
                            onPreviousButtonPressed: () {
                              context.read<DailyCalendarBloc>().add(
                                const NavigateCalendarEvent(
                                    direction: 'backward'),
                              );
                            },
                            onNextButtonPressed: () {
                              context.read<DailyCalendarBloc>().add(
                                const NavigateCalendarEvent(
                                    direction: 'forward'),
                              );
                            },
                            onCreateOutfitButtonPressed: () =>
                                _onCreateOutfitButtonPressed(context, false),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              formattedDate,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodyMedium,
                            ),
                          ),
                          Expanded(
                            child: DailyCalendarCarousel(
                              outfits: outfits,
                              theme: myOutfitTheme,
                              crossAxisCount: crossAxisCount,
                              onTap: (outfitId) {
                                context.read<OutfitFocusedDateCubit>()
                                    .setFocusedDateForOutfit(outfitId);
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }
}