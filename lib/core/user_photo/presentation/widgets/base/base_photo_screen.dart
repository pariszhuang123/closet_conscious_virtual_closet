import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/photo_bloc.dart';
import '../../../../paywall/presentation/bloc/premium_feature_access_bloc/premium_feature_access_bloc.dart';
import '../../../../utilities/helper_functions/permission_helper/camera_permission_helper.dart';
import '../../../../utilities/logger.dart';
import '../../../../core_enums.dart';
import '../../../../utilities/helper_functions/navigate_once_helper.dart';

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
    extends State<T> with WidgetsBindingObserver, NavigateOnceHelper<T> {
  late final PhotoBloc photoBloc;
  late final PremiumFeatureAccessBloc premiumFeatureAccessBloc;
  late final CameraPermissionHelper cameraPermissionHelper;
  bool cameraInitialized = false;
  bool accessGranted = false;
  bool get autoTriggerAccessCheck => true;

  @override
  void initState() {
    super.initState();
    photoBloc = context.read<PhotoBloc>();
    premiumFeatureAccessBloc = context.read<PremiumFeatureAccessBloc>();
    cameraPermissionHelper = CameraPermissionHelper();

    if (autoTriggerAccessCheck) {
      widget.logger.i('🚀 Auto-triggering access check immediately');
      triggerAccessCheck();
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.logger.i('🕒 Delayed access check after first frame');
        triggerAccessCheck();
      });
    }
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
    if (state == AppLifecycleState.resumed
        && accessGranted
        && !cameraInitialized) {
      widget.logger.d('App resumed & access granted → rechecking camera');
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

  void navigateOnceTo(String routeName, {Object? extra}) {
    navigateOnce(() {
      widget.logger.i('Navigating once to $routeName with extra: $extra');
      context.goNamed(routeName, extra: extra);
    });
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
