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

class PhotoEditClosetScreen extends StatefulWidget {
  final CameraPermissionContext cameraContext;
  final String? closetId;
  final CustomLogger _logger = CustomLogger('PhotoEditClosetScreen');

  PhotoEditClosetScreen({
    super.key,
    required this.cameraContext,
    this.closetId,
  });

  @override
  PhotoEditClosetScreenState createState() => PhotoEditClosetScreenState();
}

class PhotoEditClosetScreenState extends State<PhotoEditClosetScreen> with WidgetsBindingObserver {
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
    _triggerEditClosetCreation();
    WidgetsBinding.instance.addObserver(this); // Add lifecycle observer
    widget._logger.d('Initializing PhotoEditClosetScreen');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_cameraInitialized && _editAccessGranted) {
      widget._logger.d('Dependencies changed: checking camera permission');
      _checkCameraPermission(); // Safe to call here
    }
  }

  void _checkCameraPermission() {
    widget._logger.d('Dispatching CheckCameraPermission event');
    _photoBloc.add(CheckOrRequestCameraPermission(
      cameraContext: widget.cameraContext,
      context: context,
      theme: Theme.of(context),
      onClose: () {
        widget._logger.i('Camera permission check failed, navigating to EditCloset');
        _navigateToEditCloset();
      },
    ));
  }

  void _triggerEditClosetCreation() {
    widget._logger.i('Checking if edit item can be triggered');
    _navigateCoreBloc.add(const CheckEditClosetCreationAccessEvent());
  }

  void _navigateSafely(String routeName, {Object? arguments}) {
    if (mounted) {
      widget._logger.d('Navigating to $routeName with arguments: $arguments');
      Navigator.pushReplacementNamed(context, routeName, arguments: arguments);
    } else {
      widget._logger.e("Cannot navigate to $routeName, widget is not mounted");
    }
  }

  void _navigateToEditCloset() {
    widget._logger.d('Navigating to Edit Item');
    _navigateSafely (
      AppRoutes.editMultiCloset
    );
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
        widget._logger.i('Permission handling closed, navigating to EditCloset');
        _navigateToEditCloset();
      },
    );
  }


  @override
  void dispose() {
    widget._logger.i('Disposing PhotoEditClosetScreen');
    WidgetsBinding.instance.removeObserver(this); // Remove lifecycle observer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widget._logger.d('Building PhotoEditClosetScreen');

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<NavigateCoreBloc, NavigateCoreState>(
            listener: (context, state) {
              if (state is BronzeEditClosetDeniedState) {
                widget._logger.i('Bronze edit item access denied, navigating to payment screen');
                _navigateSafely(
                  AppRoutes.payment,
                  arguments: {
                    'featureKey': FeatureKey.editClosetBronze,
                    'isFromMyCloset': true,
                    'previousRoute': AppRoutes.editMultiCloset,
                    'nextRoute': AppRoutes.myCloset,
                    'closetId': widget.closetId,
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
                    'closetId': widget.closetId,
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
                    'closetId': widget.closetId,
                  },
                );
              } else if (state is ClosetAccessGrantedState) {
                _editAccessGranted = true;
                widget._logger.d('Edit access granted: $_editAccessGranted');
                if (!_cameraInitialized) {
                  _checkCameraPermission(); // Trigger camera permission after access is granted
                }
              } else if (state is ClosetAccessErrorState) {
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
                if (widget.closetId != null) {
                  context.read<PhotoBloc>().add(CaptureEditClosetPhoto(widget.closetId!));
                } else {
                  widget._logger.e('Closet ID is null. Cannot capture Edit Closet.');
                  _navigateToEditCloset();
                }
              } else if (state is PhotoCaptureFailure) {
                widget._logger.e('Photo capture failed');
                _navigateToEditCloset();
              } else if (state is EditClosetCaptureSuccess) {
                widget._logger.i('Photo upload succeeded with closetId: ${state.closetId}');
                _navigateToEditCloset();
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
