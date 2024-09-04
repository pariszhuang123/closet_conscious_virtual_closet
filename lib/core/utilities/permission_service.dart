import 'package:flutter/material.dart'; // Use material.dart instead of cupertino.dart
import 'package:permission_handler/permission_handler.dart';
import '../../generated/l10n.dart';

enum CameraPermissionContext {
  item,
  selfie,
}


class PermissionService {
  // Check the status of a single permission
  Future<PermissionStatus> checkPermission(Permission permission) async {
    return await permission.status;
  }

  // Request a single permission
  Future<PermissionStatus> requestPermission(Permission permission) async {
    return await permission.request();
  }

  // Get permission explanation based on permission type and context
  String getPermissionExplanation(
      BuildContext context,
      Permission permission,
      {CameraPermissionContext? cameraContext}) {

    if (permission == Permission.camera) {
      switch (cameraContext) {
        case CameraPermissionContext.item:
          return S.of(context).camera_item_permission_explanation;
        case CameraPermissionContext.selfie:
          return S.of(context).camera_selfie_permission_explanation;
        default:
          return S.of(context).camera_permission_explanation; // General explanation if no context is provided
      }
    }

    return S.of(context).general_permission_explanation;
  }

}
