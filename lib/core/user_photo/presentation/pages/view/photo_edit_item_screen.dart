import 'dart:io'; // Import for platform checks
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/photo_bloc.dart';
import '../../../../navigation/presentation/bloc/navigate_core_bloc.dart';
import '../../widgets/camera_permission_helper.dart';
import '../../../../core_enums.dart';
import '../../../../utilities/routes.dart';
import '../../../../utilities/logger.dart';
import '../../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../paywall/data/feature_key.dart';

class PhotoEditItemScreen extends StatefulWidget {
  final CameraPermissionContext cameraContext;
  final String? itemId;
  final CustomLogger _logger = CustomLogger('PhotoEditItemScreen');

  PhotoEditItemScreen({
    super.key,
    required this.cameraContext,
    this.itemId,
  });

  @override
  PhotoEditItemScreenState createState() => PhotoEditItemScreenState();
}

class PhotoEditItemScreenState extends State<PhotoEditItemScreen> with WidgetsBindingObserver {
  late final PhotoBloc _photoBloc;
  late final NavigateCoreBloc _navigateCoreBloc;
  late final CameraPermissionHelper _cameraPermissionHelper;
  bool _cameraInitialized = false; // Track if the camera has been initialized
  bool _editAccessGranted = false; // Track if edit access is granted

  @override
  void initState() {
    super.initState();
    _photoBloc = context.read<PhotoBloc>();
    _navigateCoreBloc = context.read<NavigateCoreBloc>();
    _cameraPermissionHelper = CameraPermissionHelper(); // Initialize CameraPermissionHelper
    _triggerEditItemCreation();
    WidgetsBinding.instance.addObserver(this); // Add lifecycle observer
    widget._logger.d('Initializing PhotoEditItemScreen');

    // Platform-specific permission check
    if (Platform.isIOS) {
      widget._logger.d('iOS: Checking camera permission at startup');
      _checkCameraPermissionIOS();
    } else if (Platform.isAndroid) {
      widget._logger.d('Android: Delaying camera permission check');
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_cameraInitialized && _editAccessGranted) {
      widget._logger.d('Dependencies changed: checking camera permission');
      _checkCameraPermission(); // Safe to call here
    }
  }

  void _checkCameraPermissionIOS() {
    widget._logger.d('Dispatching CheckCameraPermission event for iOS');
    _photoBloc.add(CheckCameraPermission(
      cameraContext: widget.cameraContext,
      context: context,
      onClose: _navigateToEditItem,
    ));
  }

  void _checkCameraPermission() {
    widget._logger.d('Dispatching CheckCameraPermission event');
    _photoBloc.add(CheckCameraPermission(
      cameraContext: widget.cameraContext,
      context: context,
      theme: Theme.of(context),
      onClose: () {
        widget._logger.i('Camera permission check failed, navigating to EditItem');
        _navigateToEditItem();
      },
    ));
  }

  void _triggerEditItemCreation() {
    widget._logger.i('Checking if edit item can be triggered');
    _navigateCoreBloc.add(const CheckEditItemCreationAccessEvent());
  }

  void _navigateSafely(String routeName, {Object? arguments}) {
    if (mounted) {
      widget._logger.d('Navigating to $routeName with arguments: $arguments');
      Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
    } else {
      widget._logger.e("Cannot navigate to $routeName, widget is not mounted");
    }
  }

  void _navigateToEditItem() {
    widget._logger.d('Navigating to Edit Item');
    _navigateSafely (
      AppRoutes.editItem,
      arguments: widget.itemId,
    );
  }

  void _navigateToMyCloset() {
    widget._logger.d('Navigating to MyCloset');
    _navigateSafely (AppRoutes.myCloset);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !_cameraInitialized) {
      widget._logger.d('App resumed, checking camera permission again');
      _checkCameraPermission();
    }
  }

  void _handleCameraInitialized() {
    widget._logger.d('Camera initialized');
    _cameraInitialized = true;
  }

  void _handleCameraPermission(BuildContext context) {
    widget._logger.d('Handling camera permission');
    _cameraPermissionHelper.checkAndRequestPermission(
      context: context,
      theme: Theme.of(context),
      cameraContext: widget.cameraContext,
      onClose: () {
        widget._logger.i('Permission handling closed, navigating to EditItem');
        _navigateToEditItem();
      },
    );
  }


  @override
  void dispose() {
    widget._logger.i('Disposing PhotoEditItemScreen');
    WidgetsBinding.instance.removeObserver(this); // Remove lifecycle observer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget._logger.d('Building PhotoEditItemScreen');

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<NavigateCoreBloc, NavigateCoreState>(
            listener: (context, state) {
              if (state is BronzeEditItemDeniedState) {
                widget._logger.i('Bronze edit item access denied, navigating to payment screen');
                _navigateSafely(
                  AppRoutes.payment,
                  arguments: {
                    'featureKey': FeatureKey.editItemBronze,
                    'isFromMyCloset': true,
                    'previousRoute': AppRoutes.editItem,
                    'nextRoute': AppRoutes.myCloset,
                    'itemId': widget.itemId,
                  },
                );
              } else if (state is SilverEditItemDeniedState) {
                widget._logger.i('Silver edit item access denied, navigating to payment screen');
                _navigateSafely(
                  AppRoutes.payment,
                  arguments: {
                    'featureKey': FeatureKey.editItemSilver,
                    'isFromMyCloset': true,
                    'previousRoute': AppRoutes.editItem,
                    'nextRoute': AppRoutes.myCloset,
                    'itemId': widget.itemId,
                  },
                );
              } else if (state is GoldEditItemDeniedState) {
                widget._logger.i('Gold edit item access denied, navigating to payment screen');
                _navigateSafely(
                  AppRoutes.payment,
                  arguments: {
                    'featureKey': FeatureKey.editItemGold,
                    'isFromMyCloset': true,
                    'previousRoute': AppRoutes.editItem,
                    'nextRoute': AppRoutes.myCloset,
                    'itemId': widget.itemId,
                  },
                );
              } else if (state is ItemAccessGrantedState) {
                _editAccessGranted = true;
                widget._logger.d('Edit access granted: $_editAccessGranted');
                if (!_cameraInitialized) {
                  _checkCameraPermission(); // Trigger camera permission after access is granted
                }
              } else if (state is ItemAccessErrorState) {
                widget._logger.e('Error checking edit access');
              }
            },
          ),
          BlocListener<PhotoBloc, PhotoState>(
            listener: (context, state) {
              if (state is CameraPermissionDenied) {
                widget._logger.w('Camera permission denied');
                _handleCameraPermission(context);
              } else if (state is CameraPermissionGranted && !_cameraInitialized) {
                _handleCameraInitialized();
                if (widget.itemId != null) {
                  context.read<PhotoBloc>().add(CaptureEditItemPhoto(widget.itemId!));
                } else {
                  widget._logger.e('Item ID is null. Cannot capture EditItem.');
                  _navigateToEditItem();
                }
              } else if (state is PhotoCaptureFailure) {
                widget._logger.e('Photo capture failed');
                _navigateToEditItem();
              } else if (state is EditItemCaptureSuccess) {
                widget._logger.i('Photo upload succeeded with itemId: ${state.itemId}');
                _navigateToMyCloset();
              }
            },
          ),
        ],
        child: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (context, state) {
            if (state is PhotoCaptureInProgress || (state is CameraPermissionGranted && !_cameraInitialized)) {
              return const ClosetProgressIndicator();
            } else {
              widget._logger.d('Waiting for camera permission...');
              return const ClosetProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
