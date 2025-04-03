import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/photo_bloc.dart';
import '../../../../presentation/bloc/navigate_core_bloc/navigate_core_bloc.dart';
import '../../../../utilities/app_router.dart';
import '../../../../utilities/logger.dart';
import '../../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../paywall/data/feature_key.dart';
import '../../widgets/base/base_photo_screen.dart';

class PhotoEditClosetScreen extends BasePhotoScreen {
  final String? closetId;

  PhotoEditClosetScreen({
    super.key,
    required super.cameraContext,
    this.closetId,
  }) : super(logger: CustomLogger('PhotoEditClosetScreen'));

  @override
  PhotoEditClosetScreenState createState() => PhotoEditClosetScreenState();
}

class PhotoEditClosetScreenState extends BasePhotoScreenState<PhotoEditClosetScreen> {
  @override
  void triggerAccessCheck() {
    // Dispatch event specific for closet editing
    navigateCoreBloc.add(const CheckEditClosetCreationAccessEvent());
    widget.logger.i('Triggering EditCloset creation access check');
  }

  @override
  void onPermissionClose() {
    widget.logger.i('Camera permission check failed, navigating to EditCloset');
    navigateSafely(AppRoutesName.editMultiCloset);
  }

  @override
  void onAccessGranted() {
    setState(() {
      accessGranted = true;
    });
    if (!cameraInitialized) {
      checkCameraPermission();
    }
  }

  // Build method and Bloc listeners can also be shared partially.
  // You only need to add screen-specific behavior.
  @override
  Widget build(BuildContext context) {
    widget.logger.d('Building PhotoEditClosetScreen');
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<NavigateCoreBloc, NavigateCoreState>(
            listener: (context, state) {
              if (state is BronzeEditClosetDeniedState ||
                  state is SilverEditClosetDeniedState ||
                  state is GoldEditClosetDeniedState) {
                final featureKey = state is BronzeEditClosetDeniedState
                    ? FeatureKey.editClosetBronze
                    : state is SilverEditClosetDeniedState
                    ? FeatureKey.editClosetSilver
                    : FeatureKey.editClosetGold;

                navigateSafely(AppRoutesName.payment, extra: {
                  'featureKey': featureKey,
                  'isFromMyCloset': true,
                  'previousRoute': AppRoutesName.editMultiCloset,
                  'nextRoute': AppRoutesName.myCloset,
                  'closetId': widget.closetId,
                });
              } else if (state is ClosetAccessGrantedState) {
                onAccessGranted();
              } else if (state is ClosetAccessErrorState) {
                widget.logger.e('Error checking edit access');
              }
            },
          ),
          BlocListener<PhotoBloc, PhotoState>(
            listener: (context, state) {
              if (state is CameraPermissionDenied) {
                widget.logger.w('Camera permission denied');
                handleCameraPermission();
              } else if (state is CameraPermissionGranted && !cameraInitialized) {
                handleCameraInitialized();
                if (widget.closetId != null) {
                  photoBloc.add(CaptureEditClosetPhoto(widget.closetId!));
                } else {
                  widget.logger.e('Closet ID is null. Cannot capture Edit Closet.');
                  navigateSafely(AppRoutesName.editMultiCloset);
                }
              } else if (state is PhotoCaptureFailure) {
                widget.logger.e('Photo capture failed');
                navigateSafely(AppRoutesName.editMultiCloset);
              } else if (state is EditClosetCaptureSuccess) {
                widget.logger.i('Photo upload succeeded with closetId: ${state.closetId}');
                navigateSafely(AppRoutesName.editMultiCloset);
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
