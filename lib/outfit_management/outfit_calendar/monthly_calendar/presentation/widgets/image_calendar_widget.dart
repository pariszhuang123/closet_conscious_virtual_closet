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
  final List<CalendarData> calendarData; // Updated to CalendarData
  final bool isCalendarSelectable;
  final int crossAxisCount;

  const ImageCalendarWidget({
    super.key,
    required this.focusedDay,
    required this.firstDay,
    required this.lastDay,
    required this.calendarData, // Updated to CalendarData
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
            firstDay: firstDay,
            lastDay: lastDay,
            focusedDay: focusedDay,
            calendarStyle: CalendarStyle(
              defaultTextStyle: Theme.of(context).textTheme.bodyMedium!,
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.rectangle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.rectangle,
              ),
            ),
            headerStyle: HeaderStyle(
              titleTextStyle: Theme.of(context).textTheme.displayLarge!,
              formatButtonTextStyle: Theme.of(context).textTheme.bodyMedium!,
              formatButtonDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, date, _) {
                // Find CalendarData for the specific date
                final calendarEntry = calendarData.firstWhere(
                      (entry) => entry.date.isAtSameMomentAs(date),
                  orElse: () => CalendarData(
                    date: date,
                    outfitData: OutfitData(
                      outfitId: '',
                      outfitImageUrl: null,
                      items: [],
                    ),
                  ),
                );

                if (calendarEntry.outfitData.isEmpty) {
                  // No outfit: Show plain text for the date
                  return Center(
                    child: Text(
                      '${date.day}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  );
                }

                final isGridDisplay = calendarEntry.outfitData.outfitImageUrl == null;

                return DayOutfitWidget(
                  date: date,
                  outfit: calendarEntry.outfitData,
                  isGridDisplay: isGridDisplay,
                  isSelectable: isCalendarSelectable,
                  crossAxisCount: crossAxisCount,
                  onOutfitSelected: (outfitId) {
                    logger.i('Outfit selected: $outfitId on date: $date');
                    context.read<MonthlyCalendarImagesBloc>().add(
                      CalendarInteraction(
                        selectedDate: date,
                        outfitId: outfitId,
                        isCalendarSelectable: true,
                      ),
                    );
                  },
                  onNavigate: () {
                    logger.i('Navigating to outfitId: ${calendarEntry.outfitData.outfitId} on date: $date');
                    context.read<MonthlyCalendarImagesBloc>().add(
                      CalendarInteraction(
                        selectedDate: date,
                        outfitId: calendarEntry.outfitData.outfitId,
                        isCalendarSelectable: false,
                      ),
                    );
                  },
                );
              },
              todayBuilder: (context, date, _) {
                logger.d('Rendering today\'s date: $date');
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.rectangle,
                  ),
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
                    ),
                  ),
                );
              },
            ),
            onDaySelected: (selectedDay, _) {
              final calendarEntry = calendarData.firstWhere(
                    (entry) => entry.date.isAtSameMomentAs(selectedDay),
                orElse: () => CalendarData(
                  date: selectedDay,
                  outfitData: OutfitData(
                    outfitId: '',
                    outfitImageUrl: null,
                    items: [],
                  ),
                ),
              );

              logger.i('Day selected: $selectedDay, OutfitId: ${calendarEntry.outfitData.outfitId}');
              context.read<MonthlyCalendarImagesBloc>().add(
                CalendarInteraction(
                  selectedDate: selectedDay,
                  outfitId: calendarEntry.outfitData.outfitId,
                  isCalendarSelectable: isCalendarSelectable,
                ),
              );
            },
          ),
        ),
        if (calendarData.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              S.of(context).noOutfitsInMonth,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ),
      ],
    );
  }
}
