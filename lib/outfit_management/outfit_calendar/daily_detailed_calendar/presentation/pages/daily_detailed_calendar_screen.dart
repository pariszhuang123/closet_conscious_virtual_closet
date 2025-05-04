import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';
import '../../../daily_calendar/presentation/bloc/daily_calendar_bloc.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../widgets/daily_detailed_calendar_carousel.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../daily_calendar/presentation/widgets/daily_feature_container.dart';
import '../../../../../core/utilities/app_router.dart';
import '../../../../../core/usage_analytics/core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../core/presentation/bloc/outfit_selection_bloc/outfit_selection_bloc.dart';
import 'daily_detailed_calendar_listeners.dart';

class DailyDetailedCalendarScreen extends StatefulWidget {
  final ThemeData theme;
  final String? outfitId;

  const DailyDetailedCalendarScreen({
    super.key,
    required this.theme,
    this.outfitId,
  });

  @override
  State<DailyDetailedCalendarScreen> createState() => _DailyDetailedCalendarScreenState();
}

class _DailyDetailedCalendarScreenState extends State<DailyDetailedCalendarScreen> {
  static final _logger = CustomLogger('DailyDetailedCalendarScreen');

  @override
  void initState() {
    super.initState();

    _logger.i('initState: Triggering initial events');

    context.read<DailyCalendarBloc>().add(const FetchDailyCalendarEvent());
    context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
  }

  void _onArrangeButtonPressed(BuildContext context) {
    final selectedItemIds = context.read<MultiSelectionItemCubit>().state.selectedItemIds;
    context.pushNamed(
      AppRoutesName.customize,
      extra: {
        'isFromMyCloset': true,
        'selectedItemIds': selectedItemIds,
        'returnRoute': AppRoutesName.dailyDetailedCalendar,
      },
    );
  }

  void _onItemSelected(BuildContext context) {
    final selectedItemId = context.read<SingleSelectionItemCubit>().state.selectedItemId;

    if (selectedItemId != null) {
      _logger.i("Navigating to item details for itemId: $selectedItemId");

      context.pushNamed(
        AppRoutesName.focusedItemsAnalytics,
        extra: selectedItemId,
      );
    } else {
      _logger.w("No item selected, navigation not triggered.");
    }
  }

  void _onCreateOutfitButtonPressed(BuildContext context) {
    final dailyCalendarBloc = context.read<DailyCalendarBloc>();
    final outfitSelectionBloc = context.read<OutfitSelectionBloc>();

    final state = dailyCalendarBloc.state;
    if (state is DailyCalendarLoaded) {
      final allOutfitIds = state.dailyOutfits.map((outfit) => outfit.outfitId).toList();
      outfitSelectionBloc.add(SelectAllOutfitsEvent(allOutfitIds));
      outfitSelectionBloc.add(FetchActiveItemsEvent(allOutfitIds));
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.i('Building DailyDetailedCalendarScreen');

    return DailyDetailedCalendarListeners(
        theme: widget.theme,
        outfitId: widget.outfitId,
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
        data: widget.theme,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
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
              S.of(context).calendarFeatureTitle,
              style: widget.theme.textTheme.titleMedium, // ✅ Use `theme`
            ),
          ),
            body: BlocBuilder<DailyCalendarBloc, DailyCalendarState>(
              builder: (context, dailyCalendarState) {
                if (dailyCalendarState is DailyCalendarLoading) {
                  return const Center(child: OutfitProgressIndicator());
                } else if (dailyCalendarState is DailyCalendarError) {
                  return Center(child: Text('Error: ${dailyCalendarState.message}'));
                } else if (dailyCalendarState is DailyCalendarLoaded) {
                  final outfits = dailyCalendarState.dailyOutfits;
                  final formattedDate = DateFormat('dd/MM/yyyy').format(dailyCalendarState.focusedDate);

                  if (outfits.isEmpty) {
                    return Center(child: Text(S.of(context).noItemsInCloset));
                  }

                  return BlocBuilder<CrossAxisCountCubit, int>(
                    builder: (context, crossAxisCount) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          DailyFeatureContainer(
                            theme: widget.theme, // ✅ Use `theme`
                            onArrangeButtonPressed: () => _onArrangeButtonPressed(context),
                            onPreviousButtonPressed: () {
                              context.read<DailyCalendarBloc>().add(
                                const NavigateCalendarEvent(direction: 'backward'),
                              );
                            },
                            onNextButtonPressed: () {
                              context.read<DailyCalendarBloc>().add(
                                const NavigateCalendarEvent(direction: 'forward'),
                              );
                            },
                            onCreateOutfitButtonPressed: () => _onCreateOutfitButtonPressed(context),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              formattedDate,
                              style: widget.theme.textTheme.bodyMedium, // ✅ Use `theme`
                            ),
                          ),
                          Expanded(
                            child: DailyDetailedCalendarCarousel(
                              outfits: outfits,
                              theme: widget.theme, // ✅ Use `theme`
                              crossAxisCount: crossAxisCount,
                              onOutfitTap: (outfitId) {
                                context.read<OutfitFocusedDateCubit>().setFocusedDateForOutfit(outfitId);
                              },
                              onAction: () => _onItemSelected(context),
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
