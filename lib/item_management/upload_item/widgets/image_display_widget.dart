import 'package:flutter/material.dart';
import 'dart:io';

class ImageDisplayWidget extends StatelessWidget {
  const ImageDisplayWidget({
    super.key,
    this.imageUrl,
    this.file,
  });

  final String? imageUrl;
  final File? file;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0), // Adjust the radius as needed
      child: SizedBox(
        width: 200,
        height: 200,
        child: file != null
            ? Image.file(
          file!,
          fit: BoxFit.contain,
        )
            : imageUrl != null
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
      ),
    );
  }
}
