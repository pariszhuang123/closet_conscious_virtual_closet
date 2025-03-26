import 'package:flutter/material.dart';

import '../../utilities/helper_functions/image_helper/image_helper.dart';
import '../../core_enums.dart';

BoxDecoration customBoxDecoration({
  required bool showBorder,
  required Color borderColor,
  required ImageSize imageSize, // Pass imageSize as a parameter
}) {
  double borderWidth = ImageHelper.getBorderWidth(imageSize); // Assign inside function

  return BoxDecoration(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(12),
    border: showBorder ? Border.all(color: borderColor, width: borderWidth) : null,
  );
}
