import 'package:flutter/material.dart';
import 'dart:io';

class ImageDisplayWidget extends StatelessWidget {
  final File? imageFile;

  const ImageDisplayWidget({super.key, this.imageFile});

  @override
  Widget build(BuildContext context) {
    return imageFile != null
        ? Image.file(
      imageFile!,
      height: 200,
      width: 200,
      fit: BoxFit.cover,
    )
        : const Text('No image selected.');
  }
}
