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

  // Constructor accepting the context (either item or selfie)
  PhotoEditItemScreen({
    super.key,
    required this.cameraContext,
    this.itemId});

  @override
  PhotoEditItemScreenState createState() => PhotoEditItemScreenState();
}

late PhotoBloc _photoBloc;
late NavigateCoreBloc _navigateCoreBloc;
late CameraPermissionHelper _cameraPermissionHelper;

class PhotoEditItemScreenState extends State<PhotoEditItemScreen> with WidgetsBindingObserver {
  bool _cameraInitialized = false; // Track if the camera has been initialized
  bool _editAccessGranted = false; // Track if edit access is granted

  @override
  void initState() {
    super.initState();
    _photoBloc = context.read<PhotoBloc>(); // Access the bloc here safely
    _navigateCoreBloc = context.read<NavigateCoreBloc>(); // Access the bloc here safely
    _triggerEditItemCreation();
    _cameraPermissionHelper = CameraPermissionHelper(); // Initialize CameraPermissionHelper
    WidgetsBinding.instance.addObserver(this); // Add lifecycle observer
    widget._logger.d('Initializing PhotoEditItemScreen');
  }

  void _triggerEditItemCreation() {
    widget._logger.i('Checking if edit item can be triggered');
    context.read<NavigateCoreBloc>().add(const CheckEditItemCreationAccessEvent());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Moved permission check here to safely access inherited widgets like Theme.of(context)
    if (!_cameraInitialized && _editAccessGranted) {
      _checkCameraPermission();
    }
  }

  // Check camera permission on initial load
  void _checkCameraPermission() {
    widget._logger.d('Checking camera permission');
    context.read<PhotoBloc>().add(CheckCameraPermission(
      cameraContext: widget.cameraContext,
      context: context,
      onClose: () {
        widget._logger.i('Camera permission check failed, navigating to EditItem');
        _navigateToEditItem(context);
      },
      theme: Theme.of(context),  // Safe to access Theme here
    ));
  }

  // Detect app lifecycle changes
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !_cameraInitialized) {
      // App has resumed, check permissions again only if camera is not initialized
      widget._logger.d('App resumed, checking camera permission again');
      _checkCameraPermission();
    }
  }

  // Handle camera initialization
  void _handleCameraInitialized() {
    widget._logger.d('Camera initialized');
    _cameraInitialized = true; // Set the flag to true when the camera is initialized
  }

  // Use CameraPermissionHelper to handle camera permission
  void _handleCameraPermission(BuildContext context) {
    widget._logger.d('Handling camera permission');
    _cameraPermissionHelper.checkAndRequestPermission(
      context: context,
      theme: Theme.of(context),
      cameraContext: widget.cameraContext,
      onClose: () {
        widget._logger.i('Permission handling closed, navigating to EditItem');
        _navigateToEditItem(context);
      },
    );
  }

  // Navigate to Edit Item route
  void _navigateToEditItem(BuildContext context) {
    widget._logger.d('Navigating to Edit Item');
    Navigator.pushReplacementNamed(
        context,
        AppRoutes.editItem,
        arguments: widget.itemId);
  }

  // Navigate to Edit Item route
  void _navigateToMyCloset(BuildContext context) {
    widget._logger.d('Navigating to Edit Item');
    Navigator.pushReplacementNamed(
        context,
        AppRoutes.myCloset);
  }

  @override
  void dispose() {
    widget._logger.i('Disposing PhotoEditItemView');
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    _photoBloc.close(); // Close the BLoC stream
    _navigateCoreBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget._logger.d('Building PhotoEditItemView'); // Log when the widget is built

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<NavigateCoreBloc, NavigateCoreState>(
            listener: (context, state) {
              if (state is BronzeEditItemDeniedState) {
                widget._logger.i('Bronze edit item access denied, navigating to payment screen.');
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.payment,
                  arguments: {
                    'featureKey': FeatureKey.editItemBronze,  // Pass necessary data
                    'isFromMyCloset': true,
                    'previousRoute': AppRoutes.editItem,
                    'nextRoute': AppRoutes.editPhoto,
                    'itemId': widget.itemId,
                  },
                );
              } else if (state is SilverEditItemDeniedState) {
                widget._logger.i('Silver edit item access denied, navigating to payment screen');
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.payment,
                  arguments: {
                    'featureKey': FeatureKey.editItemSilver,
                    'isFromMyCloset': true,
                    'previousRoute': AppRoutes.editItem,
                    'nextRoute': AppRoutes.editPhoto,
                    'itemId': widget.itemId,
                  },
                );
              } else if (state is GoldEditItemDeniedState) {
                widget._logger.i('Gold edit item access denied, navigating to payment screen');
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.payment,
                  arguments: {
                    'featureKey': FeatureKey.editItemGold,
                    'isFromMyCloset': true,
                    'previousRoute': AppRoutes.editItem,
                    'nextRoute': AppRoutes.editPhoto,
                    'itemId': widget.itemId,
                  },
                );
              } else if (state is ItemAccessGrantedState) {
                widget._logger.w('User has edit access');
                _editAccessGranted = true;  // Set upload access flag
                widget._logger.d('Upload access flag set: $_editAccessGranted');

                // Now that access is granted, trigger camera permission check
                if (!_cameraInitialized) {
                  _checkCameraPermission();  // Trigger camera permission only after access granted
                }
              } else if (state is ItemAccessErrorState) {
                widget._logger.e('Error checking edit access');
                // Handle error state
              }
            },
          ),
          BlocListener<PhotoBloc, PhotoState>(
            listener: (context, state) {
              if (state is CameraPermissionDenied) {
                widget._logger.w('Camera permission denied');
                _handleCameraPermission(context); // Delegate permission handling to CameraPermissionHelper
              } else if (state is CameraPermissionGranted && !_cameraInitialized) {
                widget._logger.i('Camera permission granted, ready to capture photo');
                _handleCameraInitialized(); // Mark camera as initialized
                if (widget.itemId != null) {
                  context.read<PhotoBloc>().add(CaptureEditItemPhoto(widget.itemId!));  // Use '!' to assert it's not null
                } else {
                  widget._logger.e('Item ID is null. Cannot capture EditItem.');
                  _navigateToEditItem(context);  // Handle the error by navigating back or showing a message
                }
              } else if (state is PhotoCaptureFailure) {
                widget._logger.e('Photo capture failed');
                _navigateToEditItem(context);
              } else if (state is EditItemCaptureSuccess) {
                widget._logger.i('Photo upload succeeded with outfitId: ${state.itemId}');
                _navigateToMyCloset(context);
              }
            },
          ),
        ],
        child: BlocBuilder<PhotoBloc, PhotoState>(
          builder: (context, state) {
            if (state is PhotoCaptureInProgress) {
              widget._logger.d('Photo capture in progress');
              return ClosetProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                size: 24.0,
              );
            } else if (state is CameraPermissionGranted && !_cameraInitialized) {
              widget._logger.d('Camera permission granted, capturing photo...');
              return ClosetProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                size: 24.0,
              );
            } else {
              widget._logger.d('Waiting for camera permission...');
              return ClosetProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
                size: 24.0,
              );
            }
          },
        ),
      ),
    );
  }
}
