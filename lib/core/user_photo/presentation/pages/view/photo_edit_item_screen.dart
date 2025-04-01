import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/photo_bloc.dart';
import '../../../../presentation/bloc/navigate_core_bloc/navigate_core_bloc.dart';
import '../../../../utilities/routes.dart';
import '../../../../utilities/logger.dart';
import '../../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../paywall/data/feature_key.dart';
import '../../widgets/base/base_photo_screen.dart';

class PhotoEditItemScreen extends BasePhotoScreen {
  final String? itemId;

  PhotoEditItemScreen({
    super.key,
    required super.cameraContext,
    this.itemId,
  }) : super(logger: CustomLogger('PhotoEditItemScreen'));

  @override
  PhotoEditItemScreenState createState() => PhotoEditItemScreenState();
}

class PhotoEditItemScreenState extends BasePhotoScreenState<PhotoEditItemScreen> {
  @override
  void triggerAccessCheck() {
    // Dispatch the event to check edit item creation access
    navigateCoreBloc.add(const CheckEditItemCreationAccessEvent());
    widget.logger.i('Checking if edit item can be triggered');
  }

  @override
  void onPermissionClose() {
    widget.logger.i('Camera permission check failed, navigating to EditItem');
    navigateSafely(AppRoutes.editItem, arguments: widget.itemId);
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

  @override
  Widget build(BuildContext context) {
    widget.logger.d('Building PhotoEditItemScreen');
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          // Listen for navigation and access events
          BlocListener<NavigateCoreBloc, NavigateCoreState>(
            listener: (context, state) {
              if (state is BronzeEditItemDeniedState ||
                  state is SilverEditItemDeniedState ||
                  state is GoldEditItemDeniedState) {
                final featureKey = state is BronzeEditItemDeniedState
                    ? FeatureKey.editItemBronze
                    : state is SilverEditItemDeniedState
                    ? FeatureKey.editItemSilver
                    : FeatureKey.editItemGold;

                widget.logger.i('${featureKey.name} access denied, navigating to payment screen');

                navigateSafely(AppRoutes.payment, arguments: {
                  'featureKey': featureKey,
                  'isFromMyCloset': true,
                  'previousRoute': AppRoutes.editItem,
                  'nextRoute': AppRoutes.myCloset,
                  'itemId': widget.itemId,
                });
              } else if (state is ItemAccessGrantedState) {
                onAccessGranted();
              } else if (state is ItemAccessErrorState) {
                widget.logger.e('Error checking edit access');
              }
            },
          ),
          // Listen for photo capture and camera permission events
          BlocListener<PhotoBloc, PhotoState>(
            listener: (context, state) {
              if (state is CameraPermissionDenied) {
                widget.logger.w('Camera permission denied');
                handleCameraPermission();
              } else if (state is CameraPermissionGranted && !cameraInitialized) {
                handleCameraInitialized();
                if (widget.itemId != null) {
                  photoBloc.add(CaptureEditItemPhoto(widget.itemId!));
                } else {
                  widget.logger.e('Item ID is null. Cannot capture EditItem.');
                  navigateSafely(AppRoutes.editItem, arguments: {'itemId': widget.itemId});
                }
              } else if (state is PhotoCaptureFailure) {
                widget.logger.e('Photo capture failed');
                navigateSafely(AppRoutes.editItem, arguments: widget.itemId);
              } else if (state is EditItemCaptureSuccess) {
                widget.logger.i('Photo upload succeeded with itemId: ${state.itemId}');
                navigateSafely(AppRoutes.myCloset);
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
