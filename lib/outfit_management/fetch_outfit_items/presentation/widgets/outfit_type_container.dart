import 'package:flutter/material.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/core_enums.dart';
import '../../../core/outfit_enums.dart';
import '../../../../core/data/type_data.dart';
import '../../../../core/widgets/container/base_container_no_format.dart';

class OutfitTypeContainer extends StatefulWidget {
  final ThemeData theme;
  final TypeData outfitClothingType;
  final TypeData outfitAccessoryType;
  final TypeData outfitShoesType;
  final void Function(OutfitItemCategory category) onCategorySelected;

  const OutfitTypeContainer({
    super.key,
    required this.theme,
    required this.outfitClothingType,
    required this.outfitAccessoryType,
    required this.outfitShoesType,
    required this.onCategorySelected,
  });

  @override
  OutfitTypeContainerState createState() => OutfitTypeContainerState();
}

class OutfitTypeContainerState extends State<OutfitTypeContainer> {
  OutfitItemCategory selectedCategory = OutfitItemCategory.clothing;

  @override
  Widget build(BuildContext context) {
    return BaseContainerNoFormat(
      theme: widget.theme,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavigationButton(widget.outfitClothingType, OutfitItemCategory.clothing),
          _buildNavigationButton(widget.outfitAccessoryType, OutfitItemCategory.accessory),
          _buildNavigationButton(widget.outfitShoesType, OutfitItemCategory.shoes),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(TypeData typeData, OutfitItemCategory category) {
    final isSelected = selectedCategory == category;

    return NavigationTypeButton(
      label: typeData.getName(context),
      selectedLabel: typeData.getName(context),
      onPressed: () {
        setState(() => selectedCategory = category);
        widget.onCategorySelected(category);
      },
      assetPath: typeData.assetPath,
      isFromMyCloset: false,
      buttonType: ButtonType.primary,
      isSelected: isSelected,
      usePredefinedColor: false,
    );
  }
}
