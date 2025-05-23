import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/photo_bloc.dart';
import '../../../../paywall/presentation/bloc/premium_feature_access_bloc/premium_feature_access_bloc.dart';
import '../../../../utilities/app_router.dart';
import '../../../../utilities/logger.dart';
import '../../../../widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../theme/my_outfit_theme.dart';
import '../../widgets/base/base_photo_screen.dart';
import '../../../../core_enums.dart';

class PhotoSelfieScreen extends BasePhotoScreen {
  final String? outfitId;

  PhotoSelfieScreen({
    super.key,
    required super.cameraContext,
    this.outfitId,
  }) : super(
    logger: CustomLogger('PhotoSelfieScreen'),
  );

  @override
  PhotoSelfieScreenState createState() => PhotoSelfieScreenState();
}

class PhotoSelfieScreenState extends BasePhotoScreenState<PhotoSelfieScreen> {
  bool paymentRequired = false; // 🚨 Track if payment was needed

  @override
  bool get autoTriggerAccessCheck => false;

  @override
  void triggerAccessCheck() {
    premiumFeatureAccessBloc.add(const CheckSelfieCreationAccessEvent());
    widget.logger.i('Checking if selfie creation can be triggered');
  }

  @override
  void onPermissionClose() {
    widget.logger.i('Camera permission check failed, navigating to WearOutfit');
    navigateOnceTo(AppRoutesName.wearOutfit, extra: widget.outfitId);
  }

  @override
  void onAccessGranted() {
    accessGranted = true;
    if (!cameraInitialized) checkCameraPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: myOutfitTheme,
      child: Scaffold(
        body: MultiBlocListener(
          listeners: [
            BlocListener<PremiumFeatureAccessBloc, PremiumFeatureAccessState>(
              listener: (context, state) {
                if (state is BronzeSelfieDeniedState ||
                    state is SilverSelfieDeniedState ||
                    state is GoldSelfieDeniedState) {
                  final featureKey = state is BronzeSelfieDeniedState
                      ? FeatureKey.selfieBronze
                      : state is SilverSelfieDeniedState
                      ? FeatureKey.selfieSilver
                      : FeatureKey.selfieGold;

                  paymentRequired = true; // 🚨 Payment is required

                  navigateOnceTo(AppRoutesName.payment, extra: {
                    'featureKey': featureKey,
                    'isFromMyCloset': true,
                    'previousRoute': AppRoutesName.wearOutfit,
                    'nextRoute': AppRoutesName.createOutfit,
                    'outfitId': widget.outfitId,
                  });

                } else if (state is ItemAccessGrantedState) {
                  widget.logger.i('Upload item access granted.');

                  if (!paymentRequired) {
                    widget.logger.i('No payment required, proceeding.');

                    onAccessGranted();
                  } else {
                    widget.logger.w('Payment was cancelled or failed, blocking access');
                    // Optionally navigate away or show a message
                  }
                } else if (state is ItemAccessGrantedState && !paymentRequired) {
                  widget.logger.i('Item access granted with no payment needed');
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
                  handleCameraInitialized();
                  if (widget.outfitId != null) {
                    photoBloc.add(CaptureSelfiePhoto(widget.outfitId!));
                  } else {
                    widget.logger.e('Outfit ID is null. Cannot capture selfie.');
                    navigateOnceTo(AppRoutesName.wearOutfit, extra: widget.outfitId);
                  }
                } else if (state is PhotoCaptureFailure) {
                  widget.logger.e('Photo capture failed');
                  navigateOnceTo(AppRoutesName.wearOutfit, extra: widget.outfitId);
                } else if (state is SelfieCaptureSuccess) {
                  widget.logger.i('Selfie upload succeeded with outfitId: ${state.outfitId}');
                  navigateOnceTo(AppRoutesName.wearOutfit, extra: widget.outfitId);
                }
              },
            ),
          ],
          child: BlocBuilder<PhotoBloc, PhotoState>(
            builder: (context, state) {
              if (state is PhotoCaptureInProgress ||
                  (state is CameraPermissionGranted && !cameraInitialized)) {
                return const OutfitProgressIndicator(size: 24.0);
              } else {
                widget.logger.d('Waiting for camera permission...');
                return const OutfitProgressIndicator(size: 24.0);
              }
            },
          ),
        ),
      ),
    );
  }
}
