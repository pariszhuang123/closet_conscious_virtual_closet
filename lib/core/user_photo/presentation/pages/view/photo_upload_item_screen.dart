import 'dart:io'; // Import for platform checks
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
  final CustomLogger _logger = CustomLogger('PhotoUploadItemScreen');

  PhotoUploadItemScreen({super.key, required this.cameraContext});

  @override
  PhotoUploadItemScreenState createState() => PhotoUploadItemScreenState();
}

class PhotoUploadItemScreenState extends State<PhotoUploadItemScreen> with WidgetsBindingObserver {
  late final PhotoBloc _photoBloc;
  late final NavigateCoreBloc _navigateCoreBloc;
  late CameraPermissionHelper _cameraPermissionHelper;
  bool _cameraInitialized = false;
  bool _uploadAccessGranted = false;

  @override
  void initState() {
    super.initState();
    _photoBloc = context.read<PhotoBloc>();
    _navigateCoreBloc = context.read<NavigateCoreBloc>();
    _cameraPermissionHelper = CameraPermissionHelper();
    _triggerUploadItemCreation();
    WidgetsBinding.instance.addObserver(this);
    widget._logger.d('Initializing PhotoUploadItemView');

    if (Platform.isIOS) {
      widget._logger.d('iOS: Checking camera permission upfront');
      _checkCameraPermissionIOS(); // Call iOS-specific permission check
    } else if (Platform.isAndroid) {
      widget._logger.d('Android: Deferring camera permission check');
      // Delay permission check until access is triggered
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_cameraInitialized && _uploadAccessGranted) {
      widget._logger.d('Dependencies changed: checking camera permission');
      _checkCameraPermission(); // Safe to call here
    }
  }

  void _checkCameraPermissionIOS() {
    widget._logger.d('Dispatching CheckCameraPermission event for iOS');
    _photoBloc.add(CheckCameraPermission(
      cameraContext: widget.cameraContext,
      context: context,
      onClose: _navigateToMyCloset,
    ));
  }

  void _checkCameraPermission() {
    widget._logger.d('Dispatching CheckCameraPermission event to PhotoBloc');
    _photoBloc.add(CheckCameraPermission(
      cameraContext: widget.cameraContext,
      context: context,
      theme: Theme.of(context),
      onClose: _navigateToMyCloset,
    ));
  }

  void _triggerUploadItemCreation() {
    widget._logger.i('Checking if upload item can be triggered');
    _navigateCoreBloc.add(const CheckUploadItemCreationAccessEvent());
  }

  void _navigateSafely(String routeName, {Object? arguments}) {
    if (mounted) {
      widget._logger.d('Navigating to $routeName with arguments: $arguments');
      Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
    } else {
      widget._logger.e("Cannot navigate to $routeName, widget is not mounted");
    }
  }

  void _navigateToMyCloset() {
    widget._logger.d('Navigating to MyCloset');
    _navigateSafely(AppRoutes.myCloset);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !_cameraInitialized) {
      widget._logger.d('App resumed on iOS, checking camera permission again');
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
        _navigateToMyCloset();
      },
    );
  }

  // Now you can safely check if the widgets is mounted
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
      widget._logger.e("Unable to navigate, widgets is not mounted");
    }
  }

  @override
  void dispose() {
    widget._logger.i('Disposing PhotoUploadItemView');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget._logger.d('Building PhotoUploadItemView');

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<NavigateCoreBloc, NavigateCoreState>(
            listener: (context, state) {
              if (state is BronzeUploadItemDeniedState) {
                _navigateSafely(AppRoutes.payment, arguments: {
                  'featureKey': FeatureKey.uploadItemBronze,
                  'isFromMyCloset': true,
                  'previousRoute': AppRoutes.myCloset,
                  'nextRoute': AppRoutes.uploadItemPhoto,
                });
              } else if (state is SilverUploadItemDeniedState) {
                _navigateSafely(AppRoutes.payment, arguments: {
                  'featureKey': FeatureKey.uploadItemSilver,
                  'isFromMyCloset': true,
                  'previousRoute': AppRoutes.myCloset,
                  'nextRoute': AppRoutes.uploadItemPhoto,
                });
              } else if (state is GoldUploadItemDeniedState) {
                _navigateSafely(AppRoutes.payment, arguments: {
                  'featureKey': FeatureKey.uploadItemGold,
                  'isFromMyCloset': true,
                  'previousRoute': AppRoutes.myCloset,
                  'nextRoute': AppRoutes.uploadItemPhoto,
                });
              } else if (state is ItemAccessGrantedState) {
                _uploadAccessGranted = true;
                widget._logger.d('Upload access flag set: $_uploadAccessGranted');
                if (!_cameraInitialized) {
                  _checkCameraPermission();
                }
              } else if (state is ItemAccessErrorState) {
                widget._logger.e('Error checking upload access');
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
                _navigateToMyCloset();
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
              return const ClosetProgressIndicator();
            } else if (state is CameraPermissionGranted && !_cameraInitialized) {
              widget._logger.d('Camera permission granted, capturing photo...');
              return const ClosetProgressIndicator();
            } else {
              widget._logger.d('Waiting for camera permission...');
              return const ClosetProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
