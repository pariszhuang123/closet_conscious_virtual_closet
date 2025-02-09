import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/monthly_calendar_metadata_bloc/monthly_calendar_metadata_bloc.dart';
import '../bloc/monthly_calendar_images_bloc/monthly_calendar_images_bloc.dart';
import '../../../core/presentation/bloc/calendar_navigation_bloc.dart';
import '../widgets/monthly_calendar_metadata.dart';
import '../widgets/image_calendar_widget.dart';
import '../widgets/monthly_feature_container.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/utilities/routes.dart';
import '../../../../../core/widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../../../core/paywall/data/feature_key.dart';

class MonthlyCalendarScreen extends StatefulWidget {
  final ThemeData theme;
  final List<String> selectedOutfitIds; // ✅ Add selected outfits

  const MonthlyCalendarScreen({
    super.key,
    required this.theme,
    this.selectedOutfitIds = const [], // ✅ Default to an empty list
  });

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
    logger.i('Initializing MonthlyCalendarScreen with selectedOutfitIds: ${widget.selectedOutfitIds}');
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

  void _handleCreateCloset() {
    final state = context.read<MonthlyCalendarImagesBloc>().state;

    if (state is MonthlyCalendarImagesLoaded && state.selectedOutfitIds.isNotEmpty) {
      logger.i('Creating closet with selected outfits: ${state.selectedOutfitIds}');

      context.read<MonthlyCalendarImagesBloc>().add(
        FetchActiveItems(selectedOutfitIds: state.selectedOutfitIds),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.i('Building MonthlyCalendarScreen UI...');

    return MultiBlocListener(
      listeners: [
        BlocListener<CalendarNavigationBloc, CalendarNavigationState>(
          listener: (context, state) {
            if (state is CalendarAccessDeniedState) {
              logger.w('Access denied: Navigating to payment page');
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.payment,
                arguments: {
                  'featureKey': FeatureKey.calendar,
                  'isFromMyCloset': false,
                  'previousRoute': AppRoutes.createOutfit,
                  'nextRoute': AppRoutes.monthlyCalendar,
                },
              );
            }
          },
        ),

        // Listener for MonthlyCalendarMetadataBloc
        BlocListener<MonthlyCalendarMetadataBloc, MonthlyCalendarMetadataState>(
          listener: (context, state) {
            logger.d('MetadataBloc emitted state: $state');
            if (state is MonthlyCalendarSaveSuccessState || state is MonthlyCalendarResetSuccessState) {
              logger.i('Save or Reset succeeded. Navigating to monthlyCalendar...');
              Navigator.pushReplacementNamed(context, AppRoutes.monthlyCalendar);
            }
          },
        ),
        // Listener for MonthlyCalendarImagesBloc
        BlocListener<MonthlyCalendarImagesBloc, MonthlyCalendarImagesState>(
          listener: (context, state) {
            if (state is MonthlyCalendarNavigationSuccessState) {
              logger.i('Navigation successful. Navigating to monthly calendar with selected outfits: ${state.selectedOutfitIds}');

              Navigator.pushReplacementNamed(
                context,
                AppRoutes.monthlyCalendar,
                arguments: {
                  'selectedOutfitIds': state.selectedOutfitIds, // Will always be a list
                },
              );
            }
            if (state is FocusedDateUpdatedState) {
              logger.i('Focused Date updated successfully. Navigating to daily calendar with outfitId: ${state.outfitId}');
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.dailyCalendar,
                arguments: {
                  'outfitId': state.outfitId, // ✅ Pass outfitId in navigation arguments
                },
              );
            }
            if (state is ActiveItemsFetched) {
              logger.i('Navigation successful. Navigating to create Closet...');

              // Ensure activeItemId is included in the navigation arguments
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.createMultiCloset,
                arguments: {
                  'selectedItemIds': state.activeItemIds, // Assuming activeItemIds is a List<String>
                },
              );
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
                          final state = context.read<MonthlyCalendarImagesBloc>().state;

                          // Ensure selectedOutfitIds is always a List<String>
                          if (state is MonthlyCalendarImagesLoaded) {
                            context.read<MonthlyCalendarImagesBloc>().add(
                              NavigateCalendarEvent(
                                direction: 'backward',
                                selectedOutfitIds: List<String>.from(state.selectedOutfitIds), // Ensure type safety
                              ),
                            );
                          }
                        },

                        onNextButtonPressed: () {
                          final state = context.read<MonthlyCalendarImagesBloc>().state;

                          if (state is MonthlyCalendarImagesLoaded) {
                            context.read<MonthlyCalendarImagesBloc>().add(
                              NavigateCalendarEvent(
                                direction: 'forward',
                                selectedOutfitIds: List<String>.from(state.selectedOutfitIds), // Ensure type safety
                              ),
                            );
                          }
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
                          } else if (state is NoReviewedOutfitState) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  S.of(context).noReviewedOutfitMessage,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            );
                          } else if (state is NoFilteredReviewedOutfitState) {
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  S.of(context).noFilteredOutfitMessage,
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
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
                  child: BlocBuilder<MonthlyCalendarImagesBloc, MonthlyCalendarImagesState>(
                    builder: (context, state) {
                      String buttonText = S.of(context).update;
                      VoidCallback? onPressed = _handleUpdate;

                      if (state is MonthlyCalendarImagesLoaded && state.selectedOutfitIds.isNotEmpty) {
                        buttonText = S.of(context).createCloset;
                        onPressed = _handleCreateCloset;
                      }

                      return ThemedElevatedButton(
                        onPressed: onPressed,
                        text: buttonText,
                      );
                    },
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
