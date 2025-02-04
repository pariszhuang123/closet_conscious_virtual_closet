import 'package:flutter/material.dart';

class PageIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final ThemeData theme;

  const PageIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: (currentIndex == index) ? 12.0 : 8.0,
          height: (currentIndex == index) ? 12.0 : 8.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (currentIndex == index)
                ? theme.colorScheme.primary
                : theme.colorScheme.secondary,
          ),
        );
      }),
    );
  }
}
