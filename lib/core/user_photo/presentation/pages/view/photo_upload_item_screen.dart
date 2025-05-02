import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/photo_bloc.dart';
import '../../../../presentation/bloc/navigate_core_bloc/navigate_core_bloc.dart';
import '../../../../core_enums.dart';
import '../../../../utilities/app_router.dart';
import '../../../../utilities/logger.dart';
import '../../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../widgets/base/base_photo_screen.dart';

class PhotoUploadItemScreen extends BasePhotoScreen {

  PhotoUploadItemScreen({
    super.key,
    required super.cameraContext,
  }) : super(
    logger: CustomLogger('PhotoUploadItemScreen'),
  );

  @override
  PhotoUploadItemScreenState createState() => PhotoUploadItemScreenState();
}

class PhotoUploadItemScreenState extends BasePhotoScreenState<PhotoUploadItemScreen> {
  bool paymentRequired = false; // 🚨 Track payment requirement

  @override
  void triggerAccessCheck() {
    widget.logger.i('Checking if upload item can be triggered');
    navigateCoreBloc.add(const CheckUploadItemCreationAccessEvent());
  }

  @override
  void onPermissionClose() {
    widget.logger.i('Camera permission denied. Navigating to MyCloset.');
    navigateSafely(AppRoutesName.myCloset);
  }

  @override
  void onAccessGranted() {
    setState(() => accessGranted = true);
    if (!cameraInitialized) checkCameraPermission();
  }

  void _navigateToUploadItem(String imageUrl) {
    widget.logger.d('Navigating to UploadItem with imageUrl: $imageUrl');
    navigateSafely(AppRoutesName.uploadItem, extra: imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    widget.logger.d('Building PhotoUploadItemScreen');

    return MultiBlocListener(
      listeners: [
        BlocListener<NavigateCoreBloc, NavigateCoreState>(
          listener: (context, state) {
            if (state is BronzeUploadItemDeniedState ||
                state is SilverUploadItemDeniedState ||
                state is GoldUploadItemDeniedState) {
              final featureKey = state is BronzeUploadItemDeniedState
                  ? FeatureKey.uploadItemBronze
                  : state is SilverUploadItemDeniedState
                  ? FeatureKey.uploadItemSilver
                  : FeatureKey.uploadItemGold;

              widget.logger.i('${featureKey
                  .name} access denied, navigating to payment screen');
              paymentRequired = true;

              WidgetsBinding.instance.addPostFrameCallback((_) {
                navigateSafely(AppRoutesName.payment, extra: {
                  'featureKey': featureKey,
                  'isFromMyCloset': true,
                  'previousRoute': AppRoutesName.myCloset,
                  'nextRoute': AppRoutesName.uploadItemPhoto,
                  'uploadSource': UploadSource.camera,
                });
              });
            } else if (state is ItemAccessGrantedState &&
                !paymentRequired &&
                !accessGranted) {
              widget.logger.i('Access granted, calling onAccessGranted()');
              onAccessGranted();
            } else if (state is ItemAccessErrorState) {
              widget.logger.e('Error checking access');
            }
          },
        ),
        BlocListener<PhotoBloc, PhotoState>(
          listener: (context, state) {
            if (state is CameraPermissionDenied) {
              widget.logger.w('Camera permission denied');
              handleCameraPermission();
            } else if (state is CameraPermissionGranted && !cameraInitialized) {
              widget.logger.i('Camera permission granted, capturing photo');
              handleCameraInitialized();
              photoBloc.add(CapturePhoto());
            } else if (state is PhotoCaptureFailure) {
              widget.logger.e('Photo capture failed');
              navigateSafely(AppRoutesName.myCloset);
            } else if (state is PhotoCaptureSuccess) {
              widget.logger.i(
                  'Photo uploaded with imageUrl: ${state.imageUrl}');
              _navigateToUploadItem(state.imageUrl);
            }
          },
        ),
      ],
      child: BlocBuilder<NavigateCoreBloc, NavigateCoreState>(
        builder: (context, accessState) {
          if (accessState is InitialNavigateCoreState) {
            return const Scaffold(
              body: Center(child: ClosetProgressIndicator()),
            );
          }

          return Scaffold(
            body: BlocBuilder<PhotoBloc, PhotoState>(
              builder: (context, state) {
                if (state is PhotoCaptureInProgress ||
                    (state is CameraPermissionGranted && !cameraInitialized)) {
                  return const ClosetProgressIndicator();
                }

                widget.logger.d('Waiting for camera permission...');
                return const ClosetProgressIndicator(); // Replace with camera preview when ready
              },
            ),
          );
        },
      ),
    );
  }
}