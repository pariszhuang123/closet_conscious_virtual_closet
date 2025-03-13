import 'package:flutter/material.dart';
import '../../../../core/data/type_data.dart';
import '../../../../generated/l10n.dart';
import '../../../core/data/models/closet_item_detailed.dart';
import '../../../../core/widgets/form/custom_text_form.dart';
import '../../../../core/widgets/layout/icon_selection/icon_selection_field.dart';

class EditItemMetadata extends StatelessWidget {
  final ClosetItemDetailed currentItem;
  final TextEditingController itemNameController;
  final TextEditingController amountSpentController;
  final bool isChanged;
  final Function(String) onNameChanged;
  final Function(String) onAmountSpentChanged;
  final Function(String) onItemTypeChanged;
  final Function(String) onOccasionChanged;
  final Function(String) onSeasonChanged;
  final Function(String) onShoeTypeChanged;
  final Function(String) onAccessoryTypeChanged;
  final Function(String) onClothingTypeChanged;
  final Function(String) onClothingLayerChanged;
  final Function(String) onColourChanged;
  final Function(String) onColourVariationChanged;
  final ThemeData theme;
  final Map<String, String> validationErrors; // New prop for validation errors

  const EditItemMetadata({
    super.key,
    required this.currentItem,
    required this.itemNameController,
    required this.amountSpentController,
    required this.isChanged,
    required this.onNameChanged,
    required this.onAmountSpentChanged,
    required this.onItemTypeChanged,
    required this.onOccasionChanged,
    required this.onSeasonChanged,
    required this.onShoeTypeChanged,
    required this.onAccessoryTypeChanged,
    required this.onClothingTypeChanged,
    required this.onClothingLayerChanged,
    required this.onColourChanged,
    required this.onColourVariationChanged,
    required this.theme,
    required this.validationErrors, // Initialize in constructor
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Item Name Field
        CustomTextFormField(
          controller: itemNameController,
          labelText: S.of(context).item_name,
          hintText: S.of(context).ItemNameHint,
          labelStyle: theme.textTheme.bodyMedium,
          focusedBorderColor: theme.colorScheme.primary,
          errorText: validationErrors['item_name'],
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).pleaseEnterItemName;
            }
            return null; // No error if validation passes
          },
          onChanged: onNameChanged,
        ),
        const SizedBox(height: 12),

        // Amount Spent Field
        CustomTextFormField(
          controller: amountSpentController,
          labelText: S.of(context).amountSpentLabel,
          hintText: S.of(context).enterAmountSpentHint,
          labelStyle: theme.textTheme.bodyMedium,
          focusedBorderColor: theme.colorScheme.primary,
          errorText: validationErrors['amount_spent'],
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).enterAmountSpentHint;
            }
            final parsedValue = double.tryParse(value);
            if (parsedValue == null || parsedValue < 0) {
              return S.of(context).please_enter_valid_amount;
            }
            return null; // No error if validation passes
          },
          onChanged: onAmountSpentChanged,
        ),
        const SizedBox(height: 12),


        // Item Type Selection
        IconSelectionField(
          label: S.of(context).selectItemType,
          options: TypeDataList.itemGeneralTypes(context),
          selected: currentItem.itemType,
          onChanged: onItemTypeChanged,
          // Optionally, you could pass errorText: validationErrors['item_type']
        ),

        // Occasion Selection
        IconSelectionField(
          label: S.of(context).selectOccasion,
          options: TypeDataList.occasions(context),
          selected: currentItem.occasion,
          onChanged: onOccasionChanged,
        ),

        // Season Selection
        IconSelectionField(
          label: S.of(context).selectSeason,
          options: TypeDataList.seasons(context),
          selected: currentItem.season,
          onChanged: onSeasonChanged,
        ),

        // Shoe Type Selection (for shoes)
        if (currentItem.itemType.contains('shoes'))
          IconSelectionField(
            label: S.of(context).selectShoeType,
            options: TypeDataList.shoeTypes(context),
            selected: currentItem.shoesType ?? [],
            onChanged: onShoeTypeChanged,
            errorText: validationErrors['shoes_type'],
          ),

        // Accessory Type Selection (for accessories)
        if (currentItem.itemType.contains('accessory'))
          IconSelectionField(
            label: S.of(context).selectAccessoryType,
            options: TypeDataList.accessoryTypes(context),
            selected: currentItem.accessoryType != null &&
                currentItem.accessoryType!.isNotEmpty
                ? [currentItem.accessoryType!.first]
                : [],
            onChanged: onAccessoryTypeChanged,
            errorText: validationErrors['accessory_type'],
          ),
        // Clothing Type Selection (for clothing)
        if (currentItem.itemType.contains('clothing'))
          IconSelectionField(
            label: S.of(context).selectClothingType,
            options: TypeDataList.clothingTypes(context),
            selected: currentItem.clothingType != null &&
                currentItem.clothingType!.isNotEmpty
                ? [currentItem.clothingType!.first]
                : [],
            onChanged: onClothingTypeChanged,
            errorText: validationErrors['clothing_type'],
          ),

        // Clothing Layer Selection (for clothing)
        if (currentItem.itemType.contains('clothing'))
          IconSelectionField(
            label: S.of(context).selectClothingLayer,
            options: TypeDataList.clothingLayers(context),
            selected: currentItem.clothingLayer != null &&
                currentItem.clothingLayer!.isNotEmpty
                ? [currentItem.clothingLayer!.first]
                : [],
            onChanged: onClothingLayerChanged,
            errorText: validationErrors['clothing_layer'],
          ),

        // Colour Selection
        IconSelectionField(
          label: S.of(context).selectColour,
          options: TypeDataList.colour(context),
          selected: currentItem.colour.isNotEmpty ? [currentItem.colour.first] : [],
          onChanged: onColourChanged,
        ),

        // Colour Variation Selection (if colour is not black or white)
        if (!currentItem.colour.contains('black') &&
            !currentItem.colour.contains('white'))
          IconSelectionField(
            label: S.of(context).selectColourVariation,
            options: TypeDataList.colourVariations(context),
            selected: currentItem.colourVariations != null &&
                currentItem.colourVariations!.isNotEmpty
                ? [currentItem.colourVariations!.first]
                : [],
            onChanged: onColourVariationChanged,
            errorText: validationErrors['colour_variations'],
          ),
      ],
    );
  }
}
