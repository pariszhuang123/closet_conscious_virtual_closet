import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../bloc/daily_calendar_bloc.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../widgets/daily_calendar_carousel.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/logger.dart';
import '../widgets/daily_feature_container.dart';
import '../../../../../core/utilities/routes.dart';
import '../../../../../core/core_enums.dart';
import '../../../core/presentation/bloc/calendar_navigation_bloc/calendar_navigation_bloc.dart';
import '../../../../../core/paywall/data/feature_key.dart';
import '../../../../../core/usage_analytics/core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../../../../core/presentation/bloc/outfit_selection_bloc/outfit_selection_bloc.dart';
import '../../../../../core/widgets/feedback/custom_snack_bar.dart';

class DailyCalendarScreen extends StatelessWidget {
  final ThemeData theme;
  final String? outfitId; // ✅ Accept outfitId

  static final _logger = CustomLogger('DailyCalendarScreen');

  const DailyCalendarScreen({super.key, required this.theme, this.outfitId});

  void _onArrangeButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedItemIds = context.read<MultiSelectionItemCubit>().state.selectedItemIds;
    Navigator.pushNamed(
      context,
      AppRoutes.customize,
      arguments: {
        'isFromMyCloset': true,
        'selectedItemIds': selectedItemIds,
        'returnRoute': AppRoutes.dailyCalendar,
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

      // Select all outfits
      outfitSelectionBloc.add(SelectAllOutfitsEvent(allOutfitIds));

      // Fetch item IDs from Supabase using the selected outfit IDs
      outfitSelectionBloc.add(
          FetchActiveItemsEvent(allOutfitIds));
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.i('Building DailyCalendarScreen');

    return MultiBlocListener(
      listeners: [
        BlocListener<DailyCalendarBloc, DailyCalendarState>(
          listener: (context, state) {
            if (state is DailyCalendarNavigationSuccessState) {
              _logger.i('✅ Navigation success: Navigating to DailyCalendar.');
              Navigator.pushReplacementNamed(context, AppRoutes.dailyCalendar);
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
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.payment,
                  arguments: {
                    'featureKey': FeatureKey.calendar,
                    'isFromMyCloset': false,
                    'previousRoute': AppRoutes.createOutfit,
                    'nextRoute': AppRoutes.dailyCalendar,
                  },
                );
              } else if (state.accessStatus == AccessStatus.trialPending) {
                _logger.i('⏳ Trial pending, navigating to trialStarted screen');
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.trialStarted,
                  arguments: {
                    'selectedFeatureRoute': AppRoutes.dailyCalendar,
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
              Navigator.pushNamed(
                context,
                AppRoutes.createOutfit,
                arguments: {
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

              Navigator.pushNamed(
                context,
                AppRoutes.dailyDetailedCalendar,
                arguments: {'outfitId': state.outfitId},
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
          _logger.d('DailyCalendarBloc State: ${dailyCalendarState.runtimeType}');

          if (dailyCalendarState is DailyCalendarLoading) {
            _logger.i('Daily Calendar is loading...');
            return const Center(child: OutfitProgressIndicator());
          } else if (dailyCalendarState is DailyCalendarError) {
            _logger.e('Error in Daily Calendar: ${dailyCalendarState.message}');
            return Center(child: Text('Error: ${dailyCalendarState.message}'));
          } else if (dailyCalendarState is DailyCalendarLoaded) {
            final outfits = dailyCalendarState.dailyOutfits;
            final formattedDate =
            DateFormat('dd/MM/yyyy').format(dailyCalendarState.focusedDate);
            _logger.i('Loaded ${outfits.length} outfits for the calendar');
            _logger.i('Focused Date: $formattedDate');

            if (outfits.isEmpty) {
              _logger.w('No outfits found in the closet');
              return Center(child: Text(S.of(context).noItemsInCloset));
            }

            return BlocBuilder<CrossAxisCountCubit, int>(
              builder: (context, crossAxisCount) {
                _logger.d('CrossAxisCountCubit State: $crossAxisCount');

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DailyFeatureContainer(
                      theme: Theme.of(context),
                      onCalendarButtonPressed: () {
                        _logger.i("Calendar button pressed");
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.monthlyCalendar);
                      },
                      onArrangeButtonPressed: () => _onArrangeButtonPressed(context, false),
                      onPreviousButtonPressed: () {
                        _logger.i("Previous button pressed");
                        context.read<DailyCalendarBloc>().add(
                          const NavigateCalendarEvent(direction: 'backward'),
                        );
                      },
                      onNextButtonPressed: () {
                        _logger.i("Next button pressed");
                        context.read<DailyCalendarBloc>().add(
                          const NavigateCalendarEvent(direction: 'forward'),
                        );
                      },
                      onCreateOutfitButtonPressed: () => _onCreateOutfitButtonPressed(context, false),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      child: DailyCalendarCarousel(
                        outfits: outfits,
                        theme: Theme.of(context),
                        crossAxisCount: crossAxisCount,
                        onTap: (outfitId) {
                          _logger.i(
                              "Saving focused date before navigating to outfit details for outfitId: $outfitId");
                          context
                              .read<OutfitFocusedDateCubit>()
                              .setFocusedDateForOutfit(outfitId);
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          }
          _logger.w('No matching state found, rendering empty widget');
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
