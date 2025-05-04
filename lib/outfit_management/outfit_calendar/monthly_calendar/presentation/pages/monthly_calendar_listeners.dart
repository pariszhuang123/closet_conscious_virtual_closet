import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/utilities/logger.dart';
import '../../../../../core/core_enums.dart';
import '../../../../../core/utilities/app_router.dart';

import '../bloc/monthly_calendar_metadata_bloc/monthly_calendar_metadata_bloc.dart';
import '../bloc/monthly_calendar_images_bloc/monthly_calendar_images_bloc.dart';
import '../../../core/presentation/bloc/calendar_navigation_bloc/calendar_navigation_bloc.dart';
import '../../../../core/presentation/bloc/outfit_selection_bloc/outfit_selection_bloc.dart';
import '../../../../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../../../item_management/multi_closet/core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';
import '../../../../../core/usage_analytics/core/presentation/bloc/focus_or_create_closet_bloc/focus_or_create_closet_bloc.dart';
import '../../../../../core/utilities/helper_functions/tutorial_helper.dart';
import '../../../../../core/utilities/helper_functions/navigate_once_helper.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';

class MonthlyCalendarListeners extends StatefulWidget {
  final Widget child;
  final bool isFromMyCloset;
  final List<String> selectedOutfitIds;
  final CustomLogger logger;

  const MonthlyCalendarListeners({
    super.key,
    required this.child,
    required this.isFromMyCloset,
    required this.selectedOutfitIds,
    required this.logger,
  });

  @override
  State<MonthlyCalendarListeners> createState() => _MonthlyCalendarListenersState();
}

  class _MonthlyCalendarListenersState extends State<MonthlyCalendarListeners> with NavigateOnceHelper {

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, state) {
            if (state is ShowTutorial) {
              widget.logger.i('Tutorial shown, navigating...');
              navigateOnce(() {
                context.goNamed(
                  AppRoutesName.tutorialVideoPopUp,
                  extra: {
                    'nextRoute': AppRoutesName.monthlyCalendar,
                    'tutorialInputKey': TutorialType.paidCalendar.value,
                    'isFromMyCloset': widget.isFromMyCloset,
                  },
                );
              });
            }
          },
        ),
        BlocListener<CalendarNavigationBloc, CalendarNavigationState>(
          listener: (context, state) {
            if (state is CalendarAccessState) {
              switch (state.accessStatus) {
                case AccessStatus.denied:
                  widget.logger.w('Access denied');
                  navigateOnce(() {
                    context.goNamed(
                      AppRoutesName.payment,
                      extra: {
                        'featureKey': FeatureKey.calendar,
                        'isFromMyCloset': widget.isFromMyCloset,
                        'previousRoute': AppRoutesName.createOutfit,
                        'nextRoute': AppRoutesName.monthlyCalendar,
                      },
                    );
                  });
                  break;
                case AccessStatus.trialPending:
                  widget.logger.i('Trial pending');
                  navigateOnce(() {
                    context.goNamed(
                      AppRoutesName.trialStarted,
                      extra: {
                        'selectedFeatureRoute': AppRoutesName.monthlyCalendar,
                        'isFromMyCloset': widget.isFromMyCloset,
                      },
                    );
                  });
                  break;
                case AccessStatus.granted:
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
                    if (widget.selectedOutfitIds.isNotEmpty) {
                      context.read<OutfitSelectionBloc>().add(
                        BulkToggleOutfitSelectionEvent(widget.selectedOutfitIds),
                      );
                    }
                    context.read<MonthlyCalendarMetadataBloc>().add(FetchMonthlyCalendarMetadataEvent());
                    context.read<MonthlyCalendarImagesBloc>().add(
                      FetchMonthlyCalendarImages(selectedOutfitIds: widget.selectedOutfitIds),
                    );
                    context.read<MultiClosetNavigationBloc>().add(CheckMultiClosetAccessEvent());
                    context.read<FocusOrCreateClosetBloc>().add(FetchFocusOrCreateCloset());
                  });
                  break;
                case AccessStatus.pending:
                case AccessStatus.error:
                  widget.logger.w('Calendar access: ${state.accessStatus}');
                  break;
              }
            }
          },
        ),
        BlocListener<MonthlyCalendarMetadataBloc, MonthlyCalendarMetadataState>(
          listener: (context, state) {
            if (state is MonthlyCalendarSaveSuccessState || state is MonthlyCalendarResetSuccessState) {
              widget.logger.i("Metadata saved/reset, refreshing screen");
              navigateOnce(() {
                context.goNamed(
                  AppRoutesName.monthlyCalendar,
                  extra: {'timestamp': DateTime.now().millisecondsSinceEpoch.toString()},
                );
              });
            }
          },
        ),
        BlocListener<MonthlyCalendarImagesBloc, MonthlyCalendarImagesState>(
          listener: (context, state) {
            if (state is MonthlyCalendarNavigationSuccessState) {
              navigateOnce(() {
                context.goNamed(
                  AppRoutesName.monthlyCalendar,
                  extra: {
                    'selectedOutfitIds': state.selectedOutfitIds,
                    'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
                  },
                );
              });
            } else if (state is FocusedDateUpdatedState) {
              navigateOnce(() {
                context.pushNamed(
                  AppRoutesName.dailyCalendar,
                  extra: {'outfitId': state.outfitId},
                );
              });
            }
          },
        ),
        BlocListener<OutfitSelectionBloc, OutfitSelectionState>(
          listener: (context, state) {
            if (state is ActiveItemsFetched) {
              navigateOnce(() {
                context.pushNamed(
                  AppRoutesName.createMultiCloset,
                  extra: {'selectedItemIds': state.activeItemIds},
                );
              });
            }
          },
        ),
        BlocListener<MultiClosetNavigationBloc, MultiClosetNavigationState>(
          listener: (context, state) {
            if (state is MultiClosetAccessState &&
                state.accessStatus == AccessStatus.granted) {
              context.read<FocusOrCreateClosetBloc>().add(FetchFocusOrCreateCloset());
            }
          },
        ),
      ],
      child: widget.child,
    );
  }
}
