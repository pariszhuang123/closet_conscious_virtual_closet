import 'package:closet_conscious/core/usage_analytics/core/presentation/bloc/focus_or_create_closet_bloc/focus_or_create_closet_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../widgets/container/base_container.dart';
import '../../../../../widgets/button/navigation_type_button.dart';
import '../../../../../core_enums.dart';
import '../../../../../data/type_data.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../../item_management/multi_closet/core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';

class SummaryItemAnalyticsFeatureContainer extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onFilterButtonPressed;
  final VoidCallback onArrangeButtonPressed;
  final VoidCallback onResetButtonPressed;
  final VoidCallback onSelectAllButtonPressed;
  final VoidCallback onFocusButtonPressed;
  final VoidCallback onCreateClosetButtonPressed;

  final CustomLogger logger = CustomLogger(
      'SummaryItemAnalyticsFeatureContainer');

  SummaryItemAnalyticsFeatureContainer({
    super.key,
    required this.theme,
    required this.onFilterButtonPressed,
    required this.onArrangeButtonPressed,
    required this.onResetButtonPressed,
    required this.onSelectAllButtonPressed,
    required this.onFocusButtonPressed,
    required this.onCreateClosetButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final focusOrCreateClosetState = context
        .watch<FocusOrCreateClosetBloc>()
        .state;
    final multiClosetNavBlocState = context
        .watch<MultiClosetNavigationBloc>()
        .state;

    bool isCalendarSelectable = false;
    bool multiClosetAccessGranted = false;


    if (focusOrCreateClosetState is FocusOrCreateClosetLoaded) {
      isCalendarSelectable = focusOrCreateClosetState.isCalendarSelectable;
    }

    if (multiClosetNavBlocState is MultiClosetAccessState &&
        multiClosetNavBlocState.accessStatus == AccessStatus.granted) {
      multiClosetAccessGranted = true;
    }
    logger.d(
        "FocusOrCreateClosetState: ${focusOrCreateClosetState.runtimeType}");
    logger.d("MultiClosetNavigationBloc State: ${multiClosetNavBlocState
        .runtimeType}");
    logger.d("isCalendarSelectable: $isCalendarSelectable");
    logger.d("MultiClosetAccessGrantedState: $multiClosetAccessGranted");

    final bool showFocus = multiClosetAccessGranted && isCalendarSelectable;
    final bool showCreateCloset = multiClosetAccessGranted &&
        !isCalendarSelectable;

    logger.d("showFocus: $showFocus, showCreateCloset: $showCreateCloset");

    return BaseContainer(
      theme: theme,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            NavigationTypeButton(
              label: TypeDataList.filter(context).getName(context),
              selectedLabel: '',
              onPressed: onFilterButtonPressed,
              assetPath: TypeDataList
                  .filter(context)
                  .assetPath,
              isFromMyCloset: true,
              buttonType: ButtonType.secondary,
              usePredefinedColor: false,
            ),
            NavigationTypeButton(
              label: TypeDataList.arrange(context).getName(context),
              selectedLabel: '',
              onPressed: onArrangeButtonPressed,
              assetPath: TypeDataList
                  .arrange(context)
                  .assetPath,
              isFromMyCloset: true,
              buttonType: ButtonType.secondary,
              usePredefinedColor: false,
            ),
            NavigationTypeButton(
              label: TypeDataList.reset(context).getName(context),
              selectedLabel: '',
              onPressed: onResetButtonPressed,
              assetPath: TypeDataList
                  .reset(context)
                  .assetPath,
              isFromMyCloset: true,
              buttonType: ButtonType.secondary,
              usePredefinedColor: false,
            ),
            NavigationTypeButton(
              label: TypeDataList.selectAll(context).getName(context),
              selectedLabel: '',
              onPressed: onSelectAllButtonPressed,
              assetPath: TypeDataList
                  .selectAll(context)
                  .assetPath,
              isFromMyCloset: true,
              buttonType: ButtonType.secondary,
              usePredefinedColor: false,
            ),
            if (showFocus)
              NavigationTypeButton(
                label: TypeDataList.focus(context).getName(context),
                selectedLabel: '',
                onPressed: onFocusButtonPressed,
                assetPath: TypeDataList
                    .focus(context)
                    .assetPath,
                isFromMyCloset: true,
                buttonType: ButtonType.secondary,
                usePredefinedColor: false,
              ),
            if (showCreateCloset)
              NavigationTypeButton(
                label: TypeDataList.createCloset(context).getName(context),
                selectedLabel: '',
                onPressed: onCreateClosetButtonPressed,
                assetPath: TypeDataList
                    .createCloset(context)
                    .assetPath,
                isFromMyCloset: true,
                buttonType: ButtonType.secondary,
                usePredefinedColor: false,
              ),
          ],
        ),
      ),
    );
  }
}