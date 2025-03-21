import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/container/base_container.dart';
import '../../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../../core/core_enums.dart';
import '../../../../../core/data/type_data.dart';
import '../bloc/daily_calendar_bloc.dart';

class DailyFeatureContainer extends StatelessWidget {
  final ThemeData theme;
  final VoidCallback onCalendarButtonPressed;
  final VoidCallback onArrangeButtonPressed;
  final VoidCallback onPreviousButtonPressed;
  final VoidCallback onNextButtonPressed;
  final VoidCallback onCreateOutfitButtonPressed;

  const DailyFeatureContainer({
    super.key,
    required this.theme,
    required this.onCalendarButtonPressed,
    required this.onArrangeButtonPressed,
    required this.onPreviousButtonPressed,
    required this.onNextButtonPressed,
    required this.onCreateOutfitButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool showPrevious = context.select<DailyCalendarBloc, bool>(
          (bloc) {
        final state = bloc.state;
        return state is DailyCalendarLoaded && state.hasPreviousOutfits;
      },
    );

    final bool showNext = context.select<DailyCalendarBloc, bool>(
          (bloc) {
        final state = bloc.state;
        return state is DailyCalendarLoaded && state.hasNextOutfits;
      },
    );

    return BaseContainer(
      theme: theme,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Enables horizontal scrolling
        child: Row(
          children: [
            NavigationTypeButton(
              label: TypeDataList.calendar(context).getName(context),
              selectedLabel: '',
              onPressed: onCalendarButtonPressed,
              assetPath: TypeDataList.calendar(context).assetPath,
              isFromMyCloset: false,
              buttonType: ButtonType.secondary,
              usePredefinedColor: false,
            ),
            NavigationTypeButton(
              label: TypeDataList.arrange(context).getName(context),
              selectedLabel: '',
              onPressed: onArrangeButtonPressed,
              assetPath: TypeDataList.arrange(context).assetPath,
              isFromMyCloset: false,
              buttonType: ButtonType.secondary,
              usePredefinedColor: false,
            ),
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
            NavigationTypeButton(
              label: TypeDataList.createOutfit(context).getName(context),
              selectedLabel: '',
              onPressed: onCreateOutfitButtonPressed,
              assetPath: TypeDataList.createOutfit(context).assetPath,
              isFromMyCloset: false,
              buttonType: ButtonType.secondary,
              usePredefinedColor: false,
            ),
          ],
        ),
      ),
    );
  }
}
