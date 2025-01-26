import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/monthly_calendar_metadata_bloc/monthly_calendar_metadata_bloc.dart';
import '../bloc/monthly_calendar_images_bloc/monthly_calendar_images_bloc.dart';
import '../widgets/monthly_calendar_metadata.dart';
import '../widgets/image_calendar_widget.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../core/utilities/logger.dart';

class MonthlyCalendarScreen extends StatefulWidget {
  final ThemeData theme;

  const MonthlyCalendarScreen({super.key, required this.theme});

  @override
  MonthlyCalendarScreenState createState() => MonthlyCalendarScreenState();
}

class MonthlyCalendarScreenState extends State<MonthlyCalendarScreen> {
  late TextEditingController eventNameController;

  @override
  void initState() {
    super.initState();
    eventNameController = TextEditingController();
    // Dispatch initial fetch events
    context.read<MonthlyCalendarMetadataBloc>().add(FetchMonthlyCalendarMetadataEvent());
    context.read<MonthlyCalendarImagesBloc>().add(FetchMonthlyCalendarImages());
  }

  @override
  void dispose() {
    // Dispose of the controller to avoid memory leaks
    eventNameController.dispose();
    super.dispose();
  }

  @override
    Widget build(BuildContext context) {
      final logger = CustomLogger('MonthlyCalendarScreen');
      logger.i('Building MonthlyCalendarScreen...');

      return BlocBuilder<CrossAxisCountCubit, int?>(
        builder: (context, crossAxisCount) {
          if (crossAxisCount == null) {
            logger.w(
                'CrossAxisCountCubit state is null. Showing CircularProgressIndicator.');
            return const Center(child: CircularProgressIndicator());
          }

          logger.i('CrossAxisCountCubit state: $crossAxisCount.');

          return Column(
            children: [
              // Metadata Section
              Expanded(
                flex: 1,
                child: BlocBuilder<
                    MonthlyCalendarMetadataBloc,
                    MonthlyCalendarMetadataState>(
                  builder: (context, state) {
                    if (state is MonthlyCalendarLoadedState) {
                      logger.i(
                          'MonthlyCalendarMetadataBloc loaded with metadata.');
                      final metadata = state.metadataList.first;

                      if (eventNameController.text != metadata.eventName) {
                        final cursorPosition = eventNameController.selection;
                        eventNameController.value = eventNameController.value.copyWith(
                          text: metadata.eventName,
                          selection: cursorPosition,
                        );
                      }

                      return MonthlyCalendarMetadata(
                        metadata: metadata,
                        eventNameController: eventNameController,
                        theme: Theme.of(context),
                        onEventNameChanged: (name) {
                          logger.d('Event name changed to: $name');
                          context.read<MonthlyCalendarMetadataBloc>().add(
                            UpdateSelectedMetadataEvent(
                                metadata.copyWith(eventName: name)),
                          );
                        },
                        onFeedbackChanged: (feedback) {
                          logger.d('Feedback changed to: $feedback');
                          context.read<MonthlyCalendarMetadataBloc>().add(
                            UpdateSelectedMetadataEvent(
                                metadata.copyWith(feedback: feedback)),
                          );
                        },
                        onCalendarSelectableChanged: (isSelectable) {
                          logger.d(
                              'Calendar selectable changed to: $isSelectable');
                          context.read<MonthlyCalendarMetadataBloc>().add(
                            UpdateSelectedMetadataEvent(metadata.copyWith(
                                isCalendarSelectable: isSelectable)),
                          );
                        },
                        onOutfitActiveChanged: (isActive) {
                          logger.d('Outfit active state changed to: ${isActive
                              ? 'true'
                              : 'false'}');
                          context.read<MonthlyCalendarMetadataBloc>().add(
                            UpdateSelectedMetadataEvent(metadata.copyWith(
                                isOutfitActive: isActive ? 'true' : 'false')),
                          );
                        },
                      );
                    }

                    logger.w(
                        'MonthlyCalendarMetadataBloc state not loaded. Showing CircularProgressIndicator.');
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
              const Divider(height: 1),
              // Calendar Section
              Expanded(
                flex: 2,
                child: BlocBuilder<
                    MonthlyCalendarImagesBloc,
                    MonthlyCalendarImagesState>(
                  builder: (context, state) {
                    if (state is MonthlyCalendarImagesLoaded) {
                      logger.i('MonthlyCalendarImagesBloc loaded with images.');
                      final focusedDay = DateTime.parse(state.focusedDate);
                      final firstDay = DateTime.parse(state.startDate);
                      final lastDay = DateTime.parse(state.endDate);

                      return ImageCalendarWidget(
                        calendarData: state.calendarData, // Pass the calendarData directly
                        focusedDay: focusedDay,
                        firstDay: firstDay,
                        lastDay: lastDay,
                        isCalendarSelectable: true,
                        crossAxisCount: crossAxisCount,
                      );
                    }

                    logger.w(
                        'MonthlyCalendarImagesBloc state not loaded. Showing CircularProgressIndicator.');
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          );
        },
      );
    }
  }