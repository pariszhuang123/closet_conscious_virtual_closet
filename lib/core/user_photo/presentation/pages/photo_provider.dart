import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../bloc/photo_bloc.dart';
import 'view/photo_upload_item_screen.dart';
import 'view/photo_edit_item_screen.dart';
import 'view/photo_selfie_screen.dart';
import 'view/photo_edit_closet_screen.dart';
import '../../../core_enums.dart';
import '../../usecase/photo_capture_service.dart';
import '../../../data/services/core_save_services.dart';
import '../../../data/services/core_fetch_services.dart';
import '../../../paywall/presentation/bloc/premium_feature_access_bloc/premium_feature_access_bloc.dart';
import '../../../utilities/logger.dart';

final GetIt coreLocator = GetIt.instance;

class PhotoProvider extends StatelessWidget {
  final CameraPermissionContext cameraContext;
  final String? itemId;  // Nullable: only for editItem
  final String? outfitId;  // Nullable: only for selfie
  final String? closetId;  // Nullable: only for closet photo
  final CustomLogger logger = CustomLogger('PhotoProvider');

  PhotoProvider({super.key,
    required this.cameraContext,
    this.itemId,  // Passed when editing an item
    this.outfitId,  // Passed when taking a selfie
    this.closetId,  // Passed when taking a closet photo

  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<PhotoBloc>(
          create: (context) => PhotoBloc(
            photoCaptureService: PhotoCaptureService(),
            coreSaveService: coreLocator<CoreSaveService>(),  // Access CoreSaveService via GetIt
          ),
        ),
        BlocProvider<PremiumFeatureAccessBloc>(
          create: (context) => PremiumFeatureAccessBloc(
            coreFetchService: coreLocator<CoreFetchService>(),  // Access CoreFetchService via GetIt
            coreSaveService: coreLocator<CoreSaveService>(),    // Access CoreSaveService via GetIt
          ),
        ),
      ],
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
            case CameraPermissionContext.editCloset:
              return PhotoEditClosetScreen(closetId: closetId, cameraContext: CameraPermissionContext.editCloset);  // outfitId is required
            case _:
              throw UnimplementedError('Unexpected CameraPermissionContext: $cameraContext');
          }
        },
      ),
    );
  }
}
