import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';
import '../../../daily_calendar/presentation/bloc/daily_calendar_bloc.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../widgets/daily_detailed_calendar_carousel.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../daily_calendar/presentation/widgets/daily_feature_container.dart';
import '../../../../../core/utilities/routes.dart';

class DailyDetailedCalendarScreen extends StatelessWidget {
  final ThemeData theme;
  final String? outfitId; // ✅ Accept outfitId

  static final _logger = CustomLogger('DailyDetailedCalendarScreen');

  const DailyDetailedCalendarScreen({super.key, required this.theme, this.outfitId});

  void _onArrangeButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedItemIds = context.read<MultiSelectionItemCubit>().state.selectedItemIds;
    Navigator.pushNamed(
      context,
      AppRoutes.customize,
      arguments: {
        'isFromMyCloset': true,
        'selectedItemIds': selectedItemIds,
        'returnRoute': AppRoutes.dailyDetailedCalendar,
      },
    );
  }

  void _onItemSelected(BuildContext context) {
    final selectedItemId = context.read<SingleSelectionItemCubit>().state.selectedItemId;

    if (selectedItemId != null) {
      _logger.i("Navigating to item details for itemId: $selectedItemId");

      Navigator.pushNamed(
        context,
        AppRoutes.editItem, // ✅ Ensure this route exists
        arguments: {'itemId': selectedItemId},
      );
    } else {
      _logger.w("No item selected, navigation not triggered.");
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.i('Building DailyCalendarScreen');

    return BlocListener<DailyCalendarBloc, DailyCalendarState>(
      listener: (context, state) {
        // Listen for the navigation success state and navigate accordingly
        if (state is DailyCalendarNavigationSuccessState) {
          _logger.i('Navigation success state detected. Navigating to DailyCalendar.');
          Navigator.pushReplacementNamed(context, AppRoutes.dailyDetailedCalendar);
        }
        // You can also handle failure states here if needed
        else if (state is DailyCalendarSaveFailureState) {
          _logger.e('Navigation failed.');
          // Optionally, show a snackbar or dialog for error feedback
        }
      },
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
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      child: DailyDetailedCalendarCarousel(
                        outfits: outfits,
                        theme: Theme.of(context),
                        crossAxisCount: crossAxisCount,
                        onOutfitTap: (outfitId) {
                          _logger.i("Navigating to outfit details for outfitId: $outfitId");
                          Navigator.pushNamed(
                            context,
                            AppRoutes.dailyDetailedCalendar, // Ensure this route is defined
                            arguments: {'outfitId': outfitId},
                          );
                        },
                        onAction: () {
                          _onItemSelected(context); // ✅ Call when an item is tapped
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
