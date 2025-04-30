import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../../core/data/type_data.dart';
import '../../../../../core/core_enums.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';

class MultiClosetNavigationButtons extends StatelessWidget {
  final TypeData createClosetTypeData;
  final TypeData allClosetsTypeData;
  final bool isFromMyCloset;
  final CustomLogger logger;

  const MultiClosetNavigationButtons({
    super.key,
    required this.createClosetTypeData,
    required this.allClosetsTypeData,
    required this.isFromMyCloset,
    required this.logger,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        NavigationTypeButton(
          label: createClosetTypeData.getName(context),
          selectedLabel: '',
          onPressed: () {
            logger.i('Add Closet Button Pressed');
            context
                .read<MultiClosetNavigationBloc>()
                .add(NavigateToCreateMultiCloset());
          },
          assetPath: createClosetTypeData.assetPath,
          isFromMyCloset: isFromMyCloset,
          usePredefinedColor: createClosetTypeData.usePredefinedColor,
          buttonType: ButtonType.primary,
          isSelected: false,
        ),
        NavigationTypeButton(
          label: allClosetsTypeData.getName(context),
          selectedLabel: '',
          onPressed: () {
            logger.i('All Closet Button Pressed');
            context
                .read<MultiClosetNavigationBloc>()
                .add(NavigateToEditAllMultiCloset());
          },
          assetPath: allClosetsTypeData.assetPath,
          isFromMyCloset: isFromMyCloset,
          usePredefinedColor: allClosetsTypeData.usePredefinedColor,
          buttonType: ButtonType.primary,
          isSelected: false,
        ),
      ],
    );
  }
}
