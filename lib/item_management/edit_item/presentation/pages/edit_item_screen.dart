import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/bloc/edit_item_bloc.dart';
import '../../../declutter_items/presentation/widgets/declutter_options_bottom_sheet.dart';
import '../../../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../generated/l10n.dart';
import '../../../../core/widgets/bottom_sheet/premium_bottom_sheet/swap_premium_bottom_sheet.dart';
import '../../../../core/widgets/bottom_sheet/premium_bottom_sheet/metadata_premium_bottom_sheet.dart';
import '../../../../core/utilities/routes.dart';
import '../../../core/data/models/closet_item_detailed.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../presentation/widgets/edit_item_metadata.dart';
import '../../presentation/widgets/edit_item_image_with_additional_features.dart';

class EditItemScreen extends StatefulWidget {
  final String itemId;

  const EditItemScreen({
    super.key,
    required this.itemId,
  });

  @override
  State<EditItemScreen> createState() => _EditItemScreenState();
}

class _EditItemScreenState extends State<EditItemScreen> {
  late TextEditingController _itemNameController;
  late TextEditingController _amountSpentController;
  String? _imageUrl;
  bool _isChanged = false;

  final _formKey = GlobalKey<FormState>();
  final _logger = CustomLogger('EditItemScreen');

  Map<String, String> _validationErrors = {};

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
    _amountSpentController = TextEditingController();
    _logger.i('Initialized EditItemScreen with itemId: ${widget.itemId}');
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _amountSpentController.dispose();
    _logger.i('Disposed controllers');
    super.dispose();
  }

  // Dismiss the keyboard when tapping outside the input fields
  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  // Route the user to PhotoProvider for image editing
  void _navigateToPhotoProvider() {
    _logger.d('Navigating to PhotoProvider for itemId: ${widget.itemId}');
    Navigator.pushNamed(
      context,
      AppRoutes.editPhoto,
      arguments: widget.itemId,
    );
  }

  // Open the declutter bottom sheet
  void _openDeclutterSheet() {
    _logger.d('Opening declutter sheet for itemId: ${widget.itemId}');
    showModalBottomSheet(
      context: context,
      builder: (context) => DeclutterBottomSheet(
        currentItemId: widget.itemId,
        isFromMyCloset: true,
      ),
    );
  }

  // Open the swap bottom sheet
  void _openSwapSheet() {
    _logger.d('Opening swap sheet for itemId: ${widget.itemId}');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => const SwapFeatureBottomSheet(
        isFromMyCloset: true,
      ),
    );
    setState(() {
      _isChanged = false;
    });
  }

  // Open the metadata bottom sheet
  void _openMetadataSheet() {
    _logger.d('Opening metadata sheet for itemId: ${widget.itemId}');
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => const MetadataFeatureBottomSheet(
        isFromMyCloset: true,
      ),
    );
    setState(() {
      _isChanged = false;
    });
  }

  // Dispatch metadata change event
  void _dispatchMetadataChanged(EditItemState state, ClosetItemDetailed updatedItem) {
    _logger.d('Dispatching metadata change for itemId: ${widget.itemId}');
    context.read<EditItemBloc>().add(
      MetadataChangedEvent(updatedItem: updatedItem),
    );
  }

  // New handler: Dispatch event to validate and submit
  void _handleUpdate() {
    final currentItem = getCurrentItem(context.read<EditItemBloc>().state);
    context.read<EditItemBloc>().add(
      ValidateFormEvent(
        updatedItem: currentItem.copyWith(
          name: _itemNameController.text,
          amountSpent: double.tryParse(_amountSpentController.text) ?? currentItem.amountSpent,
        ),
        name: _itemNameController.text,
        amountSpent: double.tryParse(_amountSpentController.text) ?? currentItem.amountSpent,
      ),
    );
  }

  // Keep the logic for getting the current item state
  ClosetItemDetailed getCurrentItem(EditItemState state) {
    if (state is EditItemLoaded) {
      _logger.i('Loaded item: ${state.item.itemId}');
      return state.item;
    } else if (state is EditItemMetadataChanged) {
      _logger.i('Updated item: ${state.updatedItem.itemId}');
      return state.updatedItem;
    } else if (state is EditItemValidationFailure) {
      return state.updatedItem;
    } else if (state is EditItemValidationSuccess) {
      _logger.i('Validated item: ${state.validatedItem.itemId}');
      return state.validatedItem;
    }
    _logger.e('Invalid state encountered');
    throw StateError("Invalid state");
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData myClosetTheme = Theme.of(context);

    return MultiBlocListener(
      listeners: [
        // Listen for update events and validation failures
        BlocListener<EditItemBloc, EditItemState>(
          listener: (context, state) {
            if (state is EditItemValidationFailure) {
              setState(() {
                _validationErrors = state.validationErrors;
              });
            } else if (state is EditItemValidationSuccess) {
              final currentItem = getCurrentItem(state);
              context.read<EditItemBloc>().add(
                SubmitFormEvent(
                  itemId: currentItem.itemId,
                  name: _itemNameController.text,
                  amountSpent: double.tryParse(_amountSpentController.text) ?? currentItem.amountSpent,
                  itemType: currentItem.itemType,
                  colour: currentItem.colour,
                  occasion: currentItem.occasion,
                  season: currentItem.season,
                  colourVariations: currentItem.colourVariations,
                  clothingType: currentItem.clothingType,
                  clothingLayer: currentItem.clothingLayer,
                  shoesType: currentItem.shoesType,
                  accessoryType: currentItem.accessoryType,
                ),
              );
              // Optionally, you may show a message like "Validation succeeded".
            } else if (state is EditItemUpdateSuccess) {
              Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
            } else if (state is EditItemUpdateFailure) {
              CustomSnackbar(
                message: state.errorMessage,
                theme: Theme.of(context),
              ).show(context);
            }
          },
        ),
      ],
      child: BlocConsumer<EditItemBloc, EditItemState>(
        listener: (context, state) {
          // Update image URL or text fields based on state changes
          if (state is EditItemLoaded) {
            final currentItem = state.item;
            if (_itemNameController.text != currentItem.name) {
              _itemNameController.text = currentItem.name;
            }
            if (_amountSpentController.text != currentItem.amountSpent.toString()) {
              _amountSpentController.text = currentItem.amountSpent.toString();
            }
          } else if (state is EditItemMetadataChanged) {
            final updatedItem = state.updatedItem;
            if (_itemNameController.text != updatedItem.name) {
              _itemNameController.text = updatedItem.name;
            }
            // Do not update _amountSpentController.text here if not needed
          }
        },
        builder: (context, state) {
          if (state is EditItemInitial || state is EditItemLoading) {
            _logger.i('Loading state for itemId: ${widget.itemId}');
            return const Center(child: ClosetProgressIndicator());
          }
          if (state is EditItemLoadFailure) {
            _logger.e('Failed to load itemId: ${widget.itemId}');
            return const Center(child: Text('Failed to load item'));
          }
          if (state is EditItemUpdateSuccess) {
            return Container();
          }

          try {
            ClosetItemDetailed currentItem = getCurrentItem(state);

            return GestureDetector(
              onTap: _dismissKeyboard,
              behavior: HitTestBehavior.translucent,
              child: Scaffold(
                appBar: AppBar(
                  title: Text(
                    S.of(context).editPageTitle,
                    style: myClosetTheme.textTheme.titleMedium,
                  ),
                ),
                body: Column(
                  children: [
                    // Top section: Image and Swap button
                    EditItemImageWithAdditionalFeatures(
                      imageUrl: _imageUrl,
                      isChanged: _isChanged,
                      onImageTap: () {
                        if (!_isChanged) {
                          _navigateToPhotoProvider();
                        } else {
                          CustomSnackbar(
                            message: S.of(context).unsavedChangesMessage,
                            theme: Theme.of(context),
                          ).show(context);
                        }
                      },
                      onSwapPressed: _openSwapSheet,
                      onMetadataPressed: _openMetadataSheet,
                    ),
                    // Middle section: Scrollable metadata form
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: EditItemMetadata(
                            currentItem: currentItem,
                            itemNameController: _itemNameController,
                            amountSpentController: _amountSpentController,
                            isChanged: _isChanged,
                            validationErrors: _validationErrors,
                            onNameChanged: (value) {
                              setState(() {
                                _isChanged = true;
                                _validationErrors = {};
                              });
                              final currentItemState = getCurrentItem(context.read<EditItemBloc>().state);
                              _dispatchMetadataChanged(context.read<EditItemBloc>().state, currentItemState.copyWith(name: value));
                            },
                            onAmountSpentChanged: (value) {
                              setState(() {
                                _isChanged = true;
                                _validationErrors = {};
                              });
                              double? parsedAmount = double.tryParse(value);
                              if (parsedAmount != null) {
                                _dispatchMetadataChanged(context.read<EditItemBloc>().state, currentItem.copyWith(amountSpent: parsedAmount));
                              } else {
                                _validationErrors['amount_spent'] = S.of(context).please_enter_valid_amount;
                              }
                            },
                            onItemTypeChanged: (dataKey) {
                              setState(() {
                                _isChanged = true;
                                _validationErrors = {};
                                if (dataKey == 'clothing') {
                                  _dispatchMetadataChanged(context.read<EditItemBloc>().state, currentItem.copyWith(
                                    itemType: [dataKey],
                                    accessoryType: null,
                                    shoesType: null,
                                  ));
                                  _validationErrors.remove('accessory_type');
                                  _validationErrors.remove('shoes_type');
                                  _validationErrors.remove('clothing_type');
                                  _validationErrors.remove('clothing_layer');
                                } else if (dataKey == 'accessory') {
                                  _dispatchMetadataChanged(context.read<EditItemBloc>().state, currentItem.copyWith(
                                    itemType: [dataKey],
                                    clothingLayer: null,
                                    clothingType: null,
                                    shoesType: null,
                                  ));
                                  _validationErrors.remove('clothing_type');
                                  _validationErrors.remove('clothing_layer');
                                  _validationErrors.remove('shoes_type');
                                  _validationErrors.remove('accessory_type');
                                } else if (dataKey == 'shoes') {
                                  _dispatchMetadataChanged(context.read<EditItemBloc>().state, currentItem.copyWith(
                                    itemType: [dataKey],
                                    clothingLayer: null,
                                    clothingType: null,
                                    accessoryType: null,
                                  ));
                                  _validationErrors.remove('clothing_type');
                                  _validationErrors.remove('clothing_layer');
                                  _validationErrors.remove('accessory_type');
                                  _validationErrors.remove('shoes_type');
                                }
                              });
                            },
                            onOccasionChanged: (dataKey) {
                              setState(() {
                                _isChanged = true;
                                _validationErrors = {};
                              });
                              _dispatchMetadataChanged(context.read<EditItemBloc>().state, currentItem.copyWith(occasion: [dataKey]));
                            },
                            onSeasonChanged: (dataKey) {
                              setState(() {
                                _isChanged = true;
                                _validationErrors = {};
                              });
                              _dispatchMetadataChanged(context.read<EditItemBloc>().state, currentItem.copyWith(season: [dataKey]));
                            },
                            onAccessoryTypeChanged: (dataKey) {
                              setState(() {
                                _isChanged = true;
                                _validationErrors = {};
                              });
                              _dispatchMetadataChanged(context.read<EditItemBloc>().state, currentItem.copyWith(accessoryType: [dataKey]));
                            },
                            onClothingLayerChanged: (dataKey) {
                              setState(() {
                                _isChanged = true;
                                _validationErrors = {};
                              });
                              _dispatchMetadataChanged(context.read<EditItemBloc>().state, currentItem.copyWith(clothingLayer: [dataKey]));
                            },
                            onClothingTypeChanged: (dataKey) {
                              setState(() {
                                _isChanged = true;
                                _validationErrors = {};
                              });
                              _dispatchMetadataChanged(context.read<EditItemBloc>().state, currentItem.copyWith(clothingType: [dataKey]));
                            },
                            onShoeTypeChanged: (dataKey) {
                              setState(() {
                                _isChanged = true;
                                _validationErrors = {};
                              });
                              _dispatchMetadataChanged(context.read<EditItemBloc>().state, currentItem.copyWith(shoesType: [dataKey]));
                            },
                            onColourChanged: (dataKey) {
                              setState(() {
                                _isChanged = true;
                                _validationErrors = {};
                              });
                              _dispatchMetadataChanged(context.read<EditItemBloc>().state, currentItem.copyWith(colour: [dataKey]));
                            },
                            onColourVariationChanged: (dataKey) {
                              setState(() {
                                _isChanged = true;
                                _validationErrors = {};
                              });
                              _dispatchMetadataChanged(context.read<EditItemBloc>().state, currentItem.copyWith(colourVariations: [dataKey]));
                            },
                            theme: myClosetTheme,
                          ),
                        ),
                      ),
                    ),
                    // Bottom section: Update / Declutter button
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: _isChanged
                            ? (_validationErrors.isEmpty
                            ? () {
                          if (_formKey.currentState?.validate() ?? false) {
                            _handleUpdate();
                          }
                        }
                            : null)
                            : _openDeclutterSheet,
                        child: _isChanged
                            ? Text(S.of(context).update)
                            : Text(S.of(context).declutter),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } catch (e) {
            _logger.e('Error retrieving item details: $e');
            return const Center(child: ClosetProgressIndicator());
          }
        },
      ),
    );
  }
}
