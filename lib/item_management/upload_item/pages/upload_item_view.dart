import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/data/type_data.dart';
import '../../../core/photo/presentation/widgets/image_display_widget.dart';
import '../../../core/usecase/photo_capture_service.dart';
import '../../../core/utilities/routes.dart';
import '../../../generated/l10n.dart';
import '../presentation/bloc/upload_item_bloc.dart';
import '../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../core/widgets/bottom_sheet/metadata_premium_bottom_sheet.dart';
import '../../../core/theme/themed_svg.dart';
import '../../../core/widgets/button/navigation_type_button.dart';
import '../../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../core/utilities/permission_service.dart';
import '../../../core/photo/presentation/widgets/camera_item_permission_helper.dart';
import '../../../core/utilities/logger.dart';
import 'metadata/metadata_first_page.dart';
import 'metadata/metadata_second_page.dart';
import 'metadata/metadata_third_page.dart';

class UploadItemView extends StatefulWidget {
  final ThemeData myClosetTheme;

  const UploadItemView({super.key, required this.myClosetTheme});

  @override
  State<UploadItemView> createState() => _UploadItemViewState();
}

class _UploadItemViewState extends State<UploadItemView> with WidgetsBindingObserver {
  final _itemNameController = TextEditingController();
  final _amountSpentController = TextEditingController();
  File? _imageFile;
  String? _imageUrl;
  String? selectedItemType;
  String? selectedSpecificType;
  String? selectedClothingLayer;
  String? _amountSpentError;

  String? selectedOccasion;
  String? selectedSeason;
  String? selectedColour;
  String? selectedColourVariation;

  final PageController _pageController = PageController();
  final PermissionService _permissionService = PermissionService();
  final CustomLogger _logger = CustomLogger('UploadItemView'); // Initialize CustomLogger

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _logger.i('UploadItemView initialized');
    context.read<UploadItemBloc>().add(CheckCameraPermission());
    WidgetsBinding.instance.addObserver(this); // Add observer for lifecycle events
  }

  @override
  void dispose() {
    _logger.i('Disposing UploadItemView');
    _disposeResources(); // Ensure resources are cleaned up
    super.dispose();
  }

  void _disposeResources() {
    _itemNameController.dispose();
    _amountSpentController.dispose();
    _pageController.dispose();
    WidgetsBinding.instance.removeObserver(this); // Remove the observer

  }

  void _navigateToMyCloset(BuildContext context) {
    if (mounted) {
      _disposeResources(); // Dispose safely
      Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _logger.i('App lifecycle state changed: $state');
    if (state == AppLifecycleState.resumed) {
      _logger.i('App resumed, checking camera permission');
      context.read<UploadItemBloc>().add(CheckCameraPermission()); // Re-check permission on resume
    }
  }

  Future<void> _capturePhoto() async {
    _logger.i('Capturing photo');
    final PhotoCaptureService photoCaptureService = PhotoCaptureService();

    File? resizedImageFile = await photoCaptureService.captureAndResizePhoto();

    if (resizedImageFile != null) {
      _logger.i('Photo captured and resized successfully');
      setState(() {
        _imageFile = resizedImageFile;
        _imageUrl = _imageFile!.path;
      });
    } else {
      _logger.w('Photo capture failed or was canceled');
      if (mounted) {
        _navigateToMyCloset(context);
      }
    }
  }

  void _handleNext(BuildContext context) {
    _logger.i('Handling next button press, current page: $_currentPage');
    final uploadBloc = context.read<UploadItemBloc>();

    if (_currentPage == 0) {
      _logger.i('Validating form on page 1');
      uploadBloc.add(ValidateFormPage1(
        itemName: _itemNameController.text.trim(),
        amountSpentText: _amountSpentController.text,
        selectedItemType: selectedItemType,
        selectedOccasion: selectedOccasion,
      ));
    } else if (_currentPage == 1) {
      _logger.i('Validating form on page 2');
      uploadBloc.add(ValidateFormPage2(
        selectedSeason: selectedSeason,
        selectedSpecificType: selectedSpecificType,
        selectedItemType: selectedItemType,
        selectedClothingLayer: selectedClothingLayer,
      ));
    } else if (_currentPage == 2) {
      _logger.i('Validating form on page 3');
      uploadBloc.add(ValidateFormPage3(
        selectedColour: selectedColour,
        selectedColourVariation: selectedColourVariation,
      ));
    }
  }

  void _handleUpload(BuildContext context) {
    _logger.i('Handling upload');
    context.read<UploadItemBloc>().add(StartUploadItem(
      itemName: _itemNameController.text.trim(),
      amountSpent: double.tryParse(_amountSpentController.text) ?? 0.0,
      imageFile: _imageFile,
      imageUrl: _imageUrl,
      selectedItemType: selectedItemType,
      selectedSpecificType: selectedSpecificType,
      selectedClothingLayer: selectedClothingLayer,
      selectedOccasion: selectedOccasion,
      selectedSeason: selectedSeason,
      selectedColour: selectedColour,
      selectedColourVariation: selectedColourVariation,
    ));
  }

  /// This method maps error keys to localized error messages
  void _showErrorMessage(String errorKey) {
    _logger.w('Showing error message for key: $errorKey');
    String errorMessage;

    switch (errorKey) {
      case 'item_name_required':
        errorMessage = S.of(context).itemNameFieldNotFilled;
        break;
      case 'invalid_amount_spent':
        errorMessage = S.of(context).please_enter_valid_amount;
        break;
      case 'item_type_required':
        errorMessage = S.of(context).itemTypeFieldNotFilled;
        break;
      case 'occasion_required':
        errorMessage = S.of(context).occasionFieldNotFilled;
        break;
      case 'season_required':
        errorMessage = S.of(context).seasonFieldNotFilled;
        break;
      case 'specific_type_required':
        errorMessage = S.of(context).specificTypeFieldNotFilled;
        break;
      case 'clothing_layer_required':
        errorMessage = S.of(context).clothingLayerFieldNotFilled;
        break;
      case 'color_required':
        errorMessage = S.of(context).colourFieldNotFilled;
        break;
      case 'color_variation_required':
        errorMessage = S.of(context).colourVariationFieldNotFilled;
        break;
      default:
        errorMessage = S.of(context).unknownError; // Add a generic unknown error string
        break;
    }

    CustomSnackbar(
      message: errorMessage,
      theme: widget.myClosetTheme,
    ).show(context);
  }

  void _openMetadataSheet() {
    _logger.i('Opening metadata sheet');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => const MetadataFeatureBottomSheet(
        isFromMyCloset: true,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _logger.i('Building UploadItemView');
    return BlocConsumer<UploadItemBloc, UploadItemState>(
      listener: (context, state) {
        _logger.i('Bloc state changed: $state');
        final uploadBloc = context.read<UploadItemBloc>();

        if (state is CameraPermissionDenied) {
          _logger.w('Camera permission denied');
          CustomSnackbar(
            message: _permissionService.getPermissionExplanation(context, Permission.camera),
            theme: widget.myClosetTheme,
          ).show(context);

          // Re-ask for the same permission after showing the snackbar
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              uploadBloc.add(RequestCameraPermission());
            }
          });
        } else if (state is CameraPermissionGranted) {
          _logger.i('Camera permission granted');
          _capturePhoto();  // Assuming this is a camera permission
        } else if (state is CameraPermissionPermanentlyDenied) {
          _logger.w('Camera permission permanently denied');
          CustomSnackbar(
            message: _permissionService.getPermissionExplanation(context, Permission.camera),
            theme: widget.myClosetTheme,
          ).show(context);

          // Pass the _navigateToMyCloset method to the CameraItemPermissionHelper
          CameraItemPermissionHelper().checkAndRequestPermission(
            context,
            widget.myClosetTheme,
                () => _navigateToMyCloset(context),
          );
        } else if (state is UploadItemSuccess) {
          _logger.i('Upload successful');
          CustomSnackbar(
            message: S.of(context).upload_successful,
            theme: widget.myClosetTheme,
          ).show(context);
          _navigateToMyCloset(context);
        } else if (state is UploadItemFailure) {
          _logger.e('Upload failed with error: ${state.error}');
          CustomSnackbar(
            message: S.of(context).upload_failed(state.error),
            theme: widget.myClosetTheme,
          ).show(context);
        } else if (state is FormValidPage1) {
          _logger.i('Form page 1 valid');
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          setState(() {
            _currentPage = 1;
          });
        } else if (state is FormInvalidPage1) {
          _logger.w('Form page 1 invalid: ${state.errorMessage}');
          _showErrorMessage(state.errorMessage);
        } else if (state is FormValidPage2) {
          _logger.i('Form page 2 valid');
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          setState(() {
            _currentPage = 2;
          });
        } else if (state is FormInvalidPage2) {
          _logger.w('Form page 2 invalid: ${state.errorMessage}');
          _showErrorMessage(state.errorMessage);
        } else if (state is FormValidPage3) {
          _logger.i('Form page 3 valid');
          _handleUpload(context);
        } else if (state is FormInvalidPage3) {
          _logger.w('Form page 3 invalid: ${state.errorMessage}');
          _showErrorMessage(state.errorMessage);
        }
      },
      builder: (context, state) {
        _logger.i('Building UI based on state: $state');
        return PopScope<Object?>(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? result) {
            if (didPop) {
              // Do nothing, effectively preventing the back action
            }
          },
          child: Theme(
            data: widget.myClosetTheme,
            child: Scaffold(
              backgroundColor: widget.myClosetTheme.colorScheme.surface,
              body: SafeArea(
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.25,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Stack(
                          children: [
                            Center(
                              child: ImageDisplayWidget(
                                imageUrl: _imageUrl,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: NavigationTypeButton(
                                label: TypeDataList.metadata(context).getName(context),
                                selectedLabel: '',
                                onPressed: _openMetadataSheet,
                                assetPath: TypeDataList.metadata(context).assetPath,
                                isFromMyCloset: true,
                                buttonType: ButtonType.secondary,
                                usePredefinedColor: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          MetadataFirstPage(
                            itemNameController: _itemNameController,
                            amountSpentController: _amountSpentController,
                            selectedItemType: selectedItemType,
                            selectedOccasion: selectedOccasion,
                            onItemTypeChanged: (type) => setState(() {
                              selectedItemType = type;
                            }),
                            onOccasionChanged: (occasion) => setState(() {
                              selectedOccasion = occasion;
                            }),
                            amountSpentError: _amountSpentError,
                            myClosetTheme: widget.myClosetTheme,
                          ),
                          MetadataSecondPage(
                            selectedItemType: selectedItemType,
                            selectedSpecificType: selectedSpecificType,
                            selectedSeason: selectedSeason,
                            selectedClothingLayer: selectedClothingLayer,
                            onSpecificTypeChanged: (type) => setState(() {
                              selectedSpecificType = type;
                            }),
                            onSeasonChanged: (season) => setState(() {
                              selectedSeason = season;
                            }),
                            onClothingLayerChanged: (layer) => setState(() {
                              selectedClothingLayer = layer;
                            }),
                            myClosetTheme: widget.myClosetTheme,
                          ),
                          MetadataThirdPage(
                            selectedColour: selectedColour,
                            selectedColourVariation: selectedColourVariation,
                            onColourChanged: (colour) => setState(() {
                              selectedColour = colour;
                            }),
                            onColourVariationChanged: (variation) => setState(() {
                              selectedColourVariation = variation;
                            }),
                            myClosetTheme: widget.myClosetTheme,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2.0, bottom: 20.0, left: 16.0, right: 16.0),
                      child: ElevatedButton(
                        onPressed: state is UploadingItem ? null : () => _handleNext(context),
                        child: state is UploadingItem
                            ? SizedBox(
                          width: 36.0,
                          height: 36.0,
                          child: ClosetProgressIndicator(
                            color: widget.myClosetTheme.colorScheme.onPrimary,
                            size: 24.0,
                          ),
                        )
                            : Text(_currentPage == 2 ? S.of(context).upload : S.of(context).next),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
