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

  final _logger = CustomLogger('EditItemScreen');
  Map<String, String> _validationErrors = {};

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
    _amountSpentController = TextEditingController(); // ADD THIS
    _logger.i('Initialized EditItemScreen with itemId: ${widget.itemId}');
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _amountSpentController.dispose(); // ADD THIS
    _logger.i('Disposed controllers');
    super.dispose();
  }

  // Dismiss keyboard when tapping outside inputs.
  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  // Navigate to PhotoProvider for image editing.
  void _navigateToPhotoProvider() {
    _logger.d('Navigating to PhotoProvider for itemId: ${widget.itemId}');
    Navigator.pushNamed(
      context,
      AppRoutes.editPhoto,
      arguments: widget.itemId,
    );
  }

  // Open declutter bottom sheet.
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

  // Open swap bottom sheet.
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

  // Open metadata bottom sheet.
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

  // Dispatch metadata change event.
  void _dispatchMetadataChanged(EditItemState state, ClosetItemDetailed updatedItem) {
    _logger.d('Dispatching metadata change for itemId: ${widget.itemId}');
    context.read<EditItemBloc>().add(MetadataChangedEvent(updatedItem: updatedItem));
  }

  // Handler: Dispatch validation event to the bloc.
  void _handleUpdate() {
    final currentItem = getCurrentItem(context.read<EditItemBloc>().state);
    final parsedAmount = double.tryParse(_amountSpentController.text);

    if (parsedAmount == null || parsedAmount < 0) {
      setState(() {
        _validationErrors['amount_spent'] = "Please enter a valid amount.";
        _isChanged = true;
      });
      return; // Stop further submission
    }

    context.read<EditItemBloc>().add(
      ValidateFormEvent(
        updatedItem: currentItem.copyWith(
          name: _itemNameController.text,
          amountSpent: parsedAmount,
        ),
        name: _itemNameController.text,
        amountSpent: parsedAmount,
      ),
    );
  }

  // Helper to extract the current item from state.
  ClosetItemDetailed getCurrentItem(EditItemState state) {
    if (state is EditItemLoaded) {
      return state.item;
    } else if (state is EditItemMetadataChanged) {
      return state.updatedItem;
    } else if (state is EditItemValidationFailure) {
      return state.updatedItem;
    } else if (state is EditItemValidationSuccess) {
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
        BlocListener<EditItemBloc, EditItemState>(
          listener: (context, state) {
            if (state is EditItemValidationFailure) {
              setState(() {
                _validationErrors = state.validationErrors;
                _isChanged = true;
              });
            } else if (state is EditItemValidationSuccess) {
              // When validation passes, automatically dispatch submission.
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
          // Update text controllers when state changes.
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
          }
        },
        builder: (context, state) {
          if (state is EditItemInitial || state is EditItemLoading) {
            return const Center(child: ClosetProgressIndicator());
          }
          if (state is EditItemLoadFailure) {
            return const Center(child: Text('Failed to load item'));
          }
          // When update is successful, we already navigate away, so return an empty container.
          if (state is EditItemUpdateSuccess) {
            return Container();
          }
          try {
            final currentItem = getCurrentItem(state);
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
                    // Top section: Image and Swap button.
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
                    // Middle section: Scrollable metadata form.
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        // Notice: No Form widget here.
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
                            final currentState = getCurrentItem(context.read<EditItemBloc>().state);
                            _dispatchMetadataChanged(context.read<EditItemBloc>().state, currentState.copyWith(name: value));
                          },
                          onAmountSpentChanged: (value) {
                            setState(() {
                              _isChanged = true;
                              _validationErrors = {};
                            });
                            double? parsed = double.tryParse(value);
                            if (parsed != null) {
                              _dispatchMetadataChanged(context.read<EditItemBloc>().state, currentItem.copyWith(amountSpent: parsed));
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
                    // Bottom section: Update button.
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: (_isChanged || _validationErrors.isNotEmpty)
                            ? _handleUpdate
                            : _openDeclutterSheet,
                        child: Text(S.of(context).update),
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
