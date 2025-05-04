import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/monthly_calendar_metadata_bloc/monthly_calendar_metadata_bloc.dart';
import '../bloc/monthly_calendar_images_bloc/monthly_calendar_images_bloc.dart';
import '../../../core/presentation/bloc/calendar_navigation_bloc/calendar_navigation_bloc.dart';
import '../../../../core/presentation/bloc/outfit_selection_bloc/outfit_selection_bloc.dart';
import '../widgets/monthly_calendar_metadata.dart';
import '../widgets/image_calendar_widget.dart';
import '../widgets/monthly_feature_container.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/core_enums.dart';
import '../../../../../core/widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../../../core/theme/my_closet_theme.dart';
import '../../../../../core/theme/my_outfit_theme.dart';
import '../../../../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import 'monthly_calendar_listeners.dart';

class MonthlyCalendarScreen extends StatefulWidget {
  final bool isFromMyCloset;
  final List<String> selectedOutfitIds; // ✅ Add selected outfit

  const MonthlyCalendarScreen({
    super.key,
    required this.isFromMyCloset,
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<CalendarNavigationBloc>().add(CheckCalendarAccessEvent());
      context.read<TutorialBloc>().add(
        const CheckTutorialStatus(TutorialType.paidCalendar),
      );
    });

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

  void _handleToggleOutfitSelection(String outfitId) {
    final outfitSelectionBloc = context.read<OutfitSelectionBloc>();

    outfitSelectionBloc.add(ToggleOutfitSelectionEvent(outfitId));

  }

  void _handleUpdate() {
    logger.i('Update button pressed. Dispatching SaveMetadataEvent.');
    context.read<MonthlyCalendarMetadataBloc>().add(SaveMetadataEvent());
  }

  void _handleCreateCloset() {
    final outfitSelectionState = context.read<OutfitSelectionBloc>().state;

    if (outfitSelectionState is OutfitSelectionUpdated && outfitSelectionState.selectedOutfitIds.isNotEmpty) {
      logger.i('Fetching active items for selected outfits: ${outfitSelectionState.selectedOutfitIds}');
      context.read<OutfitSelectionBloc>().add(FetchActiveItemsEvent(outfitSelectionState.selectedOutfitIds));
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.i('Building MonthlyCalendarScreen UI...');

    ThemeData theme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme;
    logger.d('Theme selected: ${widget.isFromMyCloset ? "myClosetTheme" : "myOutfitTheme"}');

    return BlocBuilder<CalendarNavigationBloc, CalendarNavigationState>(
        builder: (context, calendarAccessState) {
          if (calendarAccessState is CalendarAccessState &&
              calendarAccessState.accessStatus == AccessStatus.pending) {
            logger.i(
                'Calendar access is pending. Showing OutfitProgressIndicator.');
            return const Center(child: OutfitProgressIndicator());
          }

          return Theme(
            data: theme, // ✅ Apply theme globally
            child: MonthlyCalendarListeners(
              isFromMyCloset: widget.isFromMyCloset,
              selectedOutfitIds: widget.selectedOutfitIds,
              logger: logger,
              child: BlocBuilder<CrossAxisCountCubit, int?>(
                builder: (context, crossAxisCount) {
                  if (crossAxisCount == null) {
                    logger.w(
                        'CrossAxisCountCubit state is null. Showing OutfitProgressIndicator.');
                    return const Center(child: OutfitProgressIndicator());
                  }

                  logger.i('CrossAxisCountCubit state: $crossAxisCount.');

                  // A scrollable Column
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16,
                              vertical: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              MonthlyFeatureContainer(
                                theme: Theme.of(context),

                                onPreviousButtonPressed: () {
                                  final state = context
                                      .read<MonthlyCalendarImagesBloc>()
                                      .state;
                                  final selectedOutfitIds = context
                                      .read<OutfitSelectionBloc>()
                                      .state is OutfitSelectionUpdated
                                      ? (context
                                      .read<OutfitSelectionBloc>()
                                      .state as OutfitSelectionUpdated)
                                      .selectedOutfitIds
                                      : <String>[];

                                  if (state is MonthlyCalendarImagesLoaded) {
                                    context.read<MonthlyCalendarImagesBloc>()
                                        .add(
                                      NavigateCalendarEvent(
                                        direction: 'backward',
                                        selectedOutfitIds: selectedOutfitIds, // Use latest outfit selections
                                      ),
                                    );
                                  }
                                },

                                onNextButtonPressed: () {
                                  final state = context
                                      .read<MonthlyCalendarImagesBloc>()
                                      .state;
                                  final selectedOutfitIds = context
                                      .read<OutfitSelectionBloc>()
                                      .state is OutfitSelectionUpdated
                                      ? (context
                                      .read<OutfitSelectionBloc>()
                                      .state as OutfitSelectionUpdated)
                                      .selectedOutfitIds
                                      : <String>[];

                                  if (state is MonthlyCalendarImagesLoaded) {
                                    context.read<MonthlyCalendarImagesBloc>()
                                        .add(
                                      NavigateCalendarEvent(
                                        direction: 'forward',
                                        selectedOutfitIds: selectedOutfitIds, // Use latest outfit selections
                                      ),
                                    );
                                  }
                                },

                                onFocusButtonPressed: () {
                                  final state = context
                                      .read<MonthlyCalendarMetadataBloc>()
                                      .state;
                                  if (state is MonthlyCalendarLoadedState) {
                                    final metadata = state.metadataList.first;

                                    final updatedMetadata = metadata.copyWith(
                                        isCalendarSelectable: true);

                                    logger.i(
                                        'Updating and saving metadata: isCalendarSelectable = true');

                                    context.read<MonthlyCalendarMetadataBloc>()
                                        .add(
                                      UpdateSelectedMetadataEvent(
                                          updatedMetadata),
                                    );

                                    // Immediately trigger save
                                    context.read<MonthlyCalendarMetadataBloc>()
                                        .add(SaveMetadataEvent());
                                  }
                                },
                                onCreateClosetButtonPressed: () {
                                  final state = context
                                      .read<MonthlyCalendarMetadataBloc>()
                                      .state;
                                  if (state is MonthlyCalendarLoadedState) {
                                    final metadata = state.metadataList.first;

                                    final updatedMetadata = metadata.copyWith(
                                        isCalendarSelectable: false);

                                    logger.i(
                                        'Updating and saving metadata: isCalendarSelectable = false');

                                    context.read<MonthlyCalendarMetadataBloc>()
                                        .add(
                                      UpdateSelectedMetadataEvent(
                                          updatedMetadata),
                                    );

                                    // Immediately trigger save
                                    context.read<MonthlyCalendarMetadataBloc>()
                                        .add(SaveMetadataEvent());
                                  }
                                },
                                onResetButtonPressed: _handleReset,
                              ),
                              const SizedBox(height: 16),
                              BlocBuilder<
                                  MonthlyCalendarMetadataBloc,
                                  MonthlyCalendarMetadataState>(
                                builder: (context, state) {
                                  if (state is MonthlyCalendarLoadingState ||
                                      state is MonthlyCalendarInitialState) {
                                    return const OutfitProgressIndicator();
                                  }
                                  if (state is MonthlyCalendarLoadedState) {
                                    final metadata = state.metadataList.first;
                                    if (eventNameController.text !=
                                        metadata.eventName) {
                                      final cursorPosition = eventNameController
                                          .selection;
                                      eventNameController.value =
                                          eventNameController.value.copyWith(
                                            text: metadata.eventName,
                                            selection: cursorPosition,
                                          );
                                    }

                                    return MonthlyCalendarMetadata(
                                      metadata: metadata,
                                      eventNameController: eventNameController,
                                      theme: Theme.of(context),
                                      onEventNameChanged: (name) {
                                        context.read<
                                            MonthlyCalendarMetadataBloc>().add(
                                          UpdateSelectedMetadataEvent(
                                              metadata.copyWith(
                                                  eventName: name)),
                                        );
                                      },
                                      onFeedbackChanged: (feedback) {
                                        context.read<
                                            MonthlyCalendarMetadataBloc>().add(
                                          UpdateSelectedMetadataEvent(
                                              metadata.copyWith(
                                                  feedback: feedback)),
                                        );
                                      },
                                      onOutfitActiveChanged: (isOutfitActive) {
                                        context.read<
                                            MonthlyCalendarMetadataBloc>().add(
                                          UpdateSelectedMetadataEvent(
                                              metadata.copyWith(
                                                  isOutfitActive: isOutfitActive)),
                                        );
                                      },
                                    );
                                  }
                                  return const Center(
                                      child: OutfitProgressIndicator());
                                },
                              ),
                              const SizedBox(height: 8),
                              BlocBuilder<
                                  MonthlyCalendarImagesBloc,
                                  MonthlyCalendarImagesState>(
                                builder: (context, state) {
                                  if (state is MonthlyCalendarImagesLoading ||
                                      state is MonthlyCalendarImagesInitial) {
                                    return const OutfitProgressIndicator();
                                  }
                                  if (state is MonthlyCalendarImagesLoaded) {
                                    return BlocBuilder<
                                        OutfitSelectionBloc,
                                        OutfitSelectionState>(
                                      builder: (context, outfitState) {
                                        List<
                                            String> selectedOutfits = outfitState is OutfitSelectionUpdated
                                            ? outfitState.selectedOutfitIds
                                            : [];

                                        return ImageCalendarWidget(
                                          calendarData: state.calendarData,
                                          selectedOutfitIds: selectedOutfits,
                                          focusedDay: DateTime.parse(
                                              state.focusedDate),
                                          firstDay: DateTime.parse(
                                              state.startDate),
                                          lastDay: DateTime.parse(
                                              state.endDate),
                                          isCalendarSelectable: state
                                              .isCalendarSelectable,
                                          crossAxisCount: crossAxisCount,
                                          onToggleSelection: _handleToggleOutfitSelection,
                                        );
                                      },
                                    );
                                  }
                                  // 🛑 Handle cases where there are no reviewed outfits
                                  else if (state is NoReviewedOutfitState) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          S
                                              .of(context)
                                              .noReviewedOutfitMessage,
                                          textAlign: TextAlign.center,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                    );
                                  }
                                  // 🛑 Handle cases where filtering removes all outfits
                                  else
                                  if (state is NoFilteredReviewedOutfitState) {
                                    return Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(
                                          S
                                              .of(context)
                                              .noFilteredOutfitMessage,
                                          textAlign: TextAlign.center,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ),
                                    );
                                  }
                                  return const Center(
                                      child: OutfitProgressIndicator());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: BlocBuilder<
                              OutfitSelectionBloc,
                              OutfitSelectionState>(
                            builder: (context, state) {
                              return ThemedElevatedButton(
                                onPressed: (state is OutfitSelectionUpdated &&
                                    state.selectedOutfitIds.isNotEmpty)
                                    ? _handleCreateCloset
                                    : _handleUpdate,
                                text: (state is OutfitSelectionUpdated &&
                                    state.selectedOutfitIds.isNotEmpty)
                                    ? S
                                    .of(context)
                                    .createCloset
                                    : S
                                    .of(context)
                                    .update,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          );
        });
  }
}
