import 'package:closet_conscious/core/data/type_data.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/container/base_container_no_format.dart';
import '../../../../core/widgets/button/navigation_type_button.dart';
import '../../../../core/core_enums.dart';
import '../../../../generated/l10n.dart';

class SelfieDateShareContainer extends StatefulWidget {
  final String formattedDate;
  final VoidCallback onSelfieButtonPressed;
  final VoidCallback onShareButtonPressed;
  final ThemeData theme;
  final bool isSelfieTaken;

  const SelfieDateShareContainer({
    super.key,
    required this.formattedDate,
    required this.onSelfieButtonPressed,
    required this.onShareButtonPressed,
    required this.theme,
    required this.isSelfieTaken,
  });

  @override
  SelfieDateShareContainerState createState() => SelfieDateShareContainerState();
}

class SelfieDateShareContainerState extends State<SelfieDateShareContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Pulsing effect

    // Define the scaling transition animation
    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selfieData = TypeDataList.selfie(context);
    final shareData = TypeDataList.share(context);

    return BaseContainerNoFormat(
      theme: widget.theme,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        // Center the buttons and text
        children: [
          if (!widget.isSelfieTaken) // Conditionally render the selfie button
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: ScaleTransition(
                scale: _animation, // Apply the pulsing animation to the button
                child: NavigationTypeButton(
                  label: selfieData.getName(context),
                  selectedLabel: '',
                  onPressed: widget.onSelfieButtonPressed,
                  assetPath: selfieData.assetPath,
                  isFromMyCloset: false,
                  buttonType: ButtonType.primary,
                  usePredefinedColor: false,
                ),
              ),
            ),
          Text(
            '${S
                .of(context)
                .date}: ${widget.formattedDate}',
            style: widget.theme.textTheme.bodyMedium,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            // Add some gap on the left
            child: NavigationTypeButton(
              label: shareData.getName(context),
              selectedLabel: '',
              onPressed: widget.onShareButtonPressed,
              assetPath: shareData.assetPath,
              isFromMyCloset: false,
              buttonType: ButtonType.primary,
              usePredefinedColor: false,
            ),
          ),
        ],
      ),
    );
  }
}