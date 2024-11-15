part of 'photo_bloc.dart';

abstract class PhotoEvent {}

class CheckCameraPermission extends PhotoEvent {
  final BuildContext context;
  final ThemeData? theme;
  final CameraPermissionContext cameraContext;
  final VoidCallback onClose;

  CheckCameraPermission({
    required this.context,
    this.theme,
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

class CaptureSelfiePhoto extends PhotoEvent {
  final String outfitId;

  CaptureSelfiePhoto(this.outfitId);
}

class CaptureEditItemPhoto extends PhotoEvent {
  final String itemId;

  CaptureEditItemPhoto(this.itemId);
}
