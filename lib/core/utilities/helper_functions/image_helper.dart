import '../../core_enums.dart';
import '../../data/models/image_source.dart';

class ImageHelper {
  /// Returns the width and height for a given [ImageSize].
  static Map<String, int> getDimensions(ImageSize size) {
    switch (size) {
      case ImageSize.selfie:
        return {'width': 450, 'height': 450}; // Dimensions for selfies
      case ImageSize.monthlyCalendarImage:
        return {
          'width': 50,
          'height': 50
        }; // Dimensions for monthly calendar images
      case ImageSize.itemInteraction:
        return {
          'width': 275,
          'height': 275
        }; // Dimensions for item interaction screen
      case ImageSize.itemGrid3:
        return {
          'width': 175,
          'height': 175
        }; // Dimensions for item grid (3 per row)
      case ImageSize.itemGrid5:
        return {
          'width': 110,
          'height': 110
        }; // Dimensions for item grid (5 per row)
      case ImageSize.itemGrid7:
        return {'width': 75, 'height': 75}; // Grid 7 dimensions
      default:
        return {'width': 175, 'height': 175}; // Fallback dimensions
    }
  }

  /// Returns the border width for a given [ImageSize].
  static double getBorderWidth(ImageSize size) {
    switch (size) {
      case ImageSize.itemGrid3:
        return 2.5;
      case ImageSize.itemGrid5:
        return 2.0;
      case ImageSize.itemGrid7:
        return 1.5;
      default:
        return 2.5; // Fallback width
    }
  }

  static double getHeightForOutfitSize(OutfitSize outfitSize) {
    switch (outfitSize) {
      case OutfitSize.dailyCalendarOutfitImage:
        return 0.45;

      case OutfitSize.relatedOutfitImage:
        return 0.3;

      case OutfitSize.smallOutfitImage:
        return 0.2;

      default:
        return 0.3; // Fallback height
    }
  }

  static ImageSize getImageSize(int crossAxisCount) {
    switch (crossAxisCount) {
      case 3:
        return ImageSize.itemGrid3;
      case 5:
        return ImageSize.itemGrid5;
      case 7:
        return ImageSize.itemGrid7;
      default:
        return ImageSize.itemGrid3;
    }
  }
}

String? getImagePathFromSource(ImageSource source) {
  if (source.isRemote || source.isLocalFile) {
    return source.path;
  } else if (source.isAsset) {
    // AssetEntity doesn't have a direct path; this is for display logic
    return 'asset:${source.asset?.id ?? ''}';
  }
  return null;
}
