// base_photo_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/photo_bloc.dart';
import '../../../../presentation/bloc/navigate_core_bloc/navigate_core_bloc.dart';
import '../../../../utilities/helper_functions/permission_helper/camera_permission_helper.dart';
import '../../../../utilities/logger.dart';
import '../../../../core_enums.dart';

abstract class BasePhotoScreen extends StatefulWidget {
  final CameraPermissionContext cameraContext;
  final CustomLogger logger;
  const BasePhotoScreen({
    super.key,
    required this.cameraContext,
    required this.logger,
  });
}

abstract class BasePhotoScreenState<T extends BasePhotoScreen>
    extends State<T> with WidgetsBindingObserver {
  late final PhotoBloc photoBloc;
  late final NavigateCoreBloc navigateCoreBloc;
  late final CameraPermissionHelper cameraPermissionHelper;
  bool cameraInitialized = false;
  bool accessGranted = false;

  @override
  void initState() {
    super.initState();
    photoBloc = context.read<PhotoBloc>();
    navigateCoreBloc = context.read<NavigateCoreBloc>();
    cameraPermissionHelper = CameraPermissionHelper();
    triggerAccessCheck(); // Abstract: screen-specific access event.
    WidgetsBinding.instance.addObserver(this);
    widget.logger.d('Initializing ${widget.runtimeType}');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!cameraInitialized && accessGranted) {
      widget.logger.d('Dependencies changed: checking camera permission');
      checkCameraPermission();
    }
  }

  void checkCameraPermission() {
    widget.logger.d('Dispatching CheckCameraPermission event');
    photoBloc.add(CheckOrRequestCameraPermission(
      cameraContext: widget.cameraContext,
      context: context,
      theme: Theme.of(context),
      onClose: onPermissionClose, // Abstract: screen-specific onClose.
    ));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !cameraInitialized) {
      widget.logger.d('App resumed, checking camera permission again');
      checkCameraPermission();
    }
  }

  void handleCameraInitialized() {
    widget.logger.d('Camera initialized');
    setState(() {
      cameraInitialized = true;
    });
  }

  void handleCameraPermission() {
    widget.logger.d('Handling camera permission');
    cameraPermissionHelper.checkAndRequestPermission(
      context: context,
      theme: Theme.of(context),
      cameraContext: widget.cameraContext,
      onClose: onPermissionClose,
    );
  }

  void navigateSafely(String routeName, {Object? arguments}) {
    if (mounted) {
      widget.logger.d('Navigating to $routeName with arguments: $arguments');
      Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
    } else {
      widget.logger.e("Cannot navigate to $routeName, widget is not mounted");
    }
  }

  @override
  void dispose() {
    widget.logger.i('Disposing ${widget.runtimeType}');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Abstract methods to implement in each subclass:
  void triggerAccessCheck(); // e.g. add event to check edit/selfie/upload access
  void onPermissionClose(); // what to do if permission check fails
  void onAccessGranted(); // set accessGranted flag and do any additional work
}
