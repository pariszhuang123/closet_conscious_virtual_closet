import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../presentation/bloc/edit_item_bloc.dart';
import '../../declutter_items/presentation/widgets/declutter_options_bottom_sheet.dart';
import '../../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../generated/l10n.dart';
import '../../../core/widgets/button/navigation_type_button.dart';
import '../../../core/widgets/bottom_sheet/premium_bottom_sheet/swap_premium_bottom_sheet.dart';
import '../../../core/data/type_data.dart';
import '../../../core/utilities/routes.dart';
import '../../../core/widgets/layout/icon_row_builder.dart';
import '../../../core/photo/presentation/widgets/image_display_widget.dart';
import '../../../core/theme/themed_svg.dart';
import '../../core/data/models/closet_item_detailed.dart';
import '../../../core/utilities/logger.dart';
import '../../../core/widgets/feedback/custom_snack_bar.dart';

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

    final swapData = TypeDataList.swapItem(context);

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
          // Get the current item safely using getCurrentItem
          ClosetItemDetailed currentItem = getCurrentItem(state);

          return Scaffold(
            appBar: AppBar(
              title: Text(S.of(context).editPageTitle),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Image and Swap Button in a Stack
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.25,
                        child: Stack(
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (!_isChanged) {
                                    // Navigate to PhotoProvider for image editing if no changes
                                    _navigateToPhotoProvider();
                                  } else {
                                    // Show custom snackbar if changes were made
                                    CustomSnackbar(
                                      message: S.of(context).unsavedChangesMessage,  // Correctly reference 'context'
                                      theme: Theme.of(context),  // Provide the current theme
                                    ).show(context);
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16.0),
                                  child: ImageDisplayWidget(
                                    imageUrl: _imageUrl,  // Display the current image or placeholder
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              bottom: 0,
                              child: NavigationTypeButton(
                                label: swapData.getName(context),
                                selectedLabel: '',
                                onPressed: _openSwapSheet,  // Open the swap bottom sheet
                                assetPath: swapData.assetPath,
                                isFromMyCloset: true,
                                buttonType: ButtonType.secondary,
                                usePredefinedColor: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Metadata Form
                      TextFormField(
                        controller: _itemNameController,
                        decoration: InputDecoration(
                          labelText: S.of(context).item_name,
                          labelStyle: myClosetTheme.textTheme.bodyMedium,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).pleaseEnterItemName;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _isChanged = true;
                          });
                          final currentItemState = getCurrentItem(state);
                          _dispatchMetadataChanged(state, currentItemState.copyWith(name: value));
                        },
                      ),
                      const SizedBox(height: 12),

                      TextFormField(
                        controller: _amountSpentController,
                        decoration: InputDecoration(
                          labelText: S.of(context).amountSpentLabel,
                          hintText: S.of(context).enterAmountSpentHint,
                          labelStyle: myClosetTheme.textTheme.bodyMedium,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return S.of(context).enterAmountSpentHint;
                          }
                          final parsedValue = double.tryParse(value);
                          if (parsedValue == null || parsedValue < 0) {
                            return S.of(context).please_enter_valid_amount;
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            _isChanged = true;
                          });
                        },
                      ),
                      const SizedBox(height: 12),

                      // Icon Row Builder
                      Text(S.of(context).selectItemType, style: myClosetTheme.textTheme.bodyMedium),
                      ...buildIconRows(
                        TypeDataList.itemGeneralTypes(context),
                        currentItem.itemType,  // Access the itemType safely
                            (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });
                          _dispatchMetadataChanged(state, currentItem.copyWith(itemType: dataKey));
                        },
                        context,
                        true,
                      ),
                      const SizedBox(height: 12),

                      // Occasion Selection
                      Text(S.of(context).selectOccasion, style: myClosetTheme.textTheme.bodyMedium),
                      ...buildIconRows(
                        TypeDataList.occasions(context),
                        currentItem.occasion,  // Access the occasion safely
                            (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });
                          _dispatchMetadataChanged(state, currentItem.copyWith(occasion: dataKey));
                        },
                        context,
                        true,
                      ),
                      const SizedBox(height: 12),

                      // Season Selection
                      Text(S.of(context).selectSeason, style: myClosetTheme.textTheme.bodyMedium),
                      ...buildIconRows(
                        TypeDataList.seasons(context),
                        currentItem.season,  // Access the season safely
                            (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });
                          _dispatchMetadataChanged(state, currentItem.copyWith(season: dataKey));
                        },
                        context,
                        true,
                      ),
                      const SizedBox(height: 12),

                      // Shoe Type Selection (for shoes)
                      if (currentItem.itemType == 'shoes') ...[
                        Text(S.of(context).selectShoeType, style: myClosetTheme.textTheme.bodyMedium),
                        ...buildIconRows(
                          TypeDataList.shoeTypes(context),
                          currentItem.shoesType,  // Access the shoesType safely
                              (dataKey) {
                            setState(() {
                              _isChanged = true;
                            });
                            _dispatchMetadataChanged(state, currentItem.copyWith(shoesType: dataKey));
                          },
                          context,
                          true,
                        ),
                      ],
                      const SizedBox(height: 12),

                      // Accessory Type Selection (for accessories)
                      if (currentItem.itemType == 'accessory') ...[
                        Text(S.of(context).selectAccessoryType, style: myClosetTheme.textTheme.bodyMedium),
                        ...buildIconRows(
                          TypeDataList.accessoryTypes(context),
                          currentItem.accessoryType,  // Access the accessoryType safely
                              (dataKey) {
                            setState(() {
                              _isChanged = true;
                            });
                            _dispatchMetadataChanged(state, currentItem.copyWith(accessoryType: dataKey));
                          },
                          context,
                          true,
                        ),
                      ],
                      const SizedBox(height: 12),

                      // Clothing Type and Layer Selection (for clothing)
                      if (currentItem.itemType == 'clothing') ...[
                        // Clothing Type Selection
                        Text(S.of(context).selectClothingType, style: myClosetTheme.textTheme.bodyMedium),
                        ...buildIconRows(
                          TypeDataList.clothingTypes(context),
                          currentItem.clothingType,  // Access the clothingType safely
                              (dataKey) {
                            setState(() {
                              _isChanged = true;
                            });
                            _dispatchMetadataChanged(state, currentItem.copyWith(clothingType: dataKey));
                          },
                          context,
                          true,
                        ),
                        const SizedBox(height: 12),

                        // Clothing Layer Selection
                        Text(S.of(context).selectClothingLayer, style: myClosetTheme.textTheme.bodyMedium),
                        ...buildIconRows(
                          TypeDataList.clothingLayers(context),
                          currentItem.clothingLayer,  // Access the clothingLayer safely
                              (dataKey) {
                            setState(() {
                              _isChanged = true;
                            });
                            _dispatchMetadataChanged(state, currentItem.copyWith(clothingLayer: dataKey));
                          },
                          context,
                          true,
                        ),
                      ],
                      const SizedBox(height: 12),

                      // Colour Selection
                      Text(S.of(context).selectColour, style: myClosetTheme.textTheme.bodyMedium),
                      ...buildIconRows(
                        TypeDataList.colors(context),
                        currentItem.colour,  // Access the colour safely
                            (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });
                          _dispatchMetadataChanged(state, currentItem.copyWith(colour: dataKey));
                        },
                        context,
                        true,
                      ),
                      const SizedBox(height: 12),

                      // Colour Variation Selection (if colour is not black or white)
                      if (currentItem.colour != 'black' && currentItem.colour != 'white') ...[
                        Text(S.of(context).selectColourVariation, style: myClosetTheme.textTheme.bodyMedium),
                        ...buildIconRows(
                          TypeDataList.colorVariations(context),
                          currentItem.colourVariations,  // Access the colourVariations safely
                              (dataKey) {
                            setState(() {
                              _isChanged = true;
                            });
                            _dispatchMetadataChanged(state, currentItem.copyWith(colourVariations: dataKey));
                          },
                          context,
                          true,
                        ),
                      ],
                      const SizedBox(height: 12),

                      ElevatedButton(
                        onPressed: _isChanged
                            ? () {
                          // Perform validation first
                          if (_formKey.currentState?.validate() ?? false) {
                            // Parse the amountSpent from the controller
                            final value = _amountSpentController.text;
                            final double? amountSpent = double.tryParse(value);

                            if (amountSpent != null) {
                              // Valid amount, proceed with update
                              final currentItemState = getCurrentItem(state);
                              _dispatchMetadataChanged(
                                state,
                                currentItemState.copyWith(amountSpent: amountSpent),
                              );
                              _handleUpdate();
                            } else {
                              // Handle invalid parsing (null value)
                              _logger.e('Invalid Parsing');
                              // You can also show an error or prevent the form from proceeding.
                            }
                          }
                        }
                            : _openDeclutterSheet, // Open declutter sheet if no changes
                        child: _isChanged ? Text(S.of(context).update) : Text(S.of(context).declutter),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } catch (e) {
          // In case of invalid state or errors, show a fallback indicator
          _logger.e('Error retrieving item details: $e');
          return const Center(child: ClosetProgressIndicator(color: Colors.teal));
        }
      },
    );
  }
}
