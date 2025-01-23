import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../../generated/l10n.dart';
import '../../../../core/presentation/widgets/outfit_display_widget.dart';
import '../../../../../core/core_enums.dart';
import '../../../../core/data/models/monthly_calendar_response.dart';
import '../bloc/monthly_calendar_images_bloc/monthly_calendar_images_bloc.dart';
import '../../../../../core/utilities/logger.dart';

class ImageCalendarWidget extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime firstDay;
  final DateTime lastDay;
  final List<OutfitData> outfits; // List of DailyOutfit
  final bool isCalendarSelectable; // Determines the behavior
  final int crossAxisCount; // Cross axis count for the grid

  const ImageCalendarWidget({
    super.key,
    required this.focusedDay,
    required this.firstDay,
    required this.lastDay,
    required this.outfits,
    required this.isCalendarSelectable,
    required this.crossAxisCount,
  });

  @override
  Widget build(BuildContext context) {
    final logger = CustomLogger('ImageCalendarWidget');
    logger.i('Building ImageCalendarWidget...');
    logger.i(
      'Focused Day: $focusedDay, First Day: $firstDay, Last Day: $lastDay, Outfit Count: ${outfits.length}',
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
                final outfitForDay = outfits.firstWhere(
                      (outfit) => DateTime.parse(outfit.outfitId).isAtSameMomentAs(date),

                );

                final imageSize = outfitForDay.outfitImageUrl?.isNotEmpty == true
                    ? ImageSize.calendarSelfie
                    : ImageSize.calendarOutfitItemGrid3;

                logger.d('Rendering outfit for date: $date, outfitId: ${outfitForDay.outfitId}');

                return OutfitDisplayWidget(
                  outfit: outfitForDay,
                  crossAxisCount: crossAxisCount,
                  imageSize: imageSize,
                  isSelectable: isCalendarSelectable,
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
                    logger.i('Navigating to outfitId: ${outfitForDay.outfitId} on date: $date');
                    context.read<MonthlyCalendarImagesBloc>().add(
                      CalendarInteraction(
                        selectedDate: date,
                        outfitId: outfitForDay.outfitId,
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
              final outfitForDay = outfits.firstWhere(
                    (outfit) => DateTime.parse(outfit.outfitId).isAtSameMomentAs(selectedDay),
              );

              logger.i('Day selected: $selectedDay, OutfitId: ${outfitForDay.outfitId}');
              context.read<MonthlyCalendarImagesBloc>().add(
                CalendarInteraction(
                  selectedDate: selectedDay,
                  outfitId: outfitForDay.outfitId,
                  isCalendarSelectable: isCalendarSelectable,
                ),
              );
                        },
          ),
        ),
        if (outfits.isEmpty)
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
