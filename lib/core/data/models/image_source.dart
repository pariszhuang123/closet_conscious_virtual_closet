import 'package:photo_manager/photo_manager.dart';
import 'package:equatable/equatable.dart';

import '../../core_enums.dart';

class ImageSource extends Equatable {
  final ImageSourceType type;
  final String? path; // Used for remote or local file
  final AssetEntity? asset;

  const ImageSource.remote(this.path)
      : type = ImageSourceType.remote,
        asset = null;

  const ImageSource.assetEntity(this.asset)
      : type = ImageSourceType.assetEntity,
        path = null;

  bool get isRemote => type == ImageSourceType.remote;
  bool get isAsset => type == ImageSourceType.assetEntity;

  @override
  List<Object?> get props => [type, path, asset];
}

