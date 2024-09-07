import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/photo_bloc.dart';
import '../../widgets/camera_permission_helper.dart';
import '../../../../utilities/permission_service.dart';
import '../../../../utilities/routes.dart';

class PhotoEditItemScreen extends StatelessWidget {
  final CameraPermissionContext cameraContext;

  // Constructor accepting the context (either item or selfie)
  const PhotoEditItemScreen({super.key, required this.cameraContext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<PhotoBloc, PhotoState>(
        listener: (context, state) {
          if (state is CameraPermissionDenied) {
            _handleCameraPermission(context);
          } else if (state is PhotoCaptureFailure) {
            _navigateToEditItem(context);
          } else if (state is PhotoCaptureSuccess) {
            _navigateToEditItem(context);
          }
        },
        child: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (context, state) {
            if (state is PhotoCaptureInProgress) {
              return const Center(child: CircularProgressIndicator());
            } else {
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
    CameraPermissionHelper().checkAndRequestPermission(
      context: context,
      theme: Theme.of(context),
      cameraContext: cameraContext,
      onClose: () { _navigateToEditItem(context); }, // Wrap the function in a closure
    );
  }

  // Navigate to EditOutfit route
  void _navigateToEditItem(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.editItem);
  }
}
