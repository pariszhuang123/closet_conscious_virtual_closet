import 'package:flutter/material.dart';
import '../../../../core/data/type_data.dart';
import '../../../../generated/l10n.dart';
import '../../../core/data/models/closet_item_detailed.dart';
import '../../../../core/widgets/layout/icon_row_builder.dart';

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
        TextFormField(
          controller: itemNameController,
          decoration: InputDecoration(
            labelText: S.of(context).item_name,
            labelStyle: theme.textTheme.bodyMedium,
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2.0,
              ),
            ),
            errorText: validationErrors['item_name'], // Display error
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).pleaseEnterItemName;
            }
            return null;
          },
          onChanged: onNameChanged,
        ),
        const SizedBox(height: 12),

        // Amount Spent Field
        TextFormField(
          controller: amountSpentController,
          decoration: InputDecoration(
            labelText: S.of(context).amountSpentLabel,
            hintText: S.of(context).enterAmountSpentHint,
            labelStyle: theme.textTheme.bodyMedium,
            border: InputBorder.none,
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 2.0,
              ),
            ),
            errorText: validationErrors['amount_spent'], // Display error
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return S.of(context).enterAmountSpentHint;
            }
            final parsedValue = double.tryParse(value);
            if (parsedValue == null || parsedValue < 0) {
              return S.of(context).please_enter_valid_amount;
            }
            return null;
          },
          onChanged: onAmountSpentChanged,
        ),
        const SizedBox(height: 12),

        // Item Type Selection
        Text(S.of(context).selectItemType, style: theme.textTheme.bodyMedium),
        ...buildIconRows(
          TypeDataList.itemGeneralTypes(context),
          currentItem.itemType, // Pass first item if available
              (dataKey) => onItemTypeChanged(dataKey),
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
              (dataKey) => onOccasionChanged(dataKey),
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
              (dataKey) => onSeasonChanged(dataKey),
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
                (dataKey) => onShoeTypeChanged(dataKey),
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
                (dataKey) => onAccessoryTypeChanged(dataKey),
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
                (dataKey) => onClothingTypeChanged(dataKey),
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
                (dataKey) => onClothingLayerChanged(dataKey),
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
          TypeDataList.colors(context),
          currentItem.colour.isNotEmpty ? [currentItem.colour.first] : [], // Pass first item if available
              (dataKey) => onColourChanged(dataKey),
          context,
          true,
          false,
        ),
        const SizedBox(height: 12),

        // Colour Variation Selection (if colour is not black or white)
        if (!currentItem.colour.contains ('black') && !currentItem.colour.contains('white')) ...[
          Text(S.of(context).selectColourVariation, style: theme.textTheme.bodyMedium),
          ...buildIconRows(
            TypeDataList.colorVariations(context),
            currentItem.colourVariations != null && currentItem.colourVariations!.isNotEmpty ? [currentItem.colourVariations!.first] : [], // Pass the first item if available
                (dataKey) => onColourVariationChanged(dataKey),
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
