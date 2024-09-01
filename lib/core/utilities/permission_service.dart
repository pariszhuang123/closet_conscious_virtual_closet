import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../generated/l10n.dart';


class PermissionService {
  Future<PermissionStatus> checkPermission(Permission permission) async {
    return await permission.status;
  }

  Future<PermissionStatus> requestPermission(Permission permission) async {
    return await permission.request();
  }

  Future<bool> openSettingsIfPermanentlyDenied(PermissionStatus status) async {
    if (status.isPermanentlyDenied) {
      return await openAppSettings();
    }
    return false;
  }

  String getPermissionExplanation(BuildContext context, Permission permission) {
    switch (permission) {
      case Permission.camera:
        return S.of(context).camera_permission_explanation;
      default:
        return S.of(context).general_permission_explanation;
    }
  }
}
