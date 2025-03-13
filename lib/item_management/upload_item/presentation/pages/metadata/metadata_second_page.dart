import 'package:flutter/material.dart';
import '../../../../../core/data/type_data.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/layout/icon_selection/icon_row_builder.dart';

class MetadataSecondPage extends StatelessWidget {
  final String? selectedItemType;
  final String? selectedSpecificType;
  final String? selectedSeason;
  final String? selectedClothingLayer;
  final Function(String) onSpecificTypeChanged;
  final Function(String) onSeasonChanged;
  final Function(String) onClothingLayerChanged;
  final ThemeData myClosetTheme;

  const MetadataSecondPage({
    super.key,
    required this.selectedItemType,
    required this.selectedSpecificType,
    required this.selectedSeason,
    required this.selectedClothingLayer,
    required this.onSpecificTypeChanged,
    required this.onSeasonChanged,
    required this.onClothingLayerChanged,
    required this.myClosetTheme,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              S.of(context).selectSeason,
              style: myClosetTheme.textTheme.bodyMedium,
            ),
            SafeArea(
              child: Column(
                children: buildIconRows(
                  TypeDataList.seasons(context),
                  selectedSeason != null ? [selectedSeason!] : [],  // Handle nullable String
                      (selectedKeys) => onSeasonChanged(selectedKeys.first), // Wrap in lambda
                  context,
                  true,
                  false,
                ),
              ),
            ),
            const SizedBox(height: 12),
            if (selectedItemType == 'shoes') ...[
              Text(
                S.of(context).selectShoeType,
                style: myClosetTheme.textTheme.bodyMedium,
              ),
              SafeArea(
                child: Column(
                  children: buildIconRows(
                    TypeDataList.shoeTypes(context),
                    selectedSpecificType != null ? [selectedSpecificType!] : [],  // Handle nullable String
                        (selectedKeys) => onSpecificTypeChanged(selectedKeys.first), // Wrap in lambda
                    context,
                    true,
                    false,
                  ),
                ),
              ),
            ],
            if (selectedItemType == 'accessory') ...[
              Text(
                S.of(context).selectAccessoryType,
                style: myClosetTheme.textTheme.bodyMedium,
              ),
              SafeArea(
                child: Column(
                  children: buildIconRows(
                    TypeDataList.accessoryTypes(context),
                    selectedSpecificType != null ? [selectedSpecificType!] : [],  // Handle nullable String
                        (selectedKeys) => onSpecificTypeChanged(selectedKeys.first), // Wrap in lambda
                    context,
                    true,
                    false,
                  ),
                ),
              ),
            ],
            if (selectedItemType == 'clothing') ...[
              Text(
                S.of(context).selectClothingType,
                style: myClosetTheme.textTheme.bodyMedium,
              ),
              SafeArea(
                child: Column(
                  children: buildIconRows(
                    TypeDataList.clothingTypes(context),
                    selectedSpecificType != null ? [selectedSpecificType!] : [],  // Handle nullable String
                        (selectedKeys) => onSpecificTypeChanged(selectedKeys.first), // Wrap in lambda
                    context,
                    true,
                    false,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                S.of(context).selectClothingLayer,
                style: myClosetTheme.textTheme.bodyMedium,
              ),
              SafeArea(
                child: Column(
                  children: buildIconRows(
                    TypeDataList.clothingLayers(context),
                    selectedClothingLayer != null ? [selectedClothingLayer!] : [],  // Handle nullable String
                        (selectedKeys) => onClothingLayerChanged(selectedKeys.first), // Wrap in lambda
                    context,
                    true,
                    false,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
