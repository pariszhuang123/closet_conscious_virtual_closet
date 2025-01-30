import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/monthly_calendar_metadata_bloc/monthly_calendar_metadata_bloc.dart';
import '../bloc/monthly_calendar_images_bloc/monthly_calendar_images_bloc.dart';
import '../widgets/monthly_calendar_metadata.dart';
import '../widgets/image_calendar_widget.dart';
import '../widgets/reset_and_submit_widget.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/utilities/routes.dart';
import '../../../../../core/widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../../generated/l10n.dart';


class MonthlyCalendarScreen extends StatefulWidget {
  final ThemeData theme;

  const MonthlyCalendarScreen({super.key, required this.theme});

  @override
  MonthlyCalendarScreenState createState() => MonthlyCalendarScreenState();
}

class MonthlyCalendarScreenState extends State<MonthlyCalendarScreen> {
  late TextEditingController eventNameController;
  late final CustomLogger logger;

  @override
  void initState() {
    super.initState();
    eventNameController = TextEditingController();
    logger = CustomLogger('MonthlyCalendarScreen');
    logger.i('Initializing MonthlyCalendarScreen...');

    // Dispatch initial events
    context.read<MonthlyCalendarMetadataBloc>().add(
        FetchMonthlyCalendarMetadataEvent());
    logger.i('Dispatched FetchMonthlyCalendarMetadataEvent.');
    context.read<MonthlyCalendarImagesBloc>().add(FetchMonthlyCalendarImages());
    logger.i('Dispatched FetchMonthlyCalendarImages.');
  }

  @override
  void dispose() {
    logger.i('Disposing MonthlyCalendarScreen...');
    eventNameController.dispose();
    super.dispose();
  }

  void _handleReset() {
    logger.i('Reset button pressed. Dispatching ResetMetadataEvent.');
    context.read<MonthlyCalendarMetadataBloc>().add(ResetMetadataEvent());
  }

  void _handleSubmit() {
    logger.i('Submit button pressed. Dispatching SaveMetadataEvent.');
    context.read<MonthlyCalendarMetadataBloc>().add(SaveMetadataEvent());
  }

  @override
  Widget build(BuildContext context) {
    logger.i('Building MonthlyCalendarScreen UI...');

    return MultiBlocListener(
      listeners: [
        // Listener for MonthlyCalendarMetadataBloc
        BlocListener<MonthlyCalendarMetadataBloc, MonthlyCalendarMetadataState>(
          listener: (context, state) {
            if (state is MonthlyCalendarSaveSuccessState ||
                state is MonthlyCalendarResetSuccessState) {
              logger.i('Save or Reset succeeded. Navigating to monthlyCalendar...');
              Navigator.pushReplacementNamed(context, AppRoutes.monthlyCalendar);
            }
          },
        ),
        // Listener for MonthlyCalendarImagesBloc
        BlocListener<MonthlyCalendarImagesBloc, MonthlyCalendarImagesState>(
          listener: (context, state) {
            if (state is MonthlyCalendarNavigationSuccessState) {
              logger.i('Navigation successful. Navigating to monthly calendar...');
              Navigator.pushReplacementNamed(context, AppRoutes.monthlyCalendar);
            }
          },
        ),
      ],
      child: BlocBuilder<CrossAxisCountCubit, int?>(
        builder: (context, crossAxisCount) {
          if (crossAxisCount == null) {
            logger.w('CrossAxisCountCubit state is null. Showing OutfitProgressIndicator.');
            return const Center(child: OutfitProgressIndicator());
          }

          logger.i('CrossAxisCountCubit state: $crossAxisCount.');

          // A scrollable Column
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              // Let the column wrap content
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ----- TOP SECTION: Row with metadata & reset/submit -----
                BlocBuilder<MonthlyCalendarMetadataBloc, MonthlyCalendarMetadataState>(
                  builder: (context, state) {
                    if (state is MonthlyCalendarLoadedState) {
                      logger.i('MonthlyCalendarMetadataBloc loaded with metadata.');
                      final metadata = state.metadataList.first;

                      // Sync controller text with metadata
                      if (eventNameController.text != metadata.eventName) {
                        final cursorPosition = eventNameController.selection;
                        eventNameController.value = eventNameController.value.copyWith(
                          text: metadata.eventName,
                          selection: cursorPosition,
                        );
                      }

                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left side: Metadata
                          Expanded(
                            child: MonthlyCalendarMetadata(
                              metadata: metadata,
                              eventNameController: eventNameController,
                              theme: Theme.of(context),
                              onEventNameChanged: (name) {
                                logger.d('Event name changed to: $name');
                                context
                                    .read<MonthlyCalendarMetadataBloc>()
                                    .add(UpdateSelectedMetadataEvent(metadata.copyWith(eventName: name)));
                              },
                              onFeedbackChanged: (feedback) {
                                logger.d('Feedback changed to: $feedback');
                                context
                                    .read<MonthlyCalendarMetadataBloc>()
                                    .add(UpdateSelectedMetadataEvent(metadata.copyWith(feedback: feedback)));
                              },
                              onCalendarSelectableChanged: (isSelectable) {
                                logger.d('Calendar selectable changed to: $isSelectable');
                                context
                                    .read<MonthlyCalendarMetadataBloc>()
                                    .add(UpdateSelectedMetadataEvent(metadata.copyWith(isCalendarSelectable: isSelectable)));
                              },
                              onOutfitActiveChanged: (isOutfitActive) {
                                logger.d('Outfit active state changed to: $isOutfitActive');
                                context
                                    .read<MonthlyCalendarMetadataBloc>()
                                    .add(UpdateSelectedMetadataEvent(metadata.copyWith(isOutfitActive: isOutfitActive)));
                              },
                            ),
                          ),
                          const SizedBox(width: 5),
                          // Right side: Reset/Submit
                          ResetAndSubmitWidget(
                            onReset: _handleReset,
                            onSubmit: _handleSubmit,
                          ),
                        ],
                      );
                    }

                    logger.w('MetadataBloc state not loaded yet. Showing loading indicator.');
                    return const Center(child: OutfitProgressIndicator());
                  },
                ),

                const SizedBox(height: 16),

                // ----- BOTTOM SECTION: Calendar -----
                BlocBuilder<MonthlyCalendarImagesBloc, MonthlyCalendarImagesState>(
                  builder: (context, state) {
                    if (state is MonthlyCalendarImagesLoaded) {
                      logger.i('MonthlyCalendarImagesBloc loaded with images.');

                      // Chevron visibility
                      final hasPreviousOutfits = state.hasPreviousOutfits;
                      final hasNextOutfits = state.hasNextOutfits;
                      final isCalendarSelectable = state.isCalendarSelectable;

                      final focusedDay = DateTime.parse(state.focusedDate);
                      final firstDay = DateTime.parse(state.startDate);
                      final lastDay = DateTime.parse(state.endDate);

                      logger.i(
                        'Loaded calendar data: '
                            'FocusedDay: $focusedDay, '
                            'FirstDay: $firstDay, '
                            'LastDay: $lastDay, '
                            'isCalendarSelectable: $isCalendarSelectable,'
                            'Calendar Data Count: ${state.calendarData.length}',
                      );

                      return Column(
                        children: [
                          // Chevron Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Left Chevron
                              if (hasPreviousOutfits)
                                IconButton(
                                  icon: Icon(
                                    Icons.chevron_left,
                                    color: Theme.of(context).iconTheme.color, // Use theme's icon color
                                  ),
                                  iconSize: Theme.of(context).iconTheme.size, // Use theme's icon size or default
                                  onPressed: () {
                                    context
                                        .read<MonthlyCalendarImagesBloc>()
                                        .add(NavigateCalendarEvent(direction: 'backward'));
                                  },
                                )
                              else
                                SizedBox(
                                  width: Theme.of(context).iconTheme.size ?? 48, // Placeholder for alignment
                                ),

                              // Right Chevron
                              if (hasNextOutfits)
                                IconButton(
                                  icon: Icon(
                                    Icons.chevron_right,
                                    color: Theme.of(context).iconTheme.color, // Use theme's icon color
                                  ),
                                  iconSize: Theme.of(context).iconTheme.size, // Use theme's icon size or default
                                  onPressed: () {
                                    context
                                        .read<MonthlyCalendarImagesBloc>()
                                        .add(NavigateCalendarEvent(direction: 'forward'));
                                  },
                                )
                              else
                                SizedBox(
                                  width: Theme.of(context).iconTheme.size ?? 48, // Placeholder for alignment
                                ),
                            ],
                          ),

                          // Calendar Widget
                          ImageCalendarWidget(
                            calendarData: state.calendarData,
                            focusedDay: focusedDay,
                            firstDay: firstDay,
                            lastDay: lastDay,
                            isCalendarSelectable: isCalendarSelectable,
                            crossAxisCount: crossAxisCount,
                          ),
                        ],
                      );
                    } else if (state is NoReviewedOutfitState) {
                      logger.w('No reviewed outfits found.');
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          S.of(context).noReviewedOutfitMessage, // Localized string for "review your first outfit"
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      );
                    } else if (state is NoFilteredReviewedOutfitState) {
                      logger.w('No reviewed outfits found for the current filter.');
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          S.of(context).noFilteredOutfitMessage, // Localized string for "change your filters"
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    logger.w('MonthlyCalendarImagesBloc state not loaded. Showing loading indicator.');
                    return const Center(child: OutfitProgressIndicator());
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
