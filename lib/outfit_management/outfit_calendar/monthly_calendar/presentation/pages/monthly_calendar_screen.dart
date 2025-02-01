import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/monthly_calendar_metadata_bloc/monthly_calendar_metadata_bloc.dart';
import '../bloc/monthly_calendar_images_bloc/monthly_calendar_images_bloc.dart';
import '../widgets/monthly_calendar_metadata.dart';
import '../widgets/image_calendar_widget.dart';
import '../widgets/monthly_feature_container.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/utilities/routes.dart';
import '../../../../../core/widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/button/themed_elevated_button.dart';

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

  void _handleUpdate() {
    logger.i('Update button pressed. Dispatching SaveMetadataEvent.');
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
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MonthlyFeatureContainer(
                        theme: Theme.of(context),
                        onPreviousButtonPressed: () {
                          context.read<MonthlyCalendarImagesBloc>().add(NavigateCalendarEvent(direction: 'backward'));
                        },
                        onNextButtonPressed: () {
                          context.read<MonthlyCalendarImagesBloc>().add(NavigateCalendarEvent(direction: 'forward'));
                        },
                        onFocusButtonPressed: () {
                          final state = context.read<MonthlyCalendarMetadataBloc>().state;
                          if (state is MonthlyCalendarLoadedState) {
                            final metadata = state.metadataList.first;

                            final updatedMetadata = metadata.copyWith(isCalendarSelectable: false);

                            logger.i('Updating and saving metadata: isCalendarSelectable = false');

                            context.read<MonthlyCalendarMetadataBloc>().add(
                              UpdateSelectedMetadataEvent(updatedMetadata),
                            );

                            // Immediately trigger save
                            context.read<MonthlyCalendarMetadataBloc>().add(SaveMetadataEvent());
                          }
                        },
                        onCreateClosetButtonPressed: () {
                          final state = context.read<MonthlyCalendarMetadataBloc>().state;
                          if (state is MonthlyCalendarLoadedState) {
                            final metadata = state.metadataList.first;

                            final updatedMetadata = metadata.copyWith(isCalendarSelectable: true);

                            logger.i('Updating and saving metadata: isCalendarSelectable = true');

                            context.read<MonthlyCalendarMetadataBloc>().add(
                              UpdateSelectedMetadataEvent(updatedMetadata),
                            );

                            // Immediately trigger save
                            context.read<MonthlyCalendarMetadataBloc>().add(SaveMetadataEvent());
                          }
                        },
                        onResetButtonPressed: _handleReset,
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<MonthlyCalendarMetadataBloc, MonthlyCalendarMetadataState>(
                        builder: (context, state) {
                          if (state is MonthlyCalendarLoadedState) {
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
                                context.read<MonthlyCalendarMetadataBloc>().add(
                                  UpdateSelectedMetadataEvent(metadata.copyWith(eventName: name)),
                                );
                              },
                              onFeedbackChanged: (feedback) {
                                context.read<MonthlyCalendarMetadataBloc>().add(
                                  UpdateSelectedMetadataEvent(metadata.copyWith(feedback: feedback)),
                                );
                              },
                              onOutfitActiveChanged: (isOutfitActive) {
                                context.read<MonthlyCalendarMetadataBloc>().add(
                                  UpdateSelectedMetadataEvent(metadata.copyWith(isOutfitActive: isOutfitActive)),
                                );
                              },
                            );
                          }
                          return const Center(child: OutfitProgressIndicator());
                        },
                      ),
                      const SizedBox(height: 16),
                      BlocBuilder<MonthlyCalendarImagesBloc, MonthlyCalendarImagesState>(
                        builder: (context, state) {
                          if (state is MonthlyCalendarImagesLoaded) {
                            return ImageCalendarWidget(
                              calendarData: state.calendarData,
                              focusedDay: DateTime.parse(state.focusedDate),
                              firstDay: DateTime.parse(state.startDate),
                              lastDay: DateTime.parse(state.endDate),
                              isCalendarSelectable: state.isCalendarSelectable,
                              crossAxisCount: crossAxisCount,
                            );
                          }
                          return const Center(child: OutfitProgressIndicator());
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ThemedElevatedButton(
                    onPressed: _handleUpdate,
                    text: S.of(context).update,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
