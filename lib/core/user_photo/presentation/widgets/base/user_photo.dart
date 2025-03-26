import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';

import '../../../../utilities/helper_functions/image_helper/image_resize_helper.dart';
import '../../../../data/services/core_fetch_services.dart';
import '../../../../core_enums.dart';
import '../../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../utilities/helper_functions/image_helper/image_helper.dart';

class UserPhoto extends StatelessWidget {
  final String? imageUrl;       // for remote
  final String? localImagePath; // for local
  final AssetEntity? asset;     // for photo library
  final ImageSize imageSize;

  final CoreFetchService fetchService = CoreFetchService();

  static final Map<String, Uint8List> _assetCache = {};
  static void clearCache() {
    _assetCache.clear();
  }

  UserPhoto({
    super.key,
    this.imageUrl,
    this.localImagePath,
    this.asset,
    required this.imageSize,
  }) : assert(imageUrl != null || localImagePath != null || asset != null, 'Provide at least one image source');

  Widget _buildImageFromBytes(Uint8List bytes) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: SizedBox(
          width: 100,
          height: 100,
          child: Image.memory(
            bytes,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final dimensions = ImageHelper.getDimensions(imageSize);

    if (asset != null) {
      final cacheKey = 'asset_${asset!.id}';

      if (_assetCache.containsKey(cacheKey)) {
        return _buildImageFromBytes(_assetCache[cacheKey]!);
      }

      return FutureBuilder<Uint8List?>(
        future: ImageResizeHelper.getBytesFromAsset(
          asset: asset!,
          purpose: ImagePurpose.preview,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ClosetProgressIndicator();
          } else if (snapshot.hasData) {
            _assetCache[cacheKey] = snapshot.data!;
            return _buildImageFromBytes(snapshot.data!);
          } else {
            return const Icon(Icons.broken_image);
          }
        },
      );
    }

    // 🔧 2. Local file path
    if (localImagePath != null) {
      final cacheKey = 'file_$localImagePath';

      if (_assetCache.containsKey(cacheKey)) {
        return _buildImageFromBytes(_assetCache[cacheKey]!);
      }

      return FutureBuilder<Uint8List?>(
        future: ImageResizeHelper.getBytesFromLocalPath(
          path: localImagePath!,
          purpose: ImagePurpose.preview,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ClosetProgressIndicator();
          } else if (snapshot.hasData) {
            _assetCache[cacheKey] = snapshot.data!;
            return _buildImageFromBytes(snapshot.data!);
          } else {
            return const Icon(Icons.broken_image);
          }
        },
      );
    }


    return FutureBuilder<String>(
      future: fetchService.getTransformedImageUrl(
        imageUrl!,
        'item_pics',
        width: dimensions['width'],
        height: dimensions['height'],
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ClosetProgressIndicator();
        } else if (snapshot.hasError) {
          return const Icon(Icons.error);
        } else if (snapshot.hasData) {
          String transformedImageUrl = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.only(top: 5.0, right: 5.0, left: 5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  transformedImageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                ),
              ),
          );
        } else {
          return const Icon(Icons.error);
        }
      },
    );
  }
}
