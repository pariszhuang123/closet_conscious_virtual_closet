import 'package:equatable/equatable.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../../core/data/models/image_source.dart';
import '../../../../core/utilities/logger.dart';

class ClosetItemMinimal extends Equatable {
  final String itemId;
  final ImageSource imageSource;
  final String name;
  final String? itemType;
  final double? pricePerWear;
  final bool isDisliked;
  final bool itemIsActive;

  static final _logger = CustomLogger('ClosetItemMinimal');

  const ClosetItemMinimal({
    required this.itemId,
    required this.imageSource,
    required this.name,
    this.itemType,
    this.pricePerWear,
    this.isDisliked = false,
    this.itemIsActive = true,
  });

  factory ClosetItemMinimal.fromMap(
      Map<String, dynamic> map, {
        AssetEntity? localAssetEntity,
      }) {
    final itemId = map['item_id'] as String;
    final name = map['name'] as String;
    final imageUrl = map['image_url'] as String?;
    final imageSource = localAssetEntity != null
        ? ImageSource.assetEntity(localAssetEntity)
        : ImageSource.remote(imageUrl ?? '');

    if (localAssetEntity != null) {
      _logger.d(
        '🧵 Creating ClosetItemMinimal with local asset: '
            'itemId=$itemId, name=$name, assetId=${localAssetEntity.id}, '
            'title=${localAssetEntity.title}, relativePath=${localAssetEntity.relativePath}',
      );
    } else {
      _logger.d(
        '🌐 Creating ClosetItemMinimal with remote image: '
            'itemId=$itemId, name=$name, url=$imageUrl',
      );
    }

    return ClosetItemMinimal(
      itemId: itemId,
      imageSource: imageSource,
      name: name,
      itemType: map['item_type'] as String?,
      pricePerWear: (map['price_per_wear'] as num?)?.toDouble(),
      isDisliked: map['is_disliked'] as bool? ?? false,
      itemIsActive: (map.containsKey('item_is_active') && map['item_is_active'] != null)
          ? map['item_is_active'] as bool
          : true,
    );
  }

  ClosetItemMinimal copyWith({
    String? itemId,
    ImageSource? imageSource,
    String? name,
    String? itemType,
    double? pricePerWear,
    bool? isDisliked,
    bool? itemIsActive,
  }) {
    return ClosetItemMinimal(
      itemId: itemId ?? this.itemId,
      imageSource: imageSource ?? this.imageSource,
      name: name ?? this.name,
      itemType: itemType ?? this.itemType,
      pricePerWear: pricePerWear ?? this.pricePerWear,
      isDisliked: isDisliked ?? this.isDisliked,
      itemIsActive: itemIsActive ?? this.itemIsActive,
    );
  }

  @override
  List<Object?> get props => [
    itemId,
    imageSource,
    name,
    itemType,
    pricePerWear,
    isDisliked,
    itemIsActive,
  ];
}
