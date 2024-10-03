import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/photo_bloc.dart';
import '../../../../navigation/presentation/bloc/navigate_core_bloc.dart';
import '../../widgets/camera_permission_helper.dart';
import '../../../../core_enums.dart';
import '../../../../utilities/routes.dart';
import '../../../../utilities/logger.dart';
import '../../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../paywall/data/feature_key.dart';


class PhotoUploadItemScreen extends StatefulWidget {
  final CameraPermissionContext cameraContext;
  final CustomLogger _logger = CustomLogger('PhotoUploadItemScreen'); // Instantiate the logger

  // Constructor accepting the context (either item or selfie)
  PhotoUploadItemScreen({super.key, required this.cameraContext});

  @override
  PhotoUploadItemScreenState createState() => PhotoUploadItemScreenState();
}

late PhotoBloc _photoBloc;
late NavigateCoreBloc _navigateCoreBloc;
late CameraPermissionHelper _cameraPermissionHelper;

class PhotoUploadItemScreenState extends State<PhotoUploadItemScreen> with WidgetsBindingObserver {
  bool _cameraInitialized = false; // Track if the camera has been initialized
  bool _uploadAccessGranted = false; // Track if upload access is granted

  @override
  void initState() {
    super.initState();
    _photoBloc = context.read<PhotoBloc>(); // Access the bloc here safely
    _navigateCoreBloc = context.read<NavigateCoreBloc>(); // Access the bloc here safely
    _triggerUploadItemCreation();
    _cameraPermissionHelper = CameraPermissionHelper(); // Initialize CameraPermissionHelper
    WidgetsBinding.instance.addObserver(this); // Add lifecycle observer
    widget._logger.d('Initializing PhotoUploadItemView');
  }

  void _triggerUploadItemCreation() {
    widget._logger.i('Checking if upload item can be triggered');
    context.read<NavigateCoreBloc>().add(const CheckUploadItemCreationAccessEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only check camera permission if upload access has been granted
    if (!_cameraInitialized && _uploadAccessGranted) {
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
        widget._logger.i('Camera permission check failed, navigating to MyCloset');
        _navigateToMyCloset(context);
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
        widget._logger.i('Permission handling closed, navigating to MyCloset');
        _navigateToMyCloset(context);
      },
    );
  }

  // Navigate to MyCloset route
  void _navigateToMyCloset(BuildContext context) {
    widget._logger.d('Navigating to MyCloset');
    Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
  }

  // Now you can safely check if the widget is mounted
  void _navigateToUploadItem(BuildContext context, String imageUrl) {
    widget._logger.d('Preparing to navigate to UploadItem with imageUrl: $imageUrl');

    if (mounted) {
      widget._logger.d('Navigating to UploadItem with imageUrl: $imageUrl');
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.uploadItem,
        arguments: imageUrl,
      );
      widget._logger.d('Navigation call successful, Image URL: $imageUrl');
    } else {
      widget._logger.e("Unable to navigate, widget is not mounted");
    }
  }



  @override
  void dispose() {
    widget._logger.i('Disposing PhotoUploadItemView');
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    _photoBloc.close(); // Close the BLoC stream
    _navigateCoreBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget._logger.d('Building PhotoUploadItemView'); // Log when the widget is built

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<NavigateCoreBloc, NavigateCoreState>(
            listener: (context, state) {
              if (state is BronzeUploadItemDeniedState) {
                widget._logger.i('Bronze upload item access denied, navigating to payment screen.');
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.payment,
                  arguments: {
                    'featureKey': FeatureKey.uploadItemBronze,  // Pass necessary data
                    'isFromMyCloset': true,
                    'previousRoute': AppRoutes.myCloset,
                    'nextRoute': AppRoutes.uploadItemPhoto
                  },
                );
              } else if (state is SilverUploadItemDeniedState) {
                widget._logger.i('Silver upload item access denied, navigating to payment screen');
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.payment,
                  arguments: {
                    'featureKey': FeatureKey.uploadItemSilver,  // Pass necessary data
                    'isFromMyCloset': true,
                    'previousRoute': AppRoutes.myCloset,
                    'nextRoute': AppRoutes.uploadItemPhoto
                  },
                );
              } else if (state is GoldUploadItemDeniedState) {
                widget._logger.i('Gold upload item access denied, navigating to payment screen');
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.payment,
                  arguments: {
                    'featureKey': FeatureKey.uploadItemGold,  // Pass necessary data
                    'isFromMyCloset': true,
                    'previousRoute': AppRoutes.myCloset,
                    'nextRoute': AppRoutes.uploadItemPhoto
                  },
                );
              } else if (state is ItemAccessGrantedState) {
                widget._logger.w('User has no upload access');
                _uploadAccessGranted = true;  // Set upload access flag
                widget._logger.d('Upload access flag set: $_uploadAccessGranted');

                // Now that access is granted, trigger camera permission check
                if (!_cameraInitialized) {
                  _checkCameraPermission();  // Trigger camera permission only after access granted
                }
              } else if (state is ItemAccessErrorState) {
                widget._logger.e('Error checking upload access');
                // Handle error state
              }
            },
          ),
          BlocListener<PhotoBloc, PhotoState>(
            listener: (context, state) {
              if (state is CameraPermissionDenied) {
                widget._logger.w('Camera permission denied');
                _handleCameraPermission(context); // Delegate permission handling to CameraPermissionHelper
              } else if (state is CameraPermissionGranted && !_cameraInitialized) {
                widget._logger.i('Camera permission granted, ready to capture photo');
                _handleCameraInitialized(); // Mark camera as initialized
                context.read<PhotoBloc>().add(CapturePhoto());
              } else if (state is PhotoCaptureFailure) {
                widget._logger.e('Photo capture failed');
                _navigateToMyCloset(context);
              } else if (state is PhotoCaptureSuccess) {
                widget._logger.i('Photo upload succeeded with URL: ${state.imageUrl}');
                _navigateToUploadItem(context, state.imageUrl);
              }
            },
          ),
        ],
        child: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (context, state) {
            if (state is PhotoCaptureInProgress) {
              widget._logger.d('Photo capture in progress');
              return ClosetProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                size: 24.0,
              );
            } else if (state is CameraPermissionGranted && !_cameraInitialized) {
              widget._logger.d('Camera permission granted, capturing photo...');
              return ClosetProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                size: 24.0,
              );
            } else {
              widget._logger.d('Waiting for camera permission...');
              return ClosetProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                size: 24.0,
              );
            }
          },
        ),
      ),
    );
  }
}
