import 'package:flutter/material.dart';

import '../../../../../data/type_data.dart';
import '../../../../../core_enums.dart';
import '../../../../../widgets/button/navigation_type_button.dart';

class FocusedItemAnalyticsAdditionalFeature extends StatelessWidget {
  final VoidCallback onSummaryItemAnalyticsButtonPressed;

  const FocusedItemAnalyticsAdditionalFeature({
    super.key,
    required this.onSummaryItemAnalyticsButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        NavigationTypeButton(
          label: TypeDataList.summaryItemAnalytics(context).getName(context),
          selectedLabel: '',
          onPressed: onSummaryItemAnalyticsButtonPressed,
          assetPath: TypeDataList.summaryItemAnalytics(context).assetPath,
          isFromMyCloset: true,
          buttonType: ButtonType.secondary,
          usePredefinedColor: false,
        ),
      ],
    );
  }
}
