import 'package:flutter/material.dart';
import '../../../../../core/data/type_data.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/widgets/layout/icon_selection/icon_selection_field.dart';

class OccasionSeasonSelector extends StatelessWidget {
  final String? selectedOccasion;
  final String? selectedSeason;
  final Function(String) onOccasionChanged;
  final Function(String) onSeasonChanged;

  const OccasionSeasonSelector({
    super.key,
    required this.selectedOccasion,
    required this.selectedSeason,
    required this.onOccasionChanged,
    required this.onSeasonChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconSelectionField(
          label: S.of(context).selectOccasion,
          options: TypeDataList.occasions(context),
          selected: selectedOccasion != null ? [selectedOccasion!] : [],
          onChanged: (val) => onOccasionChanged(val),
        ),
        const SizedBox(height: 12),
        IconSelectionField(
          label: S.of(context).selectSeason,
          options: TypeDataList.seasons(context),
          selected: selectedSeason != null ? [selectedSeason!] : [],
          onChanged: (val) => onSeasonChanged(val),
        ),
      ],
    );
  }
}
