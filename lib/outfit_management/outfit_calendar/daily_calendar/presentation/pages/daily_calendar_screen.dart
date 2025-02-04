import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../../core/widgets/progress_indicator/outfit_progress_indicator.dart';
import '../bloc/daily_calendar_bloc.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../widgets/daily_calendar_carousel.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/logger.dart';
import '../widgets/daily_feature_container.dart';
import '../../../../../core/utilities/routes.dart';

class DailyCalendarScreen extends StatelessWidget {
  final ThemeData theme;

  static final _logger = CustomLogger('DailyCalendarScreen');

  const DailyCalendarScreen({super.key, required this.theme});

  @override
  Widget build(BuildContext context) {
    _logger.i('Building DailyCalendarScreen');

    return BlocBuilder<DailyCalendarBloc, DailyCalendarState>(
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
          final formattedDate = DateFormat('dd/MM/yyyy').format(dailyCalendarState.focusedDate);
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
                children: [
                  DailyFeatureContainer(
                    theme: Theme.of(context),
                    onCalendarButtonPressed: () {
                      _logger.i("Calendar button pressed");
                      Navigator.pushReplacementNamed(context, AppRoutes.monthlyCalendar);
                    },
                    onPreviousButtonPressed: () {
                      _logger.i("Previous button pressed");
                      context.read<DailyCalendarBloc>().add(const NavigateCalendarEvent(direction: 'backward'));
                    },
                    onNextButtonPressed: () {
                      _logger.i("Next button pressed");
                      context.read<DailyCalendarBloc>().add(const NavigateCalendarEvent(direction: 'forward'));
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
                    child: DailyCalendarCarousel(
                      outfits: outfits,
                      theme: Theme.of(context),
                      crossAxisCount: crossAxisCount,
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
    );
  }
}
