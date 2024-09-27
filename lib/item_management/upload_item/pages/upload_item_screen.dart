import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/user_photo/presentation/widgets/image_display_widget.dart';
import '../../../core/utilities/routes.dart';
import '../../../generated/l10n.dart';
import '../presentation/bloc/upload_item_bloc.dart';
import '../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../core/widgets/bottom_sheet/premium_bottom_sheet/metadata_premium_bottom_sheet.dart';
import '../../../core/widgets/bottom_sheet/usage_bottom_sheet/ai_upload_usage_bottom_sheet.dart';
import '../presentation/widgets/sliding_progress_button.dart';
import '../presentation/widgets/upload_item_additional_feature.dart';
import '../../../core/utilities/logger.dart';
import 'metadata/metadata_first_page.dart';
import 'metadata/metadata_second_page.dart';
import 'metadata/metadata_third_page.dart';

class UploadItemScreen extends StatefulWidget {
  final ThemeData myClosetTheme;
  final String imageUrl;

  const UploadItemScreen({
    super.key,
    required this.myClosetTheme,
    required this.imageUrl,
  });

  @override
  State<UploadItemScreen> createState() => _UploadItemScreenState();
}

class _UploadItemScreenState extends State<UploadItemScreen> with WidgetsBindingObserver {
  final _itemNameController = TextEditingController();
  final _amountSpentController = TextEditingController();
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
  final CustomLogger _logger = CustomLogger('UploadItemView');

  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _imageUrl = widget.imageUrl;
    _logger.i('UploadItemView initialized with imageUrl: $_imageUrl');
  }

  @override
  void dispose() {
    _logger.i('Disposing UploadItemView');
    _itemNameController.dispose();
    _amountSpentController.dispose();
    _pageController.dispose();
    _logger.i('Resources disposed');
    super.dispose();
  }

  void _navigateToMyCloset(BuildContext context) {
    if (mounted) {
      _logger.i('Navigating back to MyCloset');
      Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
    }
  }

  void _handleNext(BuildContext context) {
    _logger.i('Handling "Next" button press, current page: $_currentPage');
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
    _logger.i('Handling upload, uploading item with the following details:');
    _logger.d('Item Name: ${_itemNameController.text.trim()}');
    _logger.d('Amount Spent: ${_amountSpentController.text}');
    _logger.d('Image URL: $_imageUrl');
    _logger.d('Item Type: $selectedItemType, Specific Type: $selectedSpecificType');
    _logger.d('Occasion: $selectedOccasion, Season: $selectedSeason');
    _logger.d('Clothing Layer: $selectedClothingLayer');
    _logger.d('Color: $selectedColour, Color Variation: $selectedColourVariation');

    context.read<UploadItemBloc>().add(StartUploadItem(
      itemName: _itemNameController.text.trim(),
      amountSpent: double.tryParse(_amountSpentController.text) ?? 0.0,
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

  void _showErrorMessage(String errorKey) {
    _logger.w('Error encountered: $errorKey');
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
        errorMessage = S.of(context).unknownError;
        break;
    }

    _logger.w('Displaying error message: $errorMessage');
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

  void _openAiUploadSheet() {
    _logger.i('Opening ai upload sheet');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => const AiUploadUsageBottomSheet(
        isFromMyCloset: true,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _logger.i('Building UploadItemView UI');

    return BlocConsumer<UploadItemBloc, UploadItemState>(
      listener: (context, state) {
        _logger.i('Bloc state changed: $state');
        if (state is UploadItemSuccess) {
          _logger.i('Upload successful, navigating back to MyCloset');
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
          _logger.i('Form page 1 validated successfully, moving to next page');
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
          _logger.i('Form page 2 validated successfully, moving to next page');
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
        } else if (state is FormInvalidPage3) {
          _logger.w('Form page 3 invalid: ${state.errorMessage}');
          _showErrorMessage(state.errorMessage);
        } else if (state is FormValidPage3) {
          _logger.i('Form page 3 validated successfully, starting upload');
          _handleUpload(context);
        }
      },
      builder: (context, state) {
        _logger.i('Rendering UI based on state: $state');
        return PopScope<Object?>(
          canPop: false,
          onPopInvokedWithResult: (bool didPop, Object? result) {
            if (didPop) {
              _logger.i('Preventing back navigation');
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
                              child: UploadItemAdditionalFeature(
                                openMetadataSheet: _openMetadataSheet,
                                openAiUploadSheet: _openAiUploadSheet,
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
                      padding: const EdgeInsets.only(top: 2.0, bottom: 60.0, left: 16.0, right: 16.0),
                      child: SlidingProgressButton(
                        onNext: () => _handleNext(context),
                        onSubmit: () => _handleNext(context),
                        isUploadingItem: state is UploadingItem,  // Pass Bloc's loading state
                        currentPage: _currentPage,
                        totalSteps: 3,
                        myClosetTheme: widget.myClosetTheme,
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
