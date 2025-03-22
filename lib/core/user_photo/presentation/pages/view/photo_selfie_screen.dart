import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/photo_bloc.dart';
import '../../../../presentation/bloc/navigate_core_bloc/navigate_core_bloc.dart';
import '../../../../utilities/helper_functions/permission_helper/camera_permission_helper.dart';
import '../../../../core_enums.dart';
import '../../../../utilities/routes.dart';
import '../../../../utilities/logger.dart';
import '../../../../widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../theme/my_outfit_theme.dart'; // Import your custom theme
import '../../../../paywall/data/feature_key.dart';

class PhotoSelfieScreen extends StatefulWidget {
  final CameraPermissionContext cameraContext;
  final String? outfitId;
  final CustomLogger _logger = CustomLogger('PhotoSelfieScreen');

  PhotoSelfieScreen({
    super.key,
    required this.cameraContext,
    this.outfitId,
  });

  @override
  PhotoSelfieScreenState createState() => PhotoSelfieScreenState();
}

class PhotoSelfieScreenState extends State<PhotoSelfieScreen> with WidgetsBindingObserver {
  late final PhotoBloc _photoBloc;
  late final NavigateCoreBloc _navigateCoreBloc;
  late final CameraPermissionHelper _cameraPermissionHelper;
  bool _cameraInitialized = false;
  bool _selfieAccessGranted = false;

  @override
  void initState() {
    super.initState();
    _photoBloc = context.read<PhotoBloc>();
    _navigateCoreBloc = context.read<NavigateCoreBloc>();
    _cameraPermissionHelper = CameraPermissionHelper();
    _triggerSelfieCreation();
    WidgetsBinding.instance.addObserver(this); // Add lifecycle observer
    widget._logger.d('Initializing PhotoSelfieScreen');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_cameraInitialized && _selfieAccessGranted) {
      widget._logger.d('Dependencies changed: checking camera permission');
      _checkCameraPermission(); // Safe to call here
    }
  }

  void _checkCameraPermission() {
    widget._logger.d('Checking camera permission');
    _photoBloc.add(CheckOrRequestCameraPermission(
      cameraContext: widget.cameraContext,
      context: context,
      theme: Theme.of(context),
      onClose: () {
        widget._logger.i('Camera permission check failed, navigating to WearOutfit');
        _navigateToWearOutfit();
      },
    ));
  }

  void _triggerSelfieCreation() {
    widget._logger.i('Checking if selfie creation can be triggered');
    _navigateCoreBloc.add(const CheckSelfieCreationAccessEvent());
  }

  void _navigateSafely(String routeName, {Object? arguments}) {
    if (mounted) {
      widget._logger.d('Navigating to $routeName with arguments: $arguments');
      Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
    } else {
      widget._logger.e("Cannot navigate to $routeName, widget is not mounted");
    }
  }

  void _navigateToWearOutfit() {
    widget._logger.d('Navigating to Wear Outfit');
    _navigateSafely(
      AppRoutes.wearOutfit,
      arguments: widget.outfitId,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !_cameraInitialized) {
      widget._logger.d('App resumed, checking camera permission again');
      _checkCameraPermission();
    }
  }

  void _handleCameraInitialized() {
    widget._logger.d('Camera initialized');
    _cameraInitialized = true; // Set the flag to true when the camera is initialized
  }

  void _handleCameraPermission(BuildContext context) {
    widget._logger.d('Handling camera permission');
    _cameraPermissionHelper.checkAndRequestPermission(
      context: context,
      theme: Theme.of(context),
      cameraContext: widget.cameraContext,
      onClose: () {
        widget._logger.i('Permission handling closed, navigating to WearOutfit');
        _navigateToWearOutfit();
      },
    );
  }


  @override
  void dispose() {
    widget._logger.i('Disposing PhotoSelfieScreen');
    WidgetsBinding.instance.removeObserver(this); // Remove lifecycle observer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget._logger.d('Building PhotoSelfieScreen');

    return Theme(
      data: myOutfitTheme, // Apply your custom theme
      child: Scaffold(
        body: MultiBlocListener(
          listeners: [
            BlocListener<NavigateCoreBloc, NavigateCoreState>(
              listener: (context, state) {
                if (state is BronzeSelfieDeniedState) {
                  widget._logger.i('Bronze selfie access denied, navigating to payment screen.');
                  _navigateSafely(
                    AppRoutes.payment,
                    arguments: {
                      'featureKey': FeatureKey.selfieBronze,
                      'isFromMyCloset': true,
                      'previousRoute': AppRoutes.wearOutfit,
                      'nextRoute': AppRoutes.createOutfit,
                      'outfitId': widget.outfitId,
                    },
                  );
                } else if (state is SilverSelfieDeniedState) {
                  widget._logger.i('Silver selfie access denied, navigating to payment screen');
                  _navigateSafely(
                    AppRoutes.payment,
                    arguments: {
                      'featureKey': FeatureKey.selfieSilver,
                      'isFromMyCloset': true,
                      'previousRoute': AppRoutes.wearOutfit,
                      'nextRoute': AppRoutes.createOutfit,
                      'outfitId': widget.outfitId,
                    },
                  );
                } else if (state is GoldSelfieDeniedState) {
                  widget._logger.i('Gold selfie access denied, navigating to payment screen');
                  _navigateSafely(
                    AppRoutes.payment,
                    arguments: {
                      'featureKey': FeatureKey.selfieGold,
                      'isFromMyCloset': true,
                      'previousRoute': AppRoutes.wearOutfit,
                      'nextRoute': AppRoutes.createOutfit,
                      'outfitId': widget.outfitId,
                    },
                  );
                } else if (state is ItemAccessGrantedState) {
                  _selfieAccessGranted = true;
                  widget._logger.d('Selfie access granted: $_selfieAccessGranted');
                  if (!_cameraInitialized) {
                    _checkCameraPermission();
                  }
                } else if (state is ItemAccessErrorState) {
                  widget._logger.e('Error checking selfie access');
                }
              },
            ),
            BlocListener<PhotoBloc, PhotoState>(
              listener: (context, state) {
                if (state is CameraPermissionDenied) {
                  widget._logger.w('Camera permission denied');
                  _handleCameraPermission(context);
                } else if (state is CameraPermissionGranted && !_cameraInitialized) {
                  _handleCameraInitialized();
                  if (widget.outfitId != null) {
                    context.read<PhotoBloc>().add(CaptureSelfiePhoto(widget.outfitId!));
                  } else {
                    widget._logger.e('Outfit ID is null. Cannot capture selfie.');
                    _navigateToWearOutfit();
                  }
                } else if (state is PhotoCaptureFailure) {
                  widget._logger.e('Photo capture failed');
                  _navigateToWearOutfit();
                } else if (state is SelfieCaptureSuccess) {
                  widget._logger.i('Selfie upload succeeded with outfitId: ${state.outfitId}');
                  _navigateToWearOutfit();
                }
              },
            ),
          ],
          child: BlocBuilder<PhotoBloc, PhotoState>(
            builder: (context, state) {
              if (state is PhotoCaptureInProgress || (state is CameraPermissionGranted && !_cameraInitialized)) {
                return const OutfitProgressIndicator(size: 24.0);
              } else {
                widget._logger.d('Waiting for camera permission...');
                return const OutfitProgressIndicator(size: 24.0);
              }
            },
          ),
        ),
      ),
    );
  }
}
