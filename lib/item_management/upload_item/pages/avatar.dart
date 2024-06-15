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
      width: 200,
      height: 200,
      child: imageUrl != null
          ? (Uri.tryParse(imageUrl!)?.isAbsolute == true
          ? Image.network(
        imageUrl!,
        fit: BoxFit.cover,
      )
          : Image.file(
        File(imageUrl!),
        fit: BoxFit.cover,
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
