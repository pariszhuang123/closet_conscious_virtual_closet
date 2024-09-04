import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/photo_bloc.dart';
import 'view/photo_upload_item_view.dart';
import 'view/photo_edit_item_view.dart';
import '../../data/services/image_upload_service.dart';
import '../../../utilities/permission_service.dart';
import '../../usecase/photo_capture_service.dart';


class PhotoProvider extends StatelessWidget {
  final CameraPermissionContext cameraContext;
  final String? itemId;  // Nullable: only for editItem
  final String? outfitId;  // Nullable: only for selfie
// Add context to decide which view to load

  const PhotoProvider({super.key,
    required this.cameraContext,
    this.itemId,  // Passed when editing an item
    this.outfitId,  // Passed when taking a selfie
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PhotoBloc(
        photoCaptureService: PhotoCaptureService(),
        imageUploadService: ImageUploadService(),
      ),
      child: Builder(
        builder: (context) {
          // Use the cameraContext enum to decide which view to load
          switch (cameraContext) {
            case CameraPermissionContext.uploadItem:
              return PhotoUploadItemView(cameraContext: CameraPermissionContext.uploadItem);  // No itemId or outfitId needed
            case CameraPermissionContext.editItem:
              return const PhotoEditItemView(cameraContext: CameraPermissionContext.editItem);  // itemId is required
            default:
              return Container(); // Fallback
          }
        },
      ),
    );
  }
}
