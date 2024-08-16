import 'package:closet_conscious/core/data/type_data.dart';
import 'package:flutter/material.dart';
import '../../../../core/widgets/container/base_container.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/theme/themed_svg.dart';
import '../../../../generated/l10n.dart';

class SelfieDateShareContainer extends StatelessWidget {
  final String formattedDate;
  final VoidCallback onSelfieButtonPressed;
  final VoidCallback onShareButtonPressed;
  final ThemeData theme;

  const SelfieDateShareContainer({
    super.key,
    required this.formattedDate,
    required this.onSelfieButtonPressed,
    required this.onShareButtonPressed,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    final selfieData = TypeDataList.selfie(context);
    final shareData = TypeDataList.share(context);

    return BaseContainer(
      theme: theme,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          NavigationTypeButton(
            label: selfieData.getName(context),
            selectedLabel: '',
            onPressed: onSelfieButtonPressed,
            assetPath: selfieData.assetPath,
            isFromMyCloset: false,
            buttonType: ButtonType.primary,
            usePredefinedColor: false,
          ),
          Text(
            '${S.of(context).date}: $formattedDate',
            style: theme.textTheme.bodyMedium,
          ),
          NavigationTypeButton(
            label: shareData.getName(context),
            selectedLabel: '',
            onPressed: onShareButtonPressed,
            assetPath: shareData.assetPath,
            isFromMyCloset: false,
            buttonType: ButtonType.primary,
            usePredefinedColor: false,
          ),
        ],
      ),
    );
  }
}
