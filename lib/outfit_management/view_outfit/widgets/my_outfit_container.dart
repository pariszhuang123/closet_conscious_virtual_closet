import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/widgets/base_container.dart';
import '../../../core/widgets/button/navigation_type_button.dart';
import '../../../core/widgets/button/number_type_button.dart';
import '../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../outfit_management/create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import '../../../core/theme/themed_svg.dart';
import '../../../core/widgets/build_filtered_item_row.dart';

class MyOutfitContainer extends StatelessWidget {
  final ThemeData theme;
  final dynamic filterData;
  final dynamic calendarData;
  final dynamic outfitsUploadData;
  final int outfitCount;
  final VoidCallback onFilterButtonPressed;
  final VoidCallback onCalendarButtonPressed;
  final VoidCallback onClothesPressed;
  final VoidCallback onAccessoriesPressed;
  final VoidCallback onShoesPressed;
  final dynamic outfitClothingType;
  final dynamic outfitAccessoryType;
  final dynamic outfitShoesType;

  const MyOutfitContainer({
    super.key,
    required this.theme,
    required this.filterData,
    required this.calendarData,
    required this.outfitsUploadData,
    required this.outfitCount,
    required this.onFilterButtonPressed,
    required this.onCalendarButtonPressed,
    required this.onClothesPressed,
    required this.onAccessoriesPressed,
    required this.onShoesPressed,
    required this.outfitClothingType,
    required this.outfitAccessoryType,
    required this.outfitShoesType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BaseContainer(
          theme: theme,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  NavigationTypeButton(
                    label: filterData.getName(context),
                    selectedLabel: '',
                    onPressed: onFilterButtonPressed,
                    imagePath: filterData.imagePath ?? '',
                    isAsset: true,
                    isFromMyCloset: false,
                    buttonType: ButtonType.secondary,
                  ),
                  NavigationTypeButton(
                    label: calendarData.getName(context),
                    selectedLabel: '',
                    onPressed: onCalendarButtonPressed,
                    imagePath: calendarData.imagePath ?? '',
                    isAsset: true,
                    isFromMyCloset: false,
                    buttonType: ButtonType.secondary,
                  ),
                ],
              ),
              Tooltip(
                message: outfitsUploadData.getName(context),
                child: NumberTypeButton(
                  count: outfitCount,
                  imagePath: outfitsUploadData.imagePath ?? '',
                  isAsset: true,
                  isFromMyCloset: false,
                  isHorizontal: false,
                  buttonType: ButtonType.secondary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NavigationTypeButton(
              label: outfitClothingType.getName(context),
              selectedLabel: '',
              onPressed: onClothesPressed,
              imagePath: outfitClothingType.imagePath!,
              isAsset: false,
              isFromMyCloset: false,
              buttonType: ButtonType.primary,
            ),
            NavigationTypeButton(
              label: outfitAccessoryType.getName(context),
              selectedLabel: '',
              onPressed: onAccessoriesPressed,
              imagePath: outfitAccessoryType.imagePath!,
              isAsset: false,
              isFromMyCloset: false,
              buttonType: ButtonType.primary,
            ),
            NavigationTypeButton(
              label: outfitShoesType.getName(context),
              selectedLabel: '',
              onPressed: onShoesPressed,
              imagePath: outfitShoesType.imagePath!,
              isAsset: false,
              isFromMyCloset: false,
              buttonType: ButtonType.primary,
            ),
          ],
        ),
        const SizedBox(height: 16),
        BlocBuilder<CreateOutfitItemBloc, CreateOutfitItemState>(
          builder: (context, state) {
            if (state.items.isEmpty) {
              return const Center(child: Text('Please select the category above'));
            }

            final selectedItems = state.selectedItemIds[state.currentCategory] ?? [];
            return Column(
              children: buildFilteredItemRows(
                state.items.cast<ClosetItemMinimal>(),
                selectedItems,
                    (itemId) => context.read<CreateOutfitItemBloc>().add(SelectItemEvent(state.currentCategory!, itemId)),
                context,
              ),
            );
          },
        ),
      ],
    );
  }
}
