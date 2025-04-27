import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../bloc/daily_calendar_bloc.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../widgets/daily_calendar_carousel.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/logger.dart';
import '../widgets/daily_feature_container.dart';
import '../../../../../core/utilities/app_router.dart';
import '../../../../../core/core_enums.dart';
import '../../../core/presentation/bloc/calendar_navigation_bloc/calendar_navigation_bloc.dart';
import '../../../../../core/usage_analytics/core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../core/presentation/bloc/outfit_selection_bloc/outfit_selection_bloc.dart';
import '../../../../../core/widgets/feedback/custom_snack_bar.dart';

class DailyCalendarScreen extends StatelessWidget {
  final ThemeData myOutfitTheme;
  final String? outfitId;

  static final _logger = CustomLogger('DailyCalendarScreen');

  const DailyCalendarScreen(
      {super.key, required this.myOutfitTheme, this.outfitId});

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
        data: myOutfitTheme, // ✅ Apply your custom theme
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
              S
                  .of(context)
                  .calendarFeatureTitle,
              style: Theme
                  .of(context)
                  .textTheme
                  .titleMedium, // Now will use myOutfitTheme
            ),
          ),
          body: MultiBlocListener(
            listeners: [
              BlocListener<DailyCalendarBloc, DailyCalendarState>(
                listener: (context, state) {
                  if (state is DailyCalendarNavigationSuccessState) {
                    _logger.i('✅ Navigation success: Navigating to DailyCalendar.');
                    context.goNamed(
                      AppRoutesName.dailyCalendar,
                      extra: {'outfitId': DateTime.now().millisecondsSinceEpoch.toString()},
                    );
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
                      _logger.w('🚫 Access denied: Navigating to payment page');
                      context.goNamed(
                        AppRoutesName.payment,
                        extra: {
                          'featureKey': FeatureKey.calendar,
                          'isFromMyCloset': false,
                          'previousRoute': AppRoutesName.createOutfit,
                          'nextRoute': AppRoutesName.dailyCalendar,
                        },
                      );
                    } else if (state.accessStatus == AccessStatus.trialPending) {
                      _logger.i('⏳ Trial pending, navigating to trialStarted screen');
                      context.goNamed(
                        AppRoutesName.trialStarted,
                        extra: {
                          'selectedFeatureRoute': AppRoutesName.dailyCalendar,
                          'isFromMyCloset': false,
                        },
                      );
                    }
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
                      theme: Theme.of(context),
                    ).show(context);
                  }
                },
              ),
              BlocListener<OutfitFocusedDateCubit, OutfitFocusedDateState>(
                listener: (context, state) {
                  if (state is OutfitFocusedDateSuccess) {
                    _logger.i("✅ Focused date saved. Navigating to outfit details.");

                    context.pushNamed(
                      AppRoutesName.dailyDetailedCalendar,
                      extra: {'outfitId': state.outfitId},
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
                            onCalendarButtonPressed: () {
                              context.goNamed(AppRoutesName.monthlyCalendar);
                            },
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