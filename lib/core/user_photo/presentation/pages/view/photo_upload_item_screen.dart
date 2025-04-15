import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/photo_bloc.dart';
import '../../../../presentation/bloc/navigate_core_bloc/navigate_core_bloc.dart';
import '../../../../core_enums.dart';
import '../../../../utilities/app_router.dart';
import '../../../../utilities/logger.dart';
import '../../../../utilities/helper_functions/tutorial_helper.dart';
import '../../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../widgets/base/base_photo_screen.dart';
import '../../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';

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
  @override
  void initState() {
    super.initState();

    // ✅ Trigger tutorial check using positional constructor
    context.read<TutorialBloc>().add(
      const CheckTutorialStatus(TutorialType.freeUploadCamera),
    );
  }

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

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<TutorialBloc, TutorialState>(
            listener: (context, tutorialState) {
              if (tutorialState is ShowTutorial) {
                widget.logger.i('Tutorial trigger detected, navigating to tutorial video pop-up');
                context.goNamed(
                  AppRoutesName.tutorialVideoPopUp,
                  extra: {
                    'nextRoute': AppRoutesName.uploadItemPhoto,
                    'tutorialInputKey': TutorialType.freeUploadCamera.value,
                    'isFromMyCloset': true,
                  },
                );
              }
            },
          ),
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

                navigateSafely(AppRoutesName.payment, extra: {
                  'featureKey': featureKey,
                  'isFromMyCloset': true,
                  'previousRoute': AppRoutesName.myCloset,
                  'nextRoute': AppRoutesName.uploadItemPhoto,
                  'uploadSource': UploadSource.camera,
                });
              } else if (state is ItemAccessGrantedState) {
                widget.logger.d('Upload access granted.');
                onAccessGranted();
              } else if (state is ItemAccessErrorState) {
                widget.logger.e('Error checking upload access');
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
                widget.logger.i('Photo uploaded with imageUrl: ${state.imageUrl}');
                _navigateToUploadItem(state.imageUrl);
              }
            },
          ),
        ],
        child: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (context, state) {
            if (state is PhotoCaptureInProgress ||
                (state is CameraPermissionGranted && !cameraInitialized)) {
              return const ClosetProgressIndicator();
            } else {
              widget.logger.d('Waiting for camera permission...');
              return const ClosetProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
