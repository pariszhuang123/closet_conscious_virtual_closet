import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:typed_data';

import '../../../../data/services/core_fetch_services.dart';
import '../../../../core_enums.dart';
import '../../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../utilities/helper_functions/image_helper/image_helper.dart';
import '../../../../utilities/logger.dart';

class UserPhoto extends StatelessWidget {
  final String? imageUrl; // for remote
  final AssetEntity? asset; // for local (photo manager)
  final ImageSize imageSize;

  final CoreFetchService fetchService = CoreFetchService();
  static final Map<String, Uint8List> _assetCache = {};

  static void clearCache() {
    _logger.i('🧹 Asset cache cleared');
    _assetCache.clear();
  }

  static final _logger = CustomLogger('UserPhoto');

  UserPhoto({
    super.key,
    this.imageUrl,
    this.asset,
    required this.imageSize,
  }) : assert(imageUrl != null || asset != null, 'Provide at least one image source');

  Widget _buildImageFromBytes(Uint8List bytes) {
    _logger.d('✅ Rendering image from bytes (AssetEntity)');
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

    // 🟡 Case 1: AssetEntity (Local)
    if (asset != null) {
      final cacheKey = 'asset_${asset!.id}';
      _logger.d('📸 Loading local asset: ID=${asset!.id}, title=${asset!.title}, path=${asset!.relativePath}');

      if (_assetCache.containsKey(cacheKey)) {
        _logger.d('📦 Using cached asset image for ID=${asset!.id}');
        return _buildImageFromBytes(_assetCache[cacheKey]!);
      }

      return FutureBuilder<Uint8List?>(
        future: asset!.thumbnailDataWithSize(
          ThumbnailSize(
            dimensions['width'] ?? 100,
            dimensions['height'] ?? 100,
          ),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            _logger.d('⏳ Thumbnail loading for assetId=${asset!.id}');
            return const ClosetProgressIndicator();
          } else if (snapshot.hasData) {
            _logger.d('✅ Thumbnail loaded for assetId=${asset!.id}');
            _assetCache[cacheKey] = snapshot.data!;
            return _buildImageFromBytes(snapshot.data!);
          } else {
            _logger.e('❌ Failed to load thumbnail for assetId=${asset!.id}');
            return const Icon(Icons.broken_image);
          }
        },
      );
    }

    // 🟢 Case 2: Remote URL (Supabase)
    _logger.d('🌐 Loading remote image: $imageUrl');

    return FutureBuilder<String>(
      future: fetchService.getTransformedImageUrl(
        imageUrl!,
        'item_pics',
        width: dimensions['width'],
        height: dimensions['height'],
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          _logger.d('⏳ Fetching transformed image URL for: $imageUrl');
          return const ClosetProgressIndicator();
        } else if (snapshot.hasError || !snapshot.hasData) {
          _logger.e('❌ Failed to fetch remote image URL: $imageUrl, error: ${snapshot.error}');
          return const Icon(Icons.error);
        } else {
          _logger.d('✅ Remote image ready: ${snapshot.data}');
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                snapshot.data!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  _logger.e('❌ Image.network failed to load: ${snapshot.data}');
                  return const Icon(Icons.error);
                },
              ),
            ),
          );
        }
      },
    );
  }
}
