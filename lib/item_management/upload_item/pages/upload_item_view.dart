import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/data/type_data.dart';
import '../widgets/image_display_widget.dart';
import '../../../core/usecase/photo_capture_service.dart';
import '../../../core/utilities/routes.dart';
import '../../../generated/l10n.dart';
import '../presentation/bloc/upload_bloc.dart';
import '../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../core/widgets/bottom_sheet/metadata_premium_bottom_sheet.dart';
import '../../../core/theme/themed_svg.dart';
import '../../../core/widgets/button/navigation_type_button.dart';
import '../../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../core/utilities/permission_service.dart';
import '../../../core/widgets/feedback/custom_alert_dialog.dart';
import 'metadata/metadata_first_page.dart';
import 'metadata/metadata_second_page.dart';
import 'metadata/metadata_third_page.dart';

class UploadItemView extends StatefulWidget {
  final ThemeData myClosetTheme;

  const UploadItemView({super.key, required this.myClosetTheme});

  @override
  State<UploadItemView> createState() => _UploadItemViewState();
}

class _UploadItemViewState extends State<UploadItemView> {
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

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    context.read<UploadBloc>().add(CheckCameraPermission());
  }

  void _showOpenSettingsDialog(BuildContext context, Permission permission) {
    CustomAlertDialog.showCustomDialog(
      context: context,
      title: "", // Localized title
      content: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0), // Adjust the padding if needed
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  S.of(context).camera_permission_needed, // Localized title manually handled here
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 8.0), // Add some space between title and explanation
                Text(_permissionService.getPermissionExplanation(context, permission)), // Localized explanation
                const SizedBox(height: 16.0),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      openAppSettings();
                    },
                    child: Text(S.of(context).open_settings),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.close, color: widget.myClosetTheme.colorScheme.onSurface),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                Navigator.pushReplacementNamed(context, AppRoutes.myCloset); // Navigate to myCloset
              },
            ),
          ),
        ],
      ),
      theme: widget.myClosetTheme,
      barrierDismissible: false, // Optional: Set to false to prevent dismissal by tapping outside
    );
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _amountSpentController.dispose();
    _pageController.dispose();
    super.dispose();
  }


  Future<void> _capturePhoto() async {
    final PhotoCaptureService photoCaptureService = PhotoCaptureService();

    File? resizedImageFile = await photoCaptureService.captureAndResizePhoto();

    if (resizedImageFile != null) {
      setState(() {
        _imageFile = resizedImageFile;
        _imageUrl = _imageFile!.path;
      });
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.myCloset);
      }
    }
  }

  void _handleNext(BuildContext context) {
    final uploadBloc = context.read<UploadBloc>();

    if (_currentPage == 0) {
      uploadBloc.add(ValidateFormPage1(
        itemName: _itemNameController.text.trim(),
        amountSpentText: _amountSpentController.text,
        selectedItemType: selectedItemType,
        selectedOccasion: selectedOccasion,
      ));
    } else if (_currentPage == 1) {
      uploadBloc.add(ValidateFormPage2(
        selectedSeason: selectedSeason,
        selectedSpecificType: selectedSpecificType,
        selectedItemType: selectedItemType,
        selectedClothingLayer: selectedClothingLayer,
      ));
    } else if (_currentPage == 2) {
      uploadBloc.add(ValidateFormPage3(
        selectedColour: selectedColour,
        selectedColourVariation: selectedColourVariation,
      ));
    }
  }

  void _handleUpload(BuildContext context) {
    context.read<UploadBloc>().add(StartUpload(
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

  void _openMetdataSheet() {
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
    return BlocConsumer<UploadBloc, UploadState>(
      listener: (context, state) {
        final uploadBloc = context.read<UploadBloc>();

        if (state is CameraPermissionDenied) {
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
          _capturePhoto();  // Assuming this is a camera permission
        } else if (state is CameraPermissionPermanentlyDenied) {
          CustomSnackbar(
            message: _permissionService.getPermissionExplanation(context, Permission.camera),
            theme: widget.myClosetTheme,
          ).show(context);
          _showOpenSettingsDialog(context, Permission.camera);  // Correct method call
        } else if (state is UploadSuccess) {
          CustomSnackbar(
            message: S.of(context).upload_successful,
            theme: widget.myClosetTheme,
          ).show(context);
          Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
        } else if (state is UploadFailure) {
          CustomSnackbar(
            message: S.of(context).upload_failed(state.error),
            theme: widget.myClosetTheme,
          ).show(context);
        }  else if (state is FormValidPage1) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          setState(() {
            _currentPage = 1;
          });
        } else if (state is FormInvalidPage1) {
          _showErrorMessage(state.errorMessage);
        } else if (state is FormValidPage2) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          setState(() {
            _currentPage = 2;
          });
        } else if (state is FormInvalidPage2) {
          _showErrorMessage(state.errorMessage);
        } else if (state is FormValidPage3) {
          _handleUpload(context);
        } else if (state is FormInvalidPage3) {
          _showErrorMessage(state.errorMessage);
        }
      },
      builder: (context, state) {
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
                                onPressed: _openMetdataSheet,
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
                        onPressed: state is Uploading ? null : () => _handleNext(context),
                        child: state is Uploading
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
