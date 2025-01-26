import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../generated/l10n.dart';
import '../widgets/day_outfit_widget.dart'; // Import the DayOutfitWidget
import '../../../../core/data/models/monthly_calendar_response.dart';
import '../bloc/monthly_calendar_images_bloc/monthly_calendar_images_bloc.dart';
import '../../../../../core/utilities/logger.dart';

class ImageCalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime firstDay;
  final DateTime lastDay;
  final List<CalendarData> calendarData;
  final bool isCalendarSelectable;
  final int crossAxisCount;

  const ImageCalendarWidget({
    super.key,
    required this.focusedDay,
    required this.firstDay,
    required this.lastDay,
    required this.calendarData,
    required this.isCalendarSelectable,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('ImageCalendarWidget');
    logger.i('Building ImageCalendarWidget...');
    logger.i(
      'Focused Day: $focusedDay, First Day: $firstDay, Last Day: $lastDay, Calendar Entries: ${calendarData.length}',
    );

    return Column(
      children: [
        Expanded(
          child: TableCalendar(
            firstDay: DateTime.utc(firstDay.year, firstDay.month, firstDay.day),
            lastDay: DateTime.utc(lastDay.year, lastDay.month, lastDay.day),
            focusedDay: DateTime.utc(focusedDay.year, focusedDay.month, focusedDay.day),
            calendarStyle: _buildCalendarStyle(context),
            headerStyle: _buildHeaderStyle(context),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, _) =>
                  _buildDefaultCell(context, date, logger),
              todayBuilder: (context, date, _) =>
                  _buildTodayCell(context, date, logger),
            ),
            onDaySelected: (selectedDay, _) {
              _handleDaySelected(context, selectedDay, logger);
            },
          ),
        ),
        if (calendarData.isEmpty) _buildEmptyState(context),
      ],
    );
  }

  /// Helper to build calendar style
  CalendarStyle _buildCalendarStyle(BuildContext context) {
    return CalendarStyle(
      defaultTextStyle: Theme.of(context).textTheme.bodyMedium!,
      todayDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.rectangle,
      ),
      selectedDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        shape: BoxShape.rectangle,
      ),
    );
  }

  /// Helper to build header style
  HeaderStyle _buildHeaderStyle(BuildContext context) {
    return HeaderStyle(
      titleTextStyle: Theme.of(context).textTheme.displayLarge!,
      formatButtonTextStyle: Theme.of(context).textTheme.bodyMedium!,
      formatButtonDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  /// Default cell builder
  Widget _buildDefaultCell(BuildContext context, DateTime date, CustomLogger logger) {
    final normalizedDate = DateTime.utc(date.year, date.month, date.day);
    logger.d('Rendering default cell for date: $normalizedDate');

    final calendarEntry = calendarData.firstWhere(
          (entry) => entry.date.isAtSameMomentAs(normalizedDate),
      orElse: () {
        logger.w('No entry found for date: $normalizedDate. Using empty CalendarData.');
        return CalendarData(
          date: normalizedDate,
          outfitData: OutfitData.empty(),
        );
      },
    );

    if (calendarEntry.outfitData.isNotEmpty) {
      logger.d('Date $normalizedDate has outfitId: ${calendarEntry.outfitData.outfitId}');
      final isGridDisplay = calendarEntry.outfitData.outfitImageUrl == null;
      return DayOutfitWidget(
        date: normalizedDate,
        outfit: calendarEntry.outfitData,
        isGridDisplay: isGridDisplay,
        isSelectable: isCalendarSelectable,
        crossAxisCount: crossAxisCount,
        onOutfitSelected: (outfitId) {
          logger.i('Outfit selected: $outfitId on date: $normalizedDate');
          context.read<MonthlyCalendarImagesBloc>().add(
            CalendarInteraction(
              selectedDate: normalizedDate,
              outfitId: outfitId,
              isCalendarSelectable: true,
            ),
          );
        },
        onNavigate: () {
          logger.i(
              'Navigating to outfitId: ${calendarEntry.outfitData.outfitId} on date: $normalizedDate');
          context.read<MonthlyCalendarImagesBloc>().add(
            CalendarInteraction(
              selectedDate: normalizedDate,
              outfitId: calendarEntry.outfitData.outfitId,
              isCalendarSelectable: false,
            ),
          );
        },
      );
    }

    logger.d('Date $normalizedDate has no outfit data.');
    return Center(
      child: Text(
        '${normalizedDate.day}',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }

  /// Today cell builder
  Widget _buildTodayCell(BuildContext context, DateTime date, CustomLogger logger) {
    final normalizedDate = DateTime.utc(date.year, date.month, date.day);
    logger.d('Rendering today\'s date: $normalizedDate');
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        shape: BoxShape.rectangle,
      ),
      child: Center(
        child: Text(
          '${normalizedDate.day}',
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }

  /// Handle day selection
  void _handleDaySelected(BuildContext context, DateTime selectedDay, CustomLogger logger) {
    final normalizedDay = DateTime.utc(selectedDay.year, selectedDay.month, selectedDay.day);
    logger.d('Day selected: $normalizedDay');
    final calendarEntry = calendarData.firstWhere(
          (entry) => entry.date.isAtSameMomentAs(normalizedDay),
      orElse: () {
        logger.w('No entry found for selected date: $normalizedDay. Using empty CalendarData.');
        return CalendarData(
          date: normalizedDay,
          outfitData: OutfitData.empty(),
        );
      },
    );

    logger.i('Day selected: $normalizedDay, OutfitId: ${calendarEntry.outfitData.outfitId}');
    context.read<MonthlyCalendarImagesBloc>().add(
      CalendarInteraction(
        selectedDate: normalizedDay,
        outfitId: calendarEntry.outfitData.outfitId,
        isCalendarSelectable: isCalendarSelectable,
      ),
    );
  }

  /// Empty state builder
  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        S.of(context).noOutfitsInMonth,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
    );
  }
}
