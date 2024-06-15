import 'package:flutter/material.dart';
import 'dart:io';

class Avatar extends StatelessWidget {
  const Avatar({
    super.key,
    required this.imageUrl,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 175,
      height: 175,
      child: imageUrl != null
          ? (Uri.tryParse(imageUrl!)?.isAbsolute == true
          ? Image.network(
        imageUrl!,
        fit: BoxFit.contain,
      )
          : Image.file(
        File(imageUrl!),
        fit: BoxFit.contain,
      ))
          : Container(
        color: Colors.grey,
        child: const Center(
          child: Text('No Image'),
        ),
      ),
    );
  }
}
