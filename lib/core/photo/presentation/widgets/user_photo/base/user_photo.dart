import 'package:flutter/material.dart';

class UserPhoto extends StatelessWidget {
  final String imageUrl;

  const UserPhoto({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}
