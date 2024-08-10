import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../create_outfit/presentation/bloc/create_outfit_item_bloc.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/theme/themed_svg.dart';
import '../../../../core/data/type_data.dart';

class OutfitTypeContainer extends StatefulWidget {
  final TypeData outfitClothingType;
  final TypeData outfitAccessoryType;
  final TypeData outfitShoesType;

  const OutfitTypeContainer({
    super.key,
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

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            NavigationTypeButton(
              label: widget.outfitClothingType.getName(context),
              selectedLabel: widget.outfitClothingType.getName(context),
              onPressed: () {
                context.read<CreateOutfitItemBloc>().add(const SelectCategoryEvent(OutfitItemCategory.clothing));
              },
              assetPath: widget.outfitClothingType.assetPath!,
              isFromMyCloset: false,
              buttonType: ButtonType.primary,
              isSelected: selectedCategory == OutfitItemCategory.clothing,
              usePredefinedColor: false,
            ),
            NavigationTypeButton(
              label: widget.outfitAccessoryType.getName(context),
              selectedLabel: widget.outfitAccessoryType.getName(context),
              onPressed: () {
                context.read<CreateOutfitItemBloc>().add(const SelectCategoryEvent(OutfitItemCategory.accessory));
              },
              assetPath: widget.outfitAccessoryType.assetPath!,
              isFromMyCloset: false,
              buttonType: ButtonType.primary,
              isSelected: selectedCategory == OutfitItemCategory.accessory,
              usePredefinedColor: false,
            ),
            NavigationTypeButton(
              label: widget.outfitShoesType.getName(context),
              selectedLabel: widget.outfitShoesType.getName(context),
              onPressed: () {
                context.read<CreateOutfitItemBloc>().add(const SelectCategoryEvent(OutfitItemCategory.shoes));
              },
              assetPath: widget.outfitShoesType.assetPath!,
              isFromMyCloset: false,
              buttonType: ButtonType.primary,
              isSelected: selectedCategory == OutfitItemCategory.shoes,
              usePredefinedColor: false,
            ),
          ],
        ),
      ],
    );
  }
}

class OutfitTypeData {
  final String name;
  final String imagePath;

  OutfitTypeData({
    required this.name,
    required this.imagePath,
  });

  String getName(BuildContext context) {
    return name;
  }
}
