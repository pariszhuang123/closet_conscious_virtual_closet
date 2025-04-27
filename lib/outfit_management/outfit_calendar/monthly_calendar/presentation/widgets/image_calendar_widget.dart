import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../generated/l10n.dart';
import '../widgets/day_outfit_widget.dart'; // Import the DayOutfitWidget
import '../../../../core/data/models/monthly_calendar_response.dart';
import '../../../../core/data/models/outfit_data.dart';
import '../bloc/monthly_calendar_images_bloc/monthly_calendar_images_bloc.dart';
import '../../../../core/presentation/bloc/outfit_selection_bloc/outfit_selection_bloc.dart';
import '../../../../../core/utilities/logger.dart';

class ImageCalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime firstDay;
  final DateTime lastDay;
  final List<CalendarData> calendarData;
  final bool isCalendarSelectable;
  final int crossAxisCount;
  final List<String> selectedOutfitIds; // ✅ Add this
  final Function(String) onToggleSelection; // ✅ Add this

  const ImageCalendarWidget({
    super.key,
    required this.focusedDay,
    required this.firstDay,
    required this.lastDay,
    required this.calendarData,
    required this.isCalendarSelectable,
    required this.crossAxisCount,
    required this.selectedOutfitIds, // ✅ Add this
    required this.onToggleSelection, // ✅ Add this
  });

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('ImageCalendarWidget');
    logger.i('Building ImageCalendarWidget...');
    logger.i(
      'Focused Day: $focusedDay, First Day: $firstDay, Last Day: $lastDay, Calendar Entries: ${calendarData.length}',
    );

    return Column(
      mainAxisSize: MainAxisSize.max, // Let the Column wrap its content
      children: [
        TableCalendar(
          firstDay: DateTime.utc(firstDay.year, firstDay.month, firstDay.day),
          lastDay: DateTime.utc(lastDay.year, lastDay.month, lastDay.day),
          focusedDay: DateTime.utc(focusedDay.year, focusedDay.month, focusedDay.day),
          calendarStyle: _buildCalendarStyle(context),
          headerStyle: _buildHeaderStyle(context),
          daysOfWeekStyle: _buildDaysOfWeekStyle(context),
          calendarBuilders: CalendarBuilders(
            defaultBuilder: (context, date, _) =>
                _buildDefaultCell(context, date, logger),
            todayBuilder: (context, date, _) =>
                _buildTodayCell(context, date, logger),
          ),
          onDaySelected: (selectedDay, _) {
            _handleDaySelected(context, selectedDay, logger);
          },
          pageJumpingEnabled: false,
          availableGestures: AvailableGestures.verticalSwipe,
          sixWeekMonthsEnforced: false,
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
      cellMargin: EdgeInsets.zero, // Reduce margin between cells
      cellAlignment: Alignment.center,
    );
  }

  /// Helper to build header style
  HeaderStyle _buildHeaderStyle(BuildContext context) {
    return HeaderStyle(
      titleTextStyle: Theme.of(context).textTheme.displayLarge!,
      titleCentered: true,
      formatButtonVisible: false, // Hide the format button
      leftChevronVisible: false, // Hide the left chevron
      rightChevronVisible: false, // Hide the right chevron
      formatButtonTextStyle: Theme.of(context).textTheme.bodyMedium!,
      formatButtonDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  DaysOfWeekStyle _buildDaysOfWeekStyle(BuildContext context) {
    final textTheme = Theme.of(context).textTheme; // Access the theme's text styles

    return DaysOfWeekStyle(
      weekdayStyle: textTheme.bodySmall!,
      weekendStyle: textTheme.bodySmall!
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
        isSelectable: isCalendarSelectable, // ✅ Pass the correct value
        selectedOutfitIds: selectedOutfitIds, // ✅ Use from constructor
        crossAxisCount: crossAxisCount,
        onOutfitSelected: onToggleSelection, // ✅ Use from constructor
        onNavigate: () {
          final outfitId = calendarEntry.outfitData.outfitId;
          if (outfitId.isNotEmpty) {
            logger.i('Updating focused date using outfitId: $outfitId');
            context.read<MonthlyCalendarImagesBloc>().add(
              UpdateFocusedDate(outfitId: outfitId),
            );
          } else {
            logger.w('No valid outfitId found for navigation. Ignoring request.');
          }
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

    // Fetch outfitId for the selected date
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

    final outfitId = calendarEntry.outfitData.outfitId;

    if (outfitId.isNotEmpty) {
      if (isCalendarSelectable) {
        logger.i('Toggling outfit selection for outfitId: $outfitId on date: $normalizedDay');
        context.read<OutfitSelectionBloc>().add(
          ToggleOutfitSelectionEvent(outfitId),
        );
      } else {
        logger.i('Updating focused date using outfitId: $outfitId');
        context.read<MonthlyCalendarImagesBloc>().add(
          UpdateFocusedDate(outfitId: outfitId),
        );
      }
    } else {
      logger.w('No valid outfitId found for selected date: $normalizedDay. Ignoring update.');
    }
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
