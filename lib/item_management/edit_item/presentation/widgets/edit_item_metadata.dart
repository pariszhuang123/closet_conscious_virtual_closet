import 'package:flutter/material.dart';
import '../../../../core/data/type_data.dart';
import '../../../../generated/l10n.dart';
import '../../../core/data/models/closet_item_detailed.dart';
import '../../../../core/widgets/layout/icon_row_builder.dart';
import '../../../../core/widgets/form/custom_text_form.dart';

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
        Text(S.of(context).selectItemType, style: theme.textTheme.bodyMedium),
        ...buildIconRows(
          TypeDataList.itemGeneralTypes(context),
          currentItem.itemType, // Pass first item if available
              (selectedKeys) => onItemTypeChanged(selectedKeys.first),
          context,
          true,
          false,
        ),
        // If interdependent fields require validation, consider handling them via Bloc
        // or pass validation errors as props
        const SizedBox(height: 12),

        // Occasion Selection
        Text(S.of(context).selectOccasion, style: theme.textTheme.bodyMedium),
        ...buildIconRows(
          TypeDataList.occasions(context),
          currentItem.occasion, // Pass first item if available
              (selectedKeys) => onOccasionChanged(selectedKeys.first),
          context,
          true,
          false,
        ),
        const SizedBox(height: 12),

        // Season Selection
        Text(S.of(context).selectSeason, style: theme.textTheme.bodyMedium),
        ...buildIconRows(
          TypeDataList.seasons(context),
          currentItem.season, // Pass first item if available
              (selectedKeys) => onSeasonChanged(selectedKeys.first),
          context,
          true,
          false,
        ),
        const SizedBox(height: 12),

        // Shoe Type Selection (for shoes)
        if (currentItem.itemType.contains ('shoes')) ...[
          Text(S.of(context).selectShoeType, style: theme.textTheme.bodyMedium),
          ...buildIconRows(
            TypeDataList.shoeTypes(context),
            currentItem.shoesType ?? [], // Pass the first item if available
                (selectedKeys) => onShoeTypeChanged(selectedKeys.first),
            context,
            true,
            false,
          ),
          // Display validation error if any
          if (validationErrors['shoes_type'] != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                validationErrors['shoes_type']!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
        const SizedBox(height: 12),

        // Accessory Type Selection (for accessories)
        if (currentItem.itemType.contains ('accessory')) ...[
          Text(S.of(context).selectAccessoryType, style: theme.textTheme.bodyMedium),
          ...buildIconRows(
            TypeDataList.accessoryTypes(context),
            currentItem.accessoryType != null && currentItem.accessoryType!.isNotEmpty ? [currentItem.accessoryType!.first] : [], // Pass the first item if available
                (selectedKeys) => onAccessoryTypeChanged(selectedKeys.first),
            context,
            true,
            false,
          ),
          // Display validation error if any
          if (validationErrors['accessory_type'] != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                validationErrors['accessory_type']!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
        const SizedBox(height: 12),

        // Clothing Type and Layer Selection (for clothing)
        if (currentItem.itemType.contains ('clothing')) ...[
          // Clothing Type Selection
          Text(S.of(context).selectClothingType, style: theme.textTheme.bodyMedium),
          ...buildIconRows(
            TypeDataList.clothingTypes(context),
            currentItem.clothingType != null && currentItem.clothingType!.isNotEmpty ? [currentItem.clothingType!.first] : [], // Pass the first item if available
                (selectedKeys) => onClothingTypeChanged(selectedKeys.first),
            context,
            true,
            false,
          ),
          // Display validation error if any
          if (validationErrors['clothing_type'] != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                validationErrors['clothing_type']!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
          const SizedBox(height: 12),

          // Clothing Layer Selection
          Text(S.of(context).selectClothingLayer, style: theme.textTheme.bodyMedium),
          ...buildIconRows(
            TypeDataList.clothingLayers(context),
            currentItem.clothingLayer != null && currentItem.clothingLayer!.isNotEmpty ? [currentItem.clothingLayer!.first] : [], // Pass the first item if available
                (selectedKeys) => onClothingLayerChanged(selectedKeys.first),
            context,
            true,
            false,
          ),
          // Display validation error if any
          if (validationErrors['clothing_layer'] != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                validationErrors['clothing_layer']!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
        const SizedBox(height: 12),

        // Colour Selection
        Text(S.of(context).selectColour, style: theme.textTheme.bodyMedium),
        ...buildIconRows(
          TypeDataList.colour(context),
          currentItem.colour.isNotEmpty ? [currentItem.colour.first] : [], // Pass first item if available
              (selectedKeys) => onColourChanged(selectedKeys.first),
          context,
          true,
          false,
        ),
        const SizedBox(height: 12),

        // Colour Variation Selection (if colour is not black or white)
        if (!currentItem.colour.contains ('black') && !currentItem.colour.contains('white')) ...[
          Text(S.of(context).selectColourVariation, style: theme.textTheme.bodyMedium),
          ...buildIconRows(
            TypeDataList.colourVariations(context),
            currentItem.colourVariations != null && currentItem.colourVariations!.isNotEmpty ? [currentItem.colourVariations!.first] : [], // Pass the first item if available
                (selectedKeys) => onColourVariationChanged(selectedKeys.first),
            context,
            true,
            false,
          ),
          // Display validation error if any
          if (validationErrors['colour_variations'] != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                validationErrors['colour_variations']!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
        const SizedBox(height: 12),
      ],
    );
  }
}
