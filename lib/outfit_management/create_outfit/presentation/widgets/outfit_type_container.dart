import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/theme/themed_svg.dart';
import '../../../../core/data/type_data.dart';
import '../../../../core/widgets/container/base_container_no_format.dart';

class OutfitTypeContainer extends StatefulWidget {
  final ThemeData theme;
  final TypeData outfitClothingType;
  final TypeData outfitAccessoryType;
  final TypeData outfitShoesType;

  const OutfitTypeContainer({
    super.key,
    required this.theme,
    required this.outfitClothingType,
    required this.outfitAccessoryType,
    required this.outfitShoesType,
  });

  @override
  OutfitTypeContainerState createState() => OutfitTypeContainerState();
}

class OutfitTypeContainerState extends State<OutfitTypeContainer> {
  @override
  Widget build(BuildContext context) {
    final selectedCategory = context.select((CreateOutfitItemBloc bloc) => bloc.state.currentCategory);

    return BaseContainerNoFormat(
      theme: widget.theme,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavigationButton(widget.outfitClothingType, OutfitItemCategory.clothing, selectedCategory),
          _buildNavigationButton(widget.outfitAccessoryType, OutfitItemCategory.accessory, selectedCategory),
          _buildNavigationButton(widget.outfitShoesType, OutfitItemCategory.shoes, selectedCategory),
        ],
      ),
    );
  }

  Widget _buildNavigationButton(TypeData typeData, OutfitItemCategory category, OutfitItemCategory selectedCategory) {
    return NavigationTypeButton(
      label: typeData.getName(context),
      selectedLabel: typeData.getName(context),
      onPressed: () {
        context.read<CreateOutfitItemBloc>().add(SelectCategoryEvent(category));
      },
      assetPath: typeData.assetPath,
      isFromMyCloset: false,
      buttonType: ButtonType.primary,
      isSelected: selectedCategory == category,
      usePredefinedColor: false,
    );
  }
}
