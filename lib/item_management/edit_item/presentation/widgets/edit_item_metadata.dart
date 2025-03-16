import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/data/type_data.dart';
import '../../../../generated/l10n.dart';
import '../../../core/data/models/closet_item_detailed.dart';
import '../../../../core/widgets/form/custom_text_form.dart';
import '../../../../core/widgets/layout/icon_selection/icon_selection_field.dart';
import '../bloc/edit_item_bloc.dart';

class EditItemMetadata extends StatelessWidget {
  final ClosetItemDetailed currentItem;
  final TextEditingController itemNameController;
  final TextEditingController amountSpentController;
  final ThemeData theme;
  final Map<String, String> validationErrors; // New prop for validation errors
  final VoidCallback onMetadataChanged; // ✅ Callback to set _isChanged = true
  final FocusNode amountSpentFocusNode;

  const EditItemMetadata({
    super.key,
    required this.currentItem,
    required this.itemNameController,
    required this.amountSpentController,
    required this.amountSpentFocusNode,  // <-- Add this
    required this.theme,
    required this.validationErrors, // Initialize in constructor
    required this.onMetadataChanged, // ✅ Ensure _isChanged is updated in parent
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ─── ITEM NAME FIELD ───
        CustomTextFormField(
          controller: itemNameController,
          labelText: S.of(context).item_name,
          hintText: S.of(context).ItemNameHint,
          labelStyle: theme.textTheme.bodyMedium,
          focusedBorderColor: theme.colorScheme.primary,
          errorText: validationErrors['item_name'],
          onChanged: (value) {
            onMetadataChanged(); // ✅ Update _isChanged in parent
            context.read<EditItemBloc>().add(
              MetadataChangedEvent(updatedItem: currentItem.copyWith(name: value)),
            );
          },
        ),
        const SizedBox(height: 12),

        // ─── AMOUNT SPENT FIELD ───
        CustomTextFormField(
          controller: amountSpentController,
          focusNode: amountSpentFocusNode, // pass the FocusNode here
          labelText: S.of(context).amountSpentLabel,
          hintText: S.of(context).enterAmountSpentHint,
          labelStyle: theme.textTheme.bodyMedium,
          focusedBorderColor: theme.colorScheme.primary,
          errorText: validationErrors['amount_spent'],
          keyboardType: TextInputType.number,
          onChanged: (value) {
            onMetadataChanged(); // ✅ Update _isChanged in parent
            // ✅ Allow backspacing by handling empty input
            if (value.isEmpty) {
              return; // Let the field stay empty
            }

            double? parsedAmount = double.tryParse(value);
            if (parsedAmount != null) {
              context.read<EditItemBloc>().add(
                MetadataChangedEvent(updatedItem: currentItem.copyWith(amountSpent: parsedAmount)),
              );
            }
          },
        ),
        const SizedBox(height: 12),

        // ─── ITEM TYPE SELECTION ───
        IconSelectionField(
          label: S.of(context).selectItemType,
          options: TypeDataList.itemGeneralTypes(context),
          selected: currentItem.itemType,
          onChanged: (value) {
            onMetadataChanged();
            context.read<EditItemBloc>().add(
              MetadataChangedEvent(updatedItem: currentItem.copyWith(itemType: [value])),
            );
          },
          errorText: validationErrors['item_type'], // Pass the error message here
        ),

        // ─── OCCASION SELECTION ───
        IconSelectionField(
          label: S.of(context).selectOccasion,
          options: TypeDataList.occasions(context),
          selected: currentItem.occasion,
          onChanged: (value) {
            onMetadataChanged();
            context.read<EditItemBloc>().add(
              MetadataChangedEvent(updatedItem: currentItem.copyWith(occasion: [value])),
            );
          },
          errorText: validationErrors['occasion'], // Pass the error message here
        ),

        // ─── SEASON SELECTION ───
        IconSelectionField(
          label: S.of(context).selectSeason,
          options: TypeDataList.seasons(context),
          selected: currentItem.season,
          onChanged: (value) {
            onMetadataChanged();
            context.read<EditItemBloc>().add(
              MetadataChangedEvent(updatedItem: currentItem.copyWith(season: [value])),
            );
          },
          errorText: validationErrors['season'], // Pass the error message here
        ),

        // ─── SHOE TYPE (IF APPLICABLE) ───
        if (currentItem.itemType.contains('shoes'))
          IconSelectionField(
            label: S.of(context).selectShoeType,
            options: TypeDataList.shoeTypes(context),
            selected: currentItem.shoesType ?? [],
            onChanged: (value) {
              onMetadataChanged();
              context.read<EditItemBloc>().add(
                MetadataChangedEvent(updatedItem: currentItem.copyWith(shoesType: [value])),
              );
            },
            errorText: validationErrors['shoes_type'],
          ),

        // ─── ACCESSORY TYPE (IF APPLICABLE) ───
        if (currentItem.itemType.contains('accessory'))
          IconSelectionField(
            label: S.of(context).selectAccessoryType,
            options: TypeDataList.accessoryTypes(context),
            selected: currentItem.accessoryType ?? [],
            onChanged: (value) {
              onMetadataChanged();
              context.read<EditItemBloc>().add(
                MetadataChangedEvent(updatedItem: currentItem.copyWith(accessoryType: [value])),
              );
            },
            errorText: validationErrors['accessory_type'],
          ),

        // ─── CLOTHING TYPE (IF APPLICABLE) ───
        if (currentItem.itemType.contains('clothing'))
          IconSelectionField(
            label: S.of(context).selectClothingType,
            options: TypeDataList.clothingTypes(context),
            selected: currentItem.clothingType ?? [],
            onChanged: (value) {
              onMetadataChanged();
              context.read<EditItemBloc>().add(
                MetadataChangedEvent(updatedItem: currentItem.copyWith(clothingType: [value])),
              );
            },
            errorText: validationErrors['clothing_type'],
          ),

        // ─── CLOTHING LAYER (IF APPLICABLE) ───
        if (currentItem.itemType.contains('clothing'))
          IconSelectionField(
            label: S.of(context).selectClothingLayer,
            options: TypeDataList.clothingLayers(context),
            selected: currentItem.clothingLayer ?? [],
            onChanged: (value) {
              onMetadataChanged();
              context.read<EditItemBloc>().add(
                MetadataChangedEvent(updatedItem: currentItem.copyWith(clothingLayer: [value])),
              );
            },
            errorText: validationErrors['clothing_layer'],
          ),

        // ─── COLOUR SELECTION ───
        IconSelectionField(
          label: S.of(context).selectColour,
          options: TypeDataList.colour(context),
          selected: currentItem.colour.isNotEmpty ? [currentItem.colour.first] : [],
          onChanged: (value) {
            onMetadataChanged();
            context.read<EditItemBloc>().add(
              MetadataChangedEvent(updatedItem: currentItem.copyWith(colour: [value])),
            );
          },
          errorText: validationErrors['colour'], // Pass the error message here
        ),

        // ─── COLOUR VARIATION (IF NOT BLACK OR WHITE) ───
        if (!currentItem.colour.contains('black') && !currentItem.colour.contains('white'))
          IconSelectionField(
            label: S.of(context).selectColourVariation,
            options: TypeDataList.colourVariations(context),
            selected: currentItem.colourVariations ?? [],
            onChanged: (value) {
              onMetadataChanged();
              context.read<EditItemBloc>().add(
                MetadataChangedEvent(updatedItem: currentItem.copyWith(colourVariations: [value])),
              );
            },
            errorText: validationErrors['colour_variations'],
          ),
      ],
    );
  }
}
