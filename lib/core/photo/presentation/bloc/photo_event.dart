part of 'photo_bloc.dart';

abstract class PhotoEvent {}

class CheckCameraPermission extends PhotoEvent {
  final BuildContext context;
  final ThemeData theme;
  final CameraPermissionContext cameraContext;
  final VoidCallback onClose;

  CheckCameraPermission({
    required this.context,
    required this.theme,
    required this.cameraContext,
    required this.onClose,
  });
}

class RequestCameraPermission extends PhotoEvent {
  final BuildContext context;
  final ThemeData theme;
  final CameraPermissionContext cameraContext;
  final VoidCallback onClose;

  RequestCameraPermission({
    required this.context,
    required this.theme,
    required this.cameraContext,
    required this.onClose,
  });
}

class CapturePhoto extends PhotoEvent {}
