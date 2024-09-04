import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/photo_bloc.dart';
import '../../widgets/camera_permission_helper.dart';
import '../../../../utilities/permission_service.dart';
import '../../../../utilities/routes.dart';
import '../../../../utilities/logger.dart';

class PhotoUploadItemView extends StatelessWidget {
  final CameraPermissionContext cameraContext;
  final CustomLogger _logger = CustomLogger('PhotoUploadItemView'); // Instantiate the logger

  // Constructor accepting the context (either item or selfie)
  PhotoUploadItemView({super.key, required this.cameraContext});

  @override
  Widget build(BuildContext context) {
    _logger.d('Building PhotoUploadItemView'); // Log when the widget is built

    context.read<PhotoBloc>().add(CheckCameraPermission(
      cameraContext: cameraContext,
      context: context,
      onClose: () {
        _logger.i('Camera permission check failed, navigating to MyCloset');
        _navigateToMyCloset(context);
      },
      theme: Theme.of(context),
    ));

    return Scaffold(
      body: BlocListener<PhotoBloc, PhotoState>(
        listener: (context, state) {
          if (state is CameraPermissionDenied) {
            _logger.w('Camera permission denied');
            _handleCameraPermission(context);
          } else if (state is PhotoCaptureFailure) {
            _logger.e('Photo capture failed');
            _navigateToMyCloset(context);
          } else if (state is PhotoUploadSuccess) {
            _logger.i('Photo upload succeeded with URL: ${state.imageUrl}');
            _navigateToUploadItem(context, state.imageUrl);
          }
        },
        child: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (context, state) {
            if (state is PhotoCaptureInProgress) {
              _logger.d('Photo capture in progress');
              return const Center(child: CircularProgressIndicator());
            } else {
              _logger.d('Waiting for camera permission...');
              return const Center(
                child: Text('Waiting for item camera permission...'),
              );
            }
          },
        ),
      ),
    );
  }

  // Handle camera permission
  void _handleCameraPermission(BuildContext context) {
    _logger.d('Handling camera permission');
    CameraPermissionHelper().checkAndRequestPermission(
      context: context,
      theme: Theme.of(context),
      cameraContext: cameraContext,
      onClose: () {
        _logger.i('Permission handling closed, navigating to MyCloset');
        _navigateToMyCloset(context);
      },
    );
  }

  // Navigate to MyCloset route
  void _navigateToMyCloset(BuildContext context) {
    _logger.d('Navigating to MyCloset');
    Navigator.pushNamed(context, AppRoutes.myCloset);
  }

  // Navigate to UploadItem route
  void _navigateToUploadItem(BuildContext context, String imageUrl) {
    _logger.d('Navigating to UploadItem with imageUrl: $imageUrl');
    Navigator.pushNamed(
      context,
      AppRoutes.uploadItem,
      arguments: {
        'imageUrl': imageUrl,
      },
    );
  }
}
