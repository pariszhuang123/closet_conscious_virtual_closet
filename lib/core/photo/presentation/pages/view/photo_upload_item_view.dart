import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/photo_bloc.dart';
import '../../widgets/camera_permission_helper.dart';
import '../../../../utilities/permission_service.dart';
import '../../../../utilities/routes.dart';
import '../../../../utilities/logger.dart';
import '../../../../widgets/progress_indicator/closet_progress_indicator.dart';

class PhotoUploadItemView extends StatefulWidget {
  final CameraPermissionContext cameraContext;
  final CustomLogger _logger = CustomLogger('PhotoUploadItemView'); // Instantiate the logger

  // Constructor accepting the context (either item or selfie)
  PhotoUploadItemView({super.key, required this.cameraContext});

  @override
  PhotoUploadItemViewState createState() => PhotoUploadItemViewState();
}

late PhotoBloc _photoBloc;
late CameraPermissionHelper _cameraPermissionHelper;

class PhotoUploadItemViewState extends State<PhotoUploadItemView> with WidgetsBindingObserver {
  bool _cameraInitialized = false; // Track if the camera has been initialized

  @override
  void initState() {
    super.initState();
    _photoBloc = context.read<PhotoBloc>(); // Access the bloc here safely
    _cameraPermissionHelper = CameraPermissionHelper(); // Initialize CameraPermissionHelper
    WidgetsBinding.instance.addObserver(this); // Add lifecycle observer
    widget._logger.d('Initializing PhotoUploadItemView');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Moved permission check here to safely access inherited widgets like Theme.of(context)
    if (!_cameraInitialized) {
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget._logger.d('Building PhotoUploadItemView'); // Log when the widget is built

    return Scaffold(
      body: BlocListener<PhotoBloc, PhotoState>(
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
