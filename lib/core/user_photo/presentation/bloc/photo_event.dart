part of 'photo_bloc.dart';

abstract class PhotoEvent {}

class CheckOrRequestCameraPermission extends PhotoEvent {
  final BuildContext context;
  final ThemeData? theme;
  final CameraPermissionContext cameraContext;
  final VoidCallback onClose;

  CheckOrRequestCameraPermission({
    required this.context,
    this.theme,
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

class CaptureEditClosetPhoto extends PhotoEvent {
  final String closetId;

  CaptureEditClosetPhoto(this.closetId);
}
