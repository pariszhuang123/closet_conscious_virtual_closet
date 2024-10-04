import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/photo_bloc.dart';
import '../../../../navigation/presentation/bloc/navigate_core_bloc.dart';
import '../../widgets/camera_permission_helper.dart';
import '../../../../core_enums.dart';
import '../../../../utilities/routes.dart';
import '../../../../utilities/logger.dart';
import '../../../../widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../theme/my_outfit_theme.dart';  // Import your custom theme
import '../../../../paywall/data/feature_key.dart';

class PhotoSelfieScreen extends StatefulWidget {
  final CameraPermissionContext cameraContext;
  final String? outfitId;
  final CustomLogger _logger = CustomLogger('PhotoSelfieScreen');

  // Constructor accepting the context (selfie)
  PhotoSelfieScreen({
    super.key,
    required this.cameraContext,
    this.outfitId});

  @override
  PhotoSelfieScreenState createState() => PhotoSelfieScreenState();
}

late PhotoBloc _photoBloc;
late NavigateCoreBloc _navigateCoreBloc;
late CameraPermissionHelper _cameraPermissionHelper;

class PhotoSelfieScreenState extends State<PhotoSelfieScreen> with WidgetsBindingObserver {
  bool _cameraInitialized = false; // Track if the camera has been initialized
  bool _selfieAccessGranted = false; // Track if edit access is granted

  @override
  void initState() {
    super.initState();
    _photoBloc = context.read<PhotoBloc>(); // Access the bloc here safely
    _navigateCoreBloc = context.read<NavigateCoreBloc>(); // Access the bloc here safely
    _triggerSelfieCreation();
    _cameraPermissionHelper = CameraPermissionHelper(); // Initialize CameraPermissionHelper
    WidgetsBinding.instance.addObserver(this); // Add lifecycle observer
    widget._logger.d('Initializing PhotoSelfieView');
  }

  void _triggerSelfieCreation() {
    widget._logger.i('Checking if selfie can be triggered');
    context.read<NavigateCoreBloc>().add(const CheckSelfieCreationAccessEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Moved permission check here to safely access inherited widgets like Theme.of(context)
    if (!_cameraInitialized && _selfieAccessGranted) {
      _checkCameraPermission();
    }
  }

  // Check camera permission on initial load
  void _checkCameraPermission() {
    widget._logger.d('Checking camera permission');
    context.read<PhotoBloc>().add(CheckCameraPermission(
      cameraContext: widget.cameraContext,
      context: context,
      onClose: () {
        widget._logger.i('Camera permission check failed, navigating to WearOutfit');
        _navigateToWearOutfit(context);
      },
      theme: Theme.of(context),  // Safe to access Theme here
    ));
  }

  // Detect app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !_cameraInitialized) {
      // App has resumed, check permissions again only if camera is not initialized
      widget._logger.d('App resumed, checking camera permission again');
      _checkCameraPermission();
    }
  }

  // Handle camera initialization
  void _handleCameraInitialized() {
    widget._logger.d('Camera initialized');
    _cameraInitialized = true; // Set the flag to true when the camera is initialized
  }

  // Use CameraPermissionHelper to handle camera permission
  void _handleCameraPermission(BuildContext context) {
    widget._logger.d('Handling camera permission');
    _cameraPermissionHelper.checkAndRequestPermission(
      context: context,
      theme: Theme.of(context),
      cameraContext: widget.cameraContext,
      onClose: () {
        widget._logger.i('Permission handling closed, navigating to WearOutfit');
        _navigateToWearOutfit(context);
      },
    );
  }

  // Navigate to Wear Outfit route
  void _navigateToWearOutfit(BuildContext context) {
    widget._logger.d('Navigating to Wear Outfit');
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.wearOutfit,
        arguments: widget.outfitId);
  }

  @override
  void dispose() {
    widget._logger.i('Disposing PhotoSelfieView');
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    _photoBloc.close(); // Close the BLoC stream
    _navigateCoreBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget._logger.d('Building PhotoSelfieView'); // Log when the widget is built

    return Theme(
      data: myOutfitTheme, // Apply your custom theme here
      child: Scaffold(
        body: MultiBlocListener(
          listeners: [
            // NavigateCoreBloc Listener
            BlocListener<NavigateCoreBloc, NavigateCoreState>(
              listener: (context, state) {
                if (state is BronzeSelfieDeniedState) {
                  widget._logger.i('Bronze selfie access denied, navigating to payment screen.');
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.payment,
                    arguments: {
                      'featureKey': FeatureKey.selfieBronze,  // Pass necessary data
                      'isFromMyCloset': true,
                      'previousRoute': AppRoutes.wearOutfit,
                      'nextRoute': AppRoutes.selfiePhoto,
                      'outfitId': widget.outfitId,  // Use outfitId or other identifier
                    },
                  );
                } else if (state is SilverSelfieDeniedState) {
                  widget._logger.i('Silver selfie access denied, navigating to payment screen');
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.payment,
                    arguments: {
                      'featureKey': FeatureKey.selfieSilver,
                      'isFromMyCloset': true,
                      'previousRoute': AppRoutes.wearOutfit,
                      'nextRoute': AppRoutes.selfiePhoto,
                      'outfitId': widget.outfitId,
                    },
                  );
                } else if (state is GoldSelfieDeniedState) {
                  widget._logger.i('Gold selfie access denied, navigating to payment screen');
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.payment,
                    arguments: {
                      'featureKey': FeatureKey.selfieGold,
                      'isFromMyCloset': true,
                      'previousRoute': AppRoutes.wearOutfit,
                      'nextRoute': AppRoutes.selfiePhoto,
                      'outfitId': widget.outfitId,
                    },
                  );
                } else if (state is ItemAccessGrantedState) {
                  widget._logger.w('User has selfie access');
                  _selfieAccessGranted = true;  // Set selfie access flag
                  widget._logger.d('Selfie access flag set: $_selfieAccessGranted');

                  // Now that access is granted, trigger camera permission check
                  if (!_cameraInitialized) {
                    _checkCameraPermission();  // Trigger camera permission only after access granted
                  }
                } else if (state is ItemAccessErrorState) {
                  widget._logger.e('Error checking selfie access');
                  // Handle error state
                }
              },
            ),

            // PhotoBloc Listener
            BlocListener<PhotoBloc, PhotoState>(
              listener: (context, state) {
                if (state is CameraPermissionDenied) {
                  widget._logger.w('Camera permission denied');
                  _handleCameraPermission(context); // Delegate permission handling to CameraPermissionHelper
                } else if (state is CameraPermissionGranted && !_cameraInitialized) {
                  widget._logger.i('Camera permission granted, ready to capture photo');
                  _handleCameraInitialized(); // Mark camera as initialized
                  if (widget.outfitId != null) {
                    context.read<PhotoBloc>().add(CaptureSelfiePhoto(widget.outfitId!));  // Use '!' to assert it's not null
                  } else {
                    widget._logger.e('Outfit ID is null. Cannot capture selfie.');
                    _navigateToWearOutfit(context);  // Handle the error by navigating back or showing a message
                  }
                } else if (state is PhotoCaptureFailure) {
                  widget._logger.e('Photo capture failed');
                  _navigateToWearOutfit(context);
                } else if (state is SelfieCaptureSuccess) {
                  widget._logger.i('Photo upload succeeded with outfitId: ${state.outfitId}');
                  _navigateToWearOutfit(context);
                }
              },
            ),
          ],
          child: BlocBuilder<PhotoBloc, PhotoState>(
            builder: (context, state) {
              if (state is PhotoCaptureInProgress) {
                widget._logger.d('Photo capture in progress');
                return OutfitProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  size: 24.0,
                );
              } else if (state is CameraPermissionGranted && !_cameraInitialized) {
                widget._logger.d('Camera permission granted, capturing photo...');
                return OutfitProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  size: 24.0,
                );
              } else {
                widget._logger.d('Waiting for camera permission...');
                return OutfitProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                  size: 24.0,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
