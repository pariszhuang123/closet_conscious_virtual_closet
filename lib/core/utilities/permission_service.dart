import 'package:flutter/material.dart'; // Use material.dart instead of cupertino.dart
import 'package:permission_handler/permission_handler.dart';
import '../../generated/l10n.dart';
import '../../core/utilities/logger.dart'; // Import CustomLogger
import '../core_enums.dart';

class PermissionService {
  final CustomLogger _logger = CustomLogger(
      'PermissionService'); // Initialize CustomLogger

  // Check the status of a single permission
  Future<PermissionStatus> checkPermission(Permission permission) async {
    _logger.i('Checking status for permission: ${permission.toString()}');
    PermissionStatus status = await permission.status;
    _logger.d('Permission status: $status');
    return status;
  }

  // Request permission for Camera or Photo Library
  Future<PermissionStatus> requestPermission(Permission permission) async {
    _logger.i('Requesting permission: ${permission.toString()}');
    PermissionStatus status = await permission.request();
    _logger.d('Permission request status: $status');
    return status;
  }

  // Get permission explanation based on permission type and context
  String getPermissionExplanation(BuildContext context,
      Permission permission,
      {CameraPermissionContext? cameraContext}) {
    _logger.i('Getting explanation for permission: ${permission.toString()}');

    String explanation;

    if (permission == Permission.camera) {
      switch (cameraContext) {
        case CameraPermissionContext.uploadItem:
          explanation = S
              .of(context)
              .camera_upload_item_permission_explanation;
          break;
        case CameraPermissionContext.editItem:
          explanation = S
              .of(context)
              .camera_edit_item_permission_explanation;
          break;
        case CameraPermissionContext.selfie:
          explanation = S
              .of(context)
              .camera_selfie_permission_explanation;
          break;
        default:
          explanation = S
              .of(context)
              .camera_permission_explanation; // General explanation if no context is provided
      }
    } else if (permission == Permission.photos) {
      explanation = S.of(context).photo_library_permission_explanation;
    } else {
      explanation = S
          .of(context)
          .general_permission_explanation;
    }

    // Return the explanation
    return explanation;
  }
}