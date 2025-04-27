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
import '../../../../../core/widgets/feedback/custom_snack_bar.dart';

class DailyDetailedCalendarScreen extends StatelessWidget {
  final ThemeData theme;
  final String? outfitId;

  static final _logger = CustomLogger('DailyDetailedCalendarScreen');

  const DailyDetailedCalendarScreen({
    super.key,
    required this.theme,
    this.outfitId,
  });

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

    return PopScope(
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
        data: theme,
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
              style: theme.textTheme.titleMedium, // ✅ Use `theme`
            ),
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<DailyCalendarBloc, DailyCalendarState>(
                listener: (context, state) {
                  if (state is DailyCalendarNavigationSuccessState) {
                    _logger.i('Navigation success, navigating to DailyDetailedCalendar.');
                    context.goNamed(
                      AppRoutesName.dailyDetailedCalendar,
                      extra: {'outfitId': DateTime.now().millisecondsSinceEpoch.toString()},
                    );
                  } else if (state is DailyCalendarSaveFailureState) {
                    _logger.e('Navigation failed.');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(S.of(context).calendarNavigationFailed)),
                    );
                  }
                },
              ),
              BlocListener<OutfitSelectionBloc, OutfitSelectionState>(
                listener: (context, state) {
                  if (state is ActiveItemsFetched) {
                    context.pushNamed(
                      AppRoutesName.createOutfit,
                      extra: {
                        'selectedItemIds': state.activeItemIds,
                      },
                    );
                  } else if (state is OutfitSelectionError) {
                    _logger.e('Error fetching active items: ${state.message}');
                    CustomSnackbar(
                      message: S.of(context).failedToLoadItems,
                      theme: theme, // ✅ Use `theme`
                    ).show(context);
                  }
                },
              ),
              BlocListener<OutfitFocusedDateCubit, OutfitFocusedDateState>(
                listener: (context, state) {
                  if (state is OutfitFocusedDateSuccess) {
                    _logger.i("✅ Focused date saved. Navigating to outfit details.");
                    context.pushNamed(
                      AppRoutesName.relatedOutfitAnalytics,
                      extra: outfitId,
                    );
                  } else if (state is OutfitFocusedDateFailure) {
                    _logger.e('❌ Failed to set focused date: ${state.error}');
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(S.of(context).calendarNavigationFailed)),
                    );
                  }
                },
              )
            ],
            child: BlocBuilder<DailyCalendarBloc, DailyCalendarState>(
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
                            theme: theme, // ✅ Use `theme`
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
                              style: theme.textTheme.bodyMedium, // ✅ Use `theme`
                            ),
                          ),
                          Expanded(
                            child: DailyDetailedCalendarCarousel(
                              outfits: outfits,
                              theme: theme, // ✅ Use `theme`
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
