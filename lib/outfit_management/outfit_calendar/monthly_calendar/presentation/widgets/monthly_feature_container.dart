import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/container/base_container.dart';
import '../../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../../core/core_enums.dart';
import '../../../../../core/data/type_data.dart';
import '../bloc/monthly_calendar_metadata_bloc/monthly_calendar_metadata_bloc.dart';
import '../bloc/monthly_calendar_images_bloc/monthly_calendar_images_bloc.dart';
import '../../../core/presentation/bloc/calendar_navigation_bloc.dart';
import '../../../../../core/utilities/logger.dart';

class MonthlyFeatureContainer extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onPreviousButtonPressed;
  final VoidCallback onNextButtonPressed;
  final VoidCallback onFocusButtonPressed;
  final VoidCallback onCreateClosetButtonPressed;
  final VoidCallback onResetButtonPressed;

  final CustomLogger logger = CustomLogger('MonthlyFeatureContainer');

  MonthlyFeatureContainer({
    super.key,
    required this.theme,
    required this.onPreviousButtonPressed,
    required this.onNextButtonPressed,
    required this.onFocusButtonPressed,
    required this.onCreateClosetButtonPressed,
    required this.onResetButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final metadataBlocState = context.watch<MonthlyCalendarMetadataBloc>().state;
    final calendarNavBlocState = context.select<CalendarNavigationBloc, CalendarNavigationState>((bloc) => bloc.state);

    bool isCalendarSelectable = false;
    bool multiClosetAccessGranted = false;

    if (metadataBlocState is MonthlyCalendarLoadedState && metadataBlocState.metadataList.isNotEmpty) {
      isCalendarSelectable = metadataBlocState.metadataList.first.isCalendarSelectable;
    }

    if (calendarNavBlocState is MultiClosetAccessGrantedState) {
      multiClosetAccessGranted = true;
    }

    logger.d("MetadataBloc State: ${metadataBlocState.runtimeType}");
    logger.d("CalendarNavigationBloc State: ${calendarNavBlocState.runtimeType}");
    logger.d("isCalendarSelectable: $isCalendarSelectable");
    logger.d("MultiClosetAccessGrantedState: $multiClosetAccessGranted");

    final bool showPrevious = context.select<MonthlyCalendarImagesBloc, bool>(
          (bloc) {
        final state = bloc.state;
        return state is MonthlyCalendarImagesLoaded && state.hasPreviousOutfits;
      },
    );

    final bool showNext = context.select<MonthlyCalendarImagesBloc, bool>(
          (bloc) {
        final state = bloc.state;
        return state is MonthlyCalendarImagesLoaded && state.hasNextOutfits;
      },
    );

    final bool showFocus = context.select<MonthlyCalendarMetadataBloc, bool>(
          (bloc) {
        final state = bloc.state;
        return state is MonthlyCalendarLoadedState &&
            state.metadataList.isNotEmpty &&
            state.metadataList.first.isCalendarSelectable;
      },
    );

    final bool showCreateCloset = (metadataBlocState is MonthlyCalendarLoadedState &&
        metadataBlocState.metadataList.isNotEmpty &&
        !metadataBlocState.metadataList.first.isCalendarSelectable) &&
        (calendarNavBlocState is MultiClosetAccessGrantedState);

    logger.d("showCreateCloset: $showCreateCloset");

    return BaseContainer(
      theme: theme,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: [
          if (showPrevious)
            NavigationTypeButton(
              label: TypeDataList.previous(context).getName(context),
              selectedLabel: '',
              onPressed: onPreviousButtonPressed,
              assetPath: TypeDataList.previous(context).assetPath,
              isFromMyCloset: false,
              buttonType: ButtonType.secondary,
              usePredefinedColor: false,
            ),
          if (showNext)
            NavigationTypeButton(
              label: TypeDataList.next(context).getName(context),
              selectedLabel: '',
              onPressed: onNextButtonPressed,
              assetPath: TypeDataList.next(context).assetPath,
              isFromMyCloset: false,
              buttonType: ButtonType.secondary,
              usePredefinedColor: false,
            ),
          if (showFocus)
            NavigationTypeButton(
              label: TypeDataList.focus(context).getName(context),
              selectedLabel: '',
              onPressed: onFocusButtonPressed,
              assetPath: TypeDataList.focus(context).assetPath,
              isFromMyCloset: false,
              buttonType: ButtonType.secondary,
              usePredefinedColor: false,
            ),
          if (showCreateCloset)
            NavigationTypeButton(
              label: TypeDataList.createCloset(context).getName(context),
              selectedLabel: '',
              onPressed: onCreateClosetButtonPressed,
              assetPath: TypeDataList.createCloset(context).assetPath,
              isFromMyCloset: false,
              buttonType: ButtonType.secondary,
              usePredefinedColor: false,
            ),
          NavigationTypeButton(
            label: TypeDataList.reset(context).getName(context),
            selectedLabel: '',
            onPressed: onResetButtonPressed,
            assetPath: TypeDataList.reset(context).assetPath,
            isFromMyCloset: false,
            buttonType: ButtonType.secondary,
            usePredefinedColor: false,
          ),
        ],
      ),
    );
  }
}
