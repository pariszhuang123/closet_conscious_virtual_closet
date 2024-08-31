import 'package:flutter/material.dart';
import '../../../../core/data/type_data.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/widgets/icon_row_builder.dart';

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
                  TypeDataList.colors(context),
                  selectedColour,
                  onColourChanged,
                  context,
                  true,
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
                    TypeDataList.colorVariations(context),
                    selectedColourVariation,
                    onColourVariationChanged,
                    context,
                    true,
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
