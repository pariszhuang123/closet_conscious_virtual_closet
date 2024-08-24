import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/image_display_widget.dart';
import '../../../core/usecase/photo_capture_service.dart';
import '../../../core/utilities/routes.dart';
import '../../../core/data/type_data.dart';
import '../../../generated/l10n.dart';
import '../../../core/widgets/icon_row_builder.dart';
import '../presentation/bloc/upload_bloc.dart';
import '../../../user_management/authentication/presentation/bloc/auth_bloc.dart';
import '../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../core/widgets/bottom_sheet/metadata_premium_bottom_sheet.dart';
import '../../../core/theme/themed_svg.dart';
import '../../../core/widgets/button/navigation_type_button.dart';
import '../../../core/widgets/progress_indicator/closet_progress_indicator.dart';


class UploadItemPage extends StatefulWidget {
  final ThemeData myClosetTheme;

  const UploadItemPage({super.key, required this.myClosetTheme});

  @override
  State<UploadItemPage> createState() => _UploadItemPageState();
}

class _UploadItemPageState extends State<UploadItemPage> {
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
  int _currentPage = 0;

  final _formKeyPage1 = GlobalKey<FormState>();
  final _formKeyPage2 = GlobalKey<FormState>();
  final _formKeyPage3 = GlobalKey<FormState>();

  bool get _isFormValidPage1 {
    final amountSpentText = _amountSpentController.text;
    final amountSpent = double.tryParse(amountSpentText);

    return selectedItemType != null &&
        _itemNameController.text.isNotEmpty &&
        amountSpentText.isNotEmpty &&
        amountSpent != null &&
        amountSpent >= 0 &&
        selectedOccasion != null;
  }

  bool get _isFormValidPage2 {
    return selectedSeason != null &&
        selectedSpecificType != null &&
        (selectedItemType != 'clothing' || selectedClothingLayer != null);
  }

  bool get _isFormValidPage3 {
    if (selectedColour == null) {
      return false;
    }
    if (selectedColour != 'black' && selectedColour != 'white' &&
        selectedColourVariation == null) {
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    _capturePhoto();
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

      // Continue with any other operations like uploading the image
    } else {
      // Handle the case where the user canceled the camera
      if (mounted) {
        Navigator.of(context).pushReplacementNamed(AppRoutes.myCloset); // Close this screen if no photo is taken
      }
    }
  }


  bool _validateAmountSpent() {
    final amountSpentText = _amountSpentController.text;
    if (amountSpentText.isEmpty) {
      setState(() {
        _amountSpentError = null;
      });
      return true;
    }

    final amountSpent = double.tryParse(amountSpentText);
    if (amountSpent == null || amountSpent < 0) {
      setState(() {
        _amountSpentError = S.of(context).please_enter_valid_amount;
      });
      return false;
    }

    setState(() {
      _amountSpentError = null;
    });
    return true;
  }

  void _handleNext(BuildContext context) {
    if (_currentPage == 0) {
      if (_isFormValidPage1) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage = 1;
        });
      } else {
        _showSpecificErrorMessagesPage1();
      }
    } else if (_currentPage == 1) {
      if (_isFormValidPage2) {
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
        setState(() {
          _currentPage = 2;
        });
      } else {
        _showSpecificErrorMessagesPage2();
      }
    } else if (_currentPage == 2) {
      if (_isFormValidPage3) {
        _handleUpload(context);
      } else {
        _showSpecificErrorMessagesPage3();
      }
    }
  }

  void _handleUpload(BuildContext context) {
    if (_isFormValidPage3) {
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
    } else {
      _showSpecificErrorMessagesPage3();
    }
  }

  void _showSpecificErrorMessagesPage1() {
    if (_itemNameController.text.isEmpty) {
      _showErrorMessage(S.of(context).itemNameFieldNotFilled);
    } else if (_amountSpentController.text.isEmpty) {
      _showErrorMessage(S.of(context).amountSpentFieldNotFilled);
    } else if (selectedItemType == null) {
      _showErrorMessage(S.of(context).itemTypeFieldNotFilled);
    } else if (selectedOccasion == null) {
      _showErrorMessage(S.of(context).occasionFieldNotFilled);
    }
  }

  void _showSpecificErrorMessagesPage2() {
    if (selectedSeason == null) {
      _showErrorMessage(S.of(context).seasonFieldNotFilled);
    } else if (selectedSpecificType == null) {
      _showErrorMessage(S.of(context).specificTypeFieldNotFilled);
    } else if (selectedItemType == 'clothing' && selectedClothingLayer == null) {
      _showErrorMessage(S.of(context).clothingLayerFieldNotFilled);
    }
  }

  void _showSpecificErrorMessagesPage3() {
    if (selectedColour == null) {
      _showErrorMessage(S.of(context).colourFieldNotFilled);
    } else if (selectedColour != 'black' && selectedColour != 'white' && selectedColourVariation == null) {
      _showErrorMessage(S.of(context).colourVariationFieldNotFilled);
    }
  }

  void _showErrorMessage(String message) {
    CustomSnackbar(
      message: message,
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
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    final authBloc = context.read<AuthBloc>();
    final userId = authBloc.userId;
    final metadataData = TypeDataList.metadata(context);

    if (userId == null) {
      return const Center(child: Text('User not authenticated'));
    }

    return BlocProvider(
      create: (context) => UploadBloc(userId: userId),
      child: BlocConsumer<UploadBloc, UploadState>(
        listener: (context, state) {
          if (state is UploadSuccess) {
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
          }
        },
        builder: (context, state) {
          return PopScope<Object?>(
            canPop: false,
            onPopInvokedWithResult: (bool didPop, Object? result) {
              // Simply do nothing to prevent back navigation
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
                                  label: metadataData.getName(context),
                                  selectedLabel: '',
                                  onPressed: _openMetdataSheet,
                                  assetPath: metadataData.assetPath,
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
                            // First Page
                            SingleChildScrollView(
                              child: Form(
                                key: _formKeyPage1,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _itemNameController,
                                        decoration: InputDecoration(
                                          labelText: S.of(context).item_name,
                                          labelStyle: widget.myClosetTheme.textTheme.bodyMedium,
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return S.of(context).pleaseEnterItemName;
                                          }
                                          return null;
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: _amountSpentController,
                                        decoration: InputDecoration(
                                          labelText: S.of(context).amountSpentLabel,
                                          hintText: S.of(context).enterAmountSpentHint,
                                          errorText: _amountSpentError,
                                          labelStyle: widget.myClosetTheme.textTheme.bodyMedium,
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          _validateAmountSpent();
                                        },
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        S.of(context).selectItemType,
                                        style: widget.myClosetTheme.textTheme.bodyMedium,
                                      ),
                                      SafeArea(
                                        child: Column(
                                          children: buildIconRows(
                                            TypeDataList.itemGeneralTypes(context),
                                            selectedItemType,
                                                (dataKey) => setState(() {
                                              selectedItemType = dataKey;
                                            }),
                                            context,
                                            true, // Pass the isFromMyCloset parameter
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        S.of(context).selectOccasion,
                                        style: widget.myClosetTheme.textTheme.bodyMedium,
                                      ),
                                      SafeArea(
                                        child: Column(
                                          children: buildIconRows(
                                            TypeDataList.occasions(context),
                                            selectedOccasion,
                                                (dataKey) => setState(() {
                                              selectedOccasion = dataKey;
                                            }),
                                            context,
                                            true, // Pass the isFromMyCloset parameter
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Second Page
                            SingleChildScrollView(
                              child: Form(
                                key: _formKeyPage2,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        S.of(context).selectSeason,
                                        style: widget.myClosetTheme.textTheme.bodyMedium,
                                      ),
                                      SafeArea(
                                        child: Column(
                                          children: buildIconRows(
                                            TypeDataList.seasons(context),
                                            selectedSeason,
                                                (dataKey) => setState(() {
                                              selectedSeason = dataKey;
                                            }),
                                            context,
                                            true, // Pass the isFromMyCloset parameter
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      if (selectedItemType == 'shoes') ...[
                                        Text(
                                          S.of(context).selectShoeType,
                                          style: widget.myClosetTheme.textTheme.bodyMedium,
                                        ),
                                        SafeArea(
                                          child: Column(
                                            children: buildIconRows(
                                              TypeDataList.shoeTypes(context),
                                              selectedSpecificType,
                                                  (dataKey) => setState(() {
                                                selectedSpecificType = dataKey;
                                              }),
                                              context,
                                              true, // Pass the isFromMyCloset parameter
                                            ),
                                          ),
                                        ),
                                      ],
                                      if (selectedItemType == 'accessory') ...[
                                        Text(
                                          S.of(context).selectAccessoryType,
                                          style: widget.myClosetTheme.textTheme.bodyMedium,
                                        ),
                                        SafeArea(
                                          child: Column(
                                            children: buildIconRows(
                                              TypeDataList.accessoryTypes(context),
                                              selectedSpecificType,
                                                  (dataKey) => setState(() {
                                                selectedSpecificType = dataKey;
                                              }),
                                              context,
                                              true, // Pass the isFromMyCloset parameter
                                            ),
                                          ),
                                        ),
                                      ],
                                      if (selectedItemType == 'clothing') ...[
                                        Text(
                                          S.of(context).selectClothingType,
                                          style: widget.myClosetTheme.textTheme.bodyMedium,
                                        ),
                                        SafeArea(
                                          child: Column(
                                            children: buildIconRows(
                                              TypeDataList.clothingTypes(context),
                                              selectedSpecificType,
                                                  (dataKey) => setState(() {
                                                selectedSpecificType = dataKey;
                                              }),
                                              context,
                                              true, // Pass the isFromMyCloset parameter
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          S.of(context).selectClothingLayer,
                                          style: widget.myClosetTheme.textTheme.bodyMedium,
                                        ),
                                        SafeArea(
                                          child: Column(
                                            children: buildIconRows(
                                              TypeDataList.clothingLayers(context),
                                              selectedClothingLayer,
                                                  (dataKey) => setState(() {
                                                selectedClothingLayer = dataKey;
                                              }),
                                              context,
                                              true, // Pass the isFromMyCloset parameter
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            // Third Page
                            SingleChildScrollView(
                              child: Form(
                                key: _formKeyPage3,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        S.of(context).selectColour,
                                        style: widget.myClosetTheme.textTheme.bodyMedium,
                                      ),
                                      SafeArea(
                                        child: Column(
                                          children: buildIconRows(
                                            TypeDataList.colors(context),
                                            selectedColour,
                                                (dataKey) => setState(() {
                                              selectedColour = dataKey;
                                            }),
                                            context,
                                            true, // Pass the isFromMyCloset parameter
                                          ),
                                        ),
                                      ),
                                      if (selectedColour != 'black' && selectedColour != 'white' && selectedColour != null) ...[
                                        const SizedBox(height: 12),
                                        Text(
                                          S.of(context).selectColourVariation,
                                          style: widget.myClosetTheme.textTheme.bodyMedium,
                                        ),
                                        SafeArea(
                                          child: Column(
                                            children: buildIconRows(
                                              TypeDataList.colorVariations(context),
                                              selectedColourVariation,
                                                  (dataKey) => setState(() {
                                                selectedColourVariation = dataKey;
                                              }),
                                              context,
                                              true, // Pass the isFromMyCloset parameter
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ),
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
      ),
    );
  }
}
