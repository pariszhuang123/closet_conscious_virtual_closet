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
  late final TextEditingController _itemNameController;
  late final TextEditingController _amountSpentController;
  String? _imageUrl;
  bool _isChanged = false;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
    _amountSpentController = TextEditingController();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _amountSpentController.dispose();
    super.dispose();
  }

  // Route the user to PhotoProvider for image editing
  void _navigateToPhotoProvider() {
    Navigator.pushNamed(
      context,
      AppRoutes.editPhoto, // Use your custom route name defined in AppRoutes
      arguments: widget.itemId, // Pass itemId as an argument
    );
  }

  // Open the declutter bottom sheet
  void _openDeclutterSheet() {
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

// Handle form submission via BLoC
  void _handleUpdate() {
    if (_formKey.currentState?.validate() ?? false) {
      final currentState = context.read<EditItemBloc>().state;

      // Ensure we have the current state and it's either loaded or metadata has changed
      if (currentState is EditItemLoaded || currentState is EditItemMetadataChanged) {
        final item = currentState is EditItemLoaded
            ? (currentState).item
            : (currentState as EditItemMetadataChanged).updatedItem;

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

  @override
  Widget build(BuildContext context) {
    final ThemeData myClosetTheme = Theme.of(context);

    final swapData = TypeDataList.swapItem(context);

    return BlocConsumer<EditItemBloc, EditItemState>(
      listener: (context, state) {
        if (state is EditItemUpdateSuccess) {
          Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
        } else if (state is EditItemUpdateFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('state.error')),
          );
        }
      },
      builder: (context, state) {
        if (state is EditItemInitial || state is EditItemLoading) {
          return const Center(child: ClosetProgressIndicator(color: Colors.teal));
        }
        if (state is EditItemLoadFailure) {
          return const Center(child: Text('Failed to load item'));
        }

        ClosetItemDetailed? currentItem;

        if (state is EditItemLoaded) {
          currentItem = state.item; // Use the item loaded from the initial load
        } else if (state is EditItemMetadataChanged) {
          currentItem = state.updatedItem; // Use the updated item with new metadata
        }

        // If currentItem is still null, return an error or loading indicator
        if (currentItem == null) {
          return const Center(child: ClosetProgressIndicator(color: Colors.teal));
        }

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
                              onTap: _navigateToPhotoProvider,  // Navigate to PhotoProvider for image editing
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
                              onPressed: () => _openSwapSheet,  // Open the swap bottom sheet
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
                        // Check if state is EditItemLoaded or EditItemMetadataChanged
                        if (state is EditItemLoaded || state is EditItemMetadataChanged) {
                          final currentItemState = state is EditItemLoaded
                              ? (state).item
                              : (state as EditItemMetadataChanged).updatedItem;

                          // Dispatch MetadataChangedEvent with the updated ClosetItemDetailed object
                          context.read<EditItemBloc>().add(
                            MetadataChangedEvent(
                              updatedItem: currentItemState.copyWith(
                                amountSpent: double.tryParse(value) ?? 0, // Ensure it's parsed as a number
                              ),
                            ),
                          );
                        }
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
                      onChanged: (value) {
                        setState(() {
                          _isChanged = true;
                        });

                        // Check if state is EditItemLoaded or EditItemMetadataChanged
                        if (state is EditItemLoaded || state is EditItemMetadataChanged) {
                          final currentItemState = state is EditItemLoaded
                              ? (state).item
                              : (state as EditItemMetadataChanged).updatedItem;

                          // Dispatch MetadataChangedEvent with the updated ClosetItemDetailed object
                          context.read<EditItemBloc>().add(
                            MetadataChangedEvent(
                              updatedItem: currentItemState.copyWith(name: value), // Update the name field
                            ),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),

                    Text(S.of(context).selectItemType, style: myClosetTheme.textTheme.bodyMedium),
                    ...buildIconRows(
                      TypeDataList.itemGeneralTypes(context),
                      state is EditItemLoaded
                          ? (state).item.itemType
                          : (state as EditItemMetadataChanged).updatedItem.itemType,  // Access the itemType safely
                          (dataKey) {
                        setState(() {
                          _isChanged = true;
                        });

                        // Check if state is EditItemLoaded or EditItemMetadataChanged
                        if (state is EditItemLoaded || state is EditItemMetadataChanged) {
                          final currentItemState = state is EditItemLoaded
                              ? (state).item
                              : (state as EditItemMetadataChanged).updatedItem;

                          // Dispatch MetadataChangedEvent with the updated ClosetItemDetailed object
                          context.read<EditItemBloc>().add(
                            MetadataChangedEvent(
                              updatedItem: currentItemState.copyWith(itemType: dataKey), // Update the itemType field
                            ),
                          );
                        }
                      },
                      context,
                      true,
                    ),
                    const SizedBox(height: 12),

                    // Occasion Selection
                    Text(
                      S.of(context).selectOccasion,
                      style: myClosetTheme.textTheme.bodyMedium,
                    ),
                    ...buildIconRows(
                      TypeDataList.occasions(context),
                      state is EditItemLoaded
                          ? (state).item.occasion
                          : (state as EditItemMetadataChanged).updatedItem.occasion,  // Access the occasion safely
                          (dataKey) {
                        setState(() {
                          _isChanged = true;
                        });

                        // Check if state is EditItemLoaded or EditItemMetadataChanged
                        if (state is EditItemLoaded || state is EditItemMetadataChanged) {
                          final currentItemState = state is EditItemLoaded
                              ? (state).item
                              : (state as EditItemMetadataChanged).updatedItem;

                          // Dispatch MetadataChangedEvent with the updated ClosetItemDetailed object
                          context.read<EditItemBloc>().add(
                            MetadataChangedEvent(
                              updatedItem: currentItemState.copyWith(occasion: dataKey),  // Update the occasion field
                            ),
                          );
                        }
                      },
                      context,
                      true,
                    ),
                    const SizedBox(height: 12),

// Season Selection
                    Text(
                      S.of(context).selectSeason,
                      style: myClosetTheme.textTheme.bodyMedium,
                    ),
                    ...buildIconRows(
                      TypeDataList.seasons(context),
                      state is EditItemLoaded
                          ? (state).item.season
                          : (state as EditItemMetadataChanged).updatedItem.season,  // Access the season safely
                          (dataKey) {
                        setState(() {
                          _isChanged = true;
                        });

                        // Check if state is EditItemLoaded or EditItemMetadataChanged
                        if (state is EditItemLoaded || state is EditItemMetadataChanged) {
                          final currentItemState = state is EditItemLoaded
                              ? (state).item
                              : (state as EditItemMetadataChanged).updatedItem;

                          // Dispatch MetadataChangedEvent with the updated ClosetItemDetailed object
                          context.read<EditItemBloc>().add(
                            MetadataChangedEvent(
                              updatedItem: currentItemState.copyWith(season: dataKey),  // Update the season field
                            ),
                          );
                        }
                      },
                      context,
                      true,
                    ),
                    const SizedBox(height: 12),

// Shoe Type Selection (for shoes)
// Conditional rendering for shoeType selection based on itemType
                    if ((state is EditItemLoaded && (state).item.itemType == 'shoes') ||
                        (state is EditItemMetadataChanged && (state).updatedItem.itemType == 'shoes')) ...[
                      // Shoe Type Selection
                      Text(S.of(context).selectShoeType, style: myClosetTheme.textTheme.bodyMedium),
                      ...buildIconRows(
                        TypeDataList.shoeTypes(context),
                        state is EditItemLoaded
                            ? (state).item.shoesType
                            : (state as EditItemMetadataChanged).updatedItem.shoesType,  // Access the shoesType safely
                            (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });

                          // Check if state is EditItemLoaded or EditItemMetadataChanged
                          if (state is EditItemLoaded || state is EditItemMetadataChanged) {
                            final currentItemState = state is EditItemLoaded
                                ? (state).item
                                : (state as EditItemMetadataChanged).updatedItem;

                            // Dispatch MetadataChangedEvent with the updated ClosetItemDetailed object
                            context.read<EditItemBloc>().add(
                              MetadataChangedEvent(
                                updatedItem: currentItemState.copyWith(shoesType: dataKey), // Update the shoesType field
                              ),
                            );
                          }
                        },
                        context,
                        true,
                      ),
                    ],
                    const SizedBox(height: 12),

// Accessory Type Selection (for accessories)
                    if ((state is EditItemLoaded && (state).item.itemType == 'accessory') ||
                        (state is EditItemMetadataChanged && (state).updatedItem.itemType == 'accessory')) ...[
                      Text(
                        S.of(context).selectAccessoryType,
                        style: myClosetTheme.textTheme.bodyMedium,
                      ),
                      ...buildIconRows(
                        TypeDataList.accessoryTypes(context),
                        state is EditItemLoaded
                            ? (state).item.accessoryType
                            : (state as EditItemMetadataChanged).updatedItem.accessoryType,  // Access the accessoryType safely
                            (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });

                          // Check if state is EditItemLoaded or EditItemMetadataChanged
                          if (state is EditItemLoaded || state is EditItemMetadataChanged) {
                            final currentItemState = state is EditItemLoaded
                                ? (state).item
                                : (state as EditItemMetadataChanged).updatedItem;

                            // Dispatch MetadataChangedEvent with the updated ClosetItemDetailed object
                            context.read<EditItemBloc>().add(
                              MetadataChangedEvent(
                                updatedItem: currentItemState.copyWith(accessoryType: dataKey),  // Update the accessoryType field
                              ),
                            );
                          }
                        },
                        context,
                        true,
                      ),
                    ],
                    const SizedBox(height: 12),
                    const SizedBox(height: 12),

// Conditional rendering for clothingType and clothingLayer based on itemType
                    if ((state is EditItemLoaded && (state).item.itemType == 'clothing') ||
                        (state is EditItemMetadataChanged && (state).updatedItem.itemType == 'clothing')) ...[

                      // Clothing Type Selection
                      Text(
                        S.of(context).selectClothingType,
                        style: myClosetTheme.textTheme.bodyMedium,
                      ),
                      ...buildIconRows(
                        TypeDataList.clothingTypes(context),
                        state is EditItemLoaded
                            ? (state).item.clothingType
                            : (state as EditItemMetadataChanged).updatedItem.clothingType,  // Access the clothingType safely
                            (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });

                          // Check if state is EditItemLoaded or EditItemMetadataChanged
                          if (state is EditItemLoaded || state is EditItemMetadataChanged) {
                            final currentItemState = state is EditItemLoaded
                                ? (state).item
                                : (state as EditItemMetadataChanged).updatedItem;

                            // Dispatch MetadataChangedEvent with the updated ClosetItemDetailed object
                            context.read<EditItemBloc>().add(
                              MetadataChangedEvent(
                                updatedItem: currentItemState.copyWith(clothingType: dataKey),  // Update the clothingType field
                              ),
                            );
                          }
                        },
                        context,
                        true,
                      ),
                      const SizedBox(height: 12),

                      // Clothing Layer Selection
                      Text(
                        S.of(context).selectClothingLayer,
                        style: myClosetTheme.textTheme.bodyMedium,
                      ),
                      ...buildIconRows(
                        TypeDataList.clothingLayers(context),
                        state is EditItemLoaded
                            ? (state).item.clothingLayer
                            : (state as EditItemMetadataChanged).updatedItem.clothingLayer,  // Access the clothingLayer safely
                            (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });

                          // Check if state is EditItemLoaded or EditItemMetadataChanged
                          if (state is EditItemLoaded || state is EditItemMetadataChanged) {
                            final currentItemState = state is EditItemLoaded
                                ? (state).item
                                : (state as EditItemMetadataChanged).updatedItem;

                            // Dispatch MetadataChangedEvent with the updated ClosetItemDetailed object
                            context.read<EditItemBloc>().add(
                              MetadataChangedEvent(
                                updatedItem: currentItemState.copyWith(clothingLayer: dataKey),  // Update the clothingLayer field
                              ),
                            );
                          }
                        },
                        context,
                        true,
                      ),
                    ],

// Colour Selection
                    Text(
                      S.of(context).selectColour,
                      style: myClosetTheme.textTheme.bodyMedium,
                    ),
                    ...buildIconRows(
                      TypeDataList.colors(context),
                      state is EditItemLoaded
                          ? (state).item.colour
                          : (state as EditItemMetadataChanged).updatedItem.colour,  // Access the colour safely
                          (dataKey) {
                        setState(() {
                          _isChanged = true;
                        });

                        // Check if state is EditItemLoaded or EditItemMetadataChanged
                        if (state is EditItemLoaded || state is EditItemMetadataChanged) {
                          final currentItemState = state is EditItemLoaded
                              ? (state).item
                              : (state as EditItemMetadataChanged).updatedItem;

                          // Dispatch MetadataChangedEvent with the updated ClosetItemDetailed object
                          context.read<EditItemBloc>().add(
                            MetadataChangedEvent(
                              updatedItem: currentItemState.copyWith(colour: dataKey),  // Update the colour field
                            ),
                          );
                        }
                      },
                      context,
                      true,
                    ),

// Check if selectedColour is not 'black', 'white', or null to display colour variations
                    if ((state is EditItemLoaded && (state).item.colour != 'black' && (state).item.colour != 'white') ||
                        (state is EditItemMetadataChanged && (state).updatedItem.colour != 'black' && (state).updatedItem.colour != 'white')) ...[

                      const SizedBox(height: 12),

                      Text(
                        S.of(context).selectColourVariation,
                        style: myClosetTheme.textTheme.bodyMedium,
                      ),
                      ...buildIconRows(
                        TypeDataList.colorVariations(context),
                        state is EditItemLoaded
                            ? (state).item.colourVariations
                            : (state as EditItemMetadataChanged).updatedItem.colourVariations,  // Access the colourVariations safely
                            (dataKey) {
                          setState(() {
                            _isChanged = true;
                          });

                          // Check if state is EditItemLoaded or EditItemMetadataChanged
                          if (state is EditItemLoaded || state is EditItemMetadataChanged) {
                            final currentItemState = state is EditItemLoaded
                                ? (state).item
                                : (state as EditItemMetadataChanged).updatedItem;

                            // Dispatch MetadataChangedEvent with the updated ClosetItemDetailed object
                            context.read<EditItemBloc>().add(
                              MetadataChangedEvent(
                                updatedItem: currentItemState.copyWith(colourVariations: dataKey),  // Update the colourVariations field
                              ),
                            );
                          }
                        },
                        context,
                        true,
                      ),
                    ],


                    ElevatedButton(
                      onPressed: _isChanged ? _handleUpdate : null,
                      child: Text(S.of(context).update),
                    ),
                    if (!_isChanged)
                      ElevatedButton(
                        onPressed: _openDeclutterSheet,
                        child: Text(S.of(context).declutter),
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
