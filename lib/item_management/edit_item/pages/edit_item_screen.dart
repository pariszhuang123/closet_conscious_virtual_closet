import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/bloc/edit_item_bloc.dart';
import '../../declutter_items/presentation/widgets/declutter_options_bottom_sheet.dart';
import '../../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../generated/l10n.dart';
import '../../../core/widgets/bottom_sheet/premium_bottom_sheet/swap_premium_bottom_sheet.dart';
import '../../../core/widgets/bottom_sheet/premium_bottom_sheet/metadata_premium_bottom_sheet.dart';
import '../../../core/utilities/routes.dart';
import '../../core/data/models/closet_item_detailed.dart';
import '../../../core/utilities/logger.dart';
import '../../../core/widgets/feedback/custom_snack_bar.dart';
import '../presentation/widgets/edit_item_metadata.dart';  // Import the new file
import '../presentation/widgets/edit_item_image_with_additional_features.dart';

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
  final _logger = CustomLogger('EditItemScreen'); // Initialize the logger

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

  // Route the user to PhotoProvider for image editing
  void _navigateToPhotoProvider() {
    _logger.d('Navigating to PhotoProvider for itemId: ${widget.itemId}');
    Navigator.pushNamed(
      context,
      AppRoutes.editPhoto, // Use your custom route name defined in AppRoutes
      arguments: widget.itemId, // Pass itemId as an argument
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

  // Open the swap bottom sheet
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

  // Handle form submission via BLoC
  void _handleUpdate() {
    if (_formKey.currentState?.validate() ?? false) {
      final currentState = context.read<EditItemBloc>().state;

      // Ensure we have the current state and it's either loaded or metadata has changed
      if (currentState is EditItemLoaded || currentState is EditItemMetadataChanged) {
        final item = currentState is EditItemLoaded
            ? (currentState).item
            : (currentState as EditItemMetadataChanged).updatedItem;

        _logger.i('Submitting form for itemId: ${item.itemId}');

        // Dispatch the SubmitFormEvent with all necessary parameters
        context.read<EditItemBloc>().add(
          SubmitFormEvent(
            itemId: item.itemId,
            name: _itemNameController.text,
            amountSpent: double.tryParse(_amountSpentController.text) ?? item.amountSpent,
            itemType: item.itemType,
            colour: item.colour,
            occasion: item.occasion,
            season: item.season,
            colourVariations: item.colourVariations,
            clothingType: item.clothingType,
            clothingLayer: item.clothingLayer,
            shoesType: item.shoesType,
            accessoryType: item.accessoryType,
          ),
        );
      }
    }
  }

  // Keep the logic for getting the current item state
  ClosetItemDetailed getCurrentItem(EditItemState state) {
    if (state is EditItemLoaded) {
      _logger.i('Loaded item: ${state.item.itemId}');
      _logger.i('Item Name: ${state.item.name}');
      _logger.i('Amount Spent: ${state.item.amountSpent}');
      return state.item;
    } else if (state is EditItemMetadataChanged) {
      _logger.i('Updated item: ${state.updatedItem.itemId}');
      return state.updatedItem;
    }
    _logger.e('Invalid state encountered');
    throw StateError("Invalid state");
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData myClosetTheme = Theme.of(context);

    return BlocConsumer<EditItemBloc, EditItemState>(
      listener: (context, state) {
        if (state is EditItemUpdateSuccess) {
          _logger.i('Update success for itemId: ${widget.itemId}');
          Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
        } else if (state is EditItemUpdateFailure) {
          _logger.e('Update failure for itemId: ${widget.itemId}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errorMessage)), // Using actual error message
          );
        }

        // Update _imageUrl here safely during state change
        if (state is EditItemLoaded || state is EditItemMetadataChanged) {
          final currentItem = getCurrentItem(state);

          if (_itemNameController.text != currentItem.name) {
            _itemNameController.text = currentItem.name;
          }

          if (_amountSpentController.text != currentItem.amountSpent.toString()) {
            _amountSpentController.text = currentItem.amountSpent.toString();
          }

          if (_imageUrl != currentItem.imageUrl) {
            setState(() {
              _imageUrl = currentItem.imageUrl;
            });
          }
        }
      },

      builder: (context, state) {
        if (state is EditItemInitial || state is EditItemLoading) {
          _logger.i('Loading state for itemId: ${widget.itemId}');
          return const Center(child: ClosetProgressIndicator(color: Colors.teal));
        }
        if (state is EditItemLoadFailure) {
          _logger.e('Failed to load itemId: ${widget.itemId}');
          return const Center(child: Text('Failed to load item'));
        }

        try {
          ClosetItemDetailed currentItem = getCurrentItem(state);

          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).editPageTitle),
            ),
            body: Column(
              children: [
                // Image and Swap Button in a Stack (Top Section)
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
                  onMetadataPressed: _openMetadataSheet, // Added this line
                ),

                // Scrollable Metadata Section (Middle Section)
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
                        onNameChanged: (value) {
                          setState(() {
                            _isChanged = true;
                          });
                          final currentItemState = getCurrentItem(state);
                          _dispatchMetadataChanged(state, currentItemState.copyWith(name: value));
                        },
                        onAmountSpentChanged: (value) {
                          setState(() {
                            _isChanged = true;
                          });
                        },
                        onItemTypeChanged: (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });
                          _dispatchMetadataChanged(state, currentItem.copyWith(itemType: dataKey));
                        },
                        onOccasionChanged: (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });
                          _dispatchMetadataChanged(state, currentItem.copyWith(occasion: dataKey));
                        },
                        onSeasonChanged: (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });
                          _dispatchMetadataChanged(state, currentItem.copyWith(season: dataKey));
                        },
                        onAccessoryTypeChanged: (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });
                          _dispatchMetadataChanged(state, currentItem.copyWith(accessoryType: dataKey));
                        },
                        onClothingLayerChanged: (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });
                          _dispatchMetadataChanged(state, currentItem.copyWith(clothingLayer: dataKey));
                        },
                        onClothingTypeChanged: (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });
                          _dispatchMetadataChanged(state, currentItem.copyWith(clothingType: dataKey));
                        },
                        onShoeTypeChanged: (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });
                          _dispatchMetadataChanged(state, currentItem.copyWith(shoesType: dataKey));
                        },
                        onColourChanged: (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });
                          _dispatchMetadataChanged(state, currentItem.copyWith(colour: dataKey));
                        },
                        onColourVariationChanged: (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });
                          _dispatchMetadataChanged(state, currentItem.copyWith(colourVariations: dataKey));
                        },
                        theme: myClosetTheme,
                      ),
                    ),
                  ),
                ),

                // Button Section (Bottom Section)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: _isChanged
                        ? () {
                      if (_formKey.currentState?.validate() ?? false) {
                        final value = _amountSpentController.text;
                        final double? amountSpent = double.tryParse(value);

                        if (amountSpent != null) {
                          final currentItemState = getCurrentItem(state);
                          _dispatchMetadataChanged(
                            state,
                            currentItemState.copyWith(amountSpent: amountSpent),
                          );
                          _handleUpdate();
                        } else {
                          _logger.e('Invalid Parsing');
                        }
                      }
                    }
                        : _openDeclutterSheet, // Open declutter sheet if no changes
                    child: _isChanged ? Text(S.of(context).update) : Text(S.of(context).declutter),
                  ),
                ),
              ],
            ),
          );
        } catch (e) {
          _logger.e('Error retrieving item details: $e');
          return const Center(child: ClosetProgressIndicator(color: Colors.teal));
        }
      },
    );
  }
}
