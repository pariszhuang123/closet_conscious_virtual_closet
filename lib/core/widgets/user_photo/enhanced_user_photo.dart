import 'package:flutter/material.dart';
import 'base/user_photo.dart';

class EnhancedUserPhoto extends StatelessWidget {
  final String imageUrl;
  final bool isSelected;
  final VoidCallback onPressed;
  final String itemName;
  final String itemId;

  const EnhancedUserPhoto({
    super.key,
    required this.imageUrl,
    required this.isSelected,
    required this.onPressed,
    required this.itemName,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final double width = constraints.maxWidth;
          final double height = constraints.maxHeight;
          final Border border = isSelected
              ? Border.all(color: Theme.of(context).primaryColor, width: 2.0)
              : Border.all(color: Colors.transparent, width: 0.0);

          return Column(
            children: [
              Container(
                width: width,
                height: height - 20, // Adjust height for the text below
                decoration: BoxDecoration(
                  border: border,
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: UserPhoto(imageUrl: imageUrl),
              ),
              const SizedBox(height: 8.0),
              Text(
                itemName,
                style: Theme.of(context).textTheme.labelSmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          );
        },
      ),
    );
  }
}
