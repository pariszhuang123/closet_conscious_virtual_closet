import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/photo_bloc.dart';
import 'view/photo_upload_item_screen.dart';
import 'view/photo_edit_item_screen.dart';
import 'view/photo_selfie_screen.dart';
import '../../../utilities/permission_service.dart';
import '../../usecase/photo_capture_service.dart';
import '../../../data/services/core_save_services.dart';


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
        coreSaveService: CoreSaveService(),
      ),
      child: Builder(
        builder: (context) {
          // Use the cameraContext enum to decide which view to load
          switch (cameraContext) {
            case CameraPermissionContext.uploadItem:
              return PhotoUploadItemScreen(cameraContext: CameraPermissionContext.uploadItem);  // No itemId or outfitId needed
            case CameraPermissionContext.editItem:
              return PhotoEditItemScreen(itemId: itemId, cameraContext: CameraPermissionContext.editItem);  // itemId is required
            case CameraPermissionContext.selfie:
              return PhotoSelfieScreen(outfitId: outfitId, cameraContext: CameraPermissionContext.selfie);  // outfitId is required
            default:
              return Container(); // Fallback
          }
        },
      ),
    );
  }
}
