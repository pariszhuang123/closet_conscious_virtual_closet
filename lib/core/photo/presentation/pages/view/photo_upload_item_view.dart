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

class PhotoUploadItemViewState extends State<PhotoUploadItemView> {
  @override
  void initState() {
    super.initState();

    widget._logger.d('Initializing PhotoUploadItemView');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    widget._logger.d('Accessing theme and checking camera permission in didChangeDependencies');

    // Move the theme-dependent logic here
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

  @override
    Widget build(BuildContext context) {
    widget._logger.d('Building PhotoUploadItemView'); // Log when the widget is built
    
    return Scaffold(
      body: BlocListener<PhotoBloc, PhotoState>(
        listener: (context, state) {
          if (state is CameraPermissionDenied) {
            widget._logger.w('Camera permission denied');
            _handleCameraPermission(context);
          } else if (state is PhotoCaptureFailure) {
            widget._logger.e('Photo capture failed');
            _navigateToMyCloset(context);
          } else if (state is PhotoCaptureSuccess) {
            widget._logger.i('Photo upload succeeded with URL: ${state.imageUrl}');
            _navigateToUploadItem(context, state.imageUrl);
          } else if (state is CameraPermissionGranted) {
            widget._logger.i('Camera permission granted, ready to capture photo');
            context.read<PhotoBloc>().add(CapturePhoto());
          }
        },
        child: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (context, state) {
            if (state is PhotoCaptureInProgress) {
              widget._logger.d('Photo capture in progress');
              return ClosetProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
                size: 24.0,
              );
            } else if (state is CameraPermissionGranted) {
              widget._logger.d('Camera permission granted, capturing photo...');
              return const SizedBox.shrink(); // Placeholder
            } else {
              widget._logger.d('Waiting for camera permission...');
              return ClosetProgressIndicator(
                color: Theme.of(context).colorScheme.onPrimary,
                size: 24.0,
              );
            }
          },
        ),
      ),
    );
  }

  // Handle camera permission
  void _handleCameraPermission(BuildContext context) {
    widget._logger.d('Handling camera permission');
    CameraPermissionHelper().checkAndRequestPermission(
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
    context.read<PhotoBloc>().close(); // Close the BLoC stream
    super.dispose();
  }
}
