import 'package:flutter/material.dart';
import '../../../../core/data/type_data.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/widgets/layout/icon_row_builder.dart';

class MetadataThirdPage extends StatelessWidget {
  final String? selectedColour;
  final String? selectedColourVariation;
  final Function(String) onColourChanged;
  final Function(String) onColourVariationChanged;
  final ThemeData myClosetTheme;

  const MetadataThirdPage({
    super.key,
    required this.selectedColour,
    required this.selectedColourVariation,
    required this.onColourChanged,
    required this.onColourVariationChanged,
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
              S.of(context).selectColour,
              style: myClosetTheme.textTheme.bodyMedium,
            ),
            SafeArea(
              child: Column(
                children: buildIconRows(
                  TypeDataList.colour(context),
                  selectedColour != null ? [selectedColour!] : [],  // Wrap in a list and handle null
                      (selectedKeys) => onColourChanged(selectedKeys.first), // Wrap in lambda
                  context,
                  true,
                  false,
                ),
              ),
            ),
            if (selectedColour != 'black' && selectedColour != 'white' && selectedColour != null) ...[
              const SizedBox(height: 12),
              Text(
                S.of(context).selectColourVariation,
                style: myClosetTheme.textTheme.bodyMedium,
              ),
              SafeArea(
                child: Column(
                  children: buildIconRows(
                    TypeDataList.colourVariations(context),
                    selectedColourVariation != null ? [selectedColourVariation!] : [],  // Wrap in a list and handle null
                        (selectedKeys) => onColourVariationChanged(selectedKeys.first), // Wrap in lambda
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
