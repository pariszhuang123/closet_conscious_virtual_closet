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
  late FocusNode _amountSpentFocusNode;  // <-- Add this line
  String? _imageUrl;
  bool _isChanged = false;

  final _logger = CustomLogger('EditItemScreen');
  Map<String, String> _validationErrors = {};

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
    _amountSpentController = TextEditingController(); // ADD THIS
    _amountSpentFocusNode = FocusNode(); // <-- Initialize FocusNode here
    _logger.i('Initialized EditItemScreen with itemId: ${widget.itemId}');
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _amountSpentController.dispose(); // ADD THIS
    _amountSpentFocusNode.dispose(); // <-- Dispose FocusNode here
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


  // Handler: Dispatch validation event to the bloc.
  void _handleUpdate() {
    final currentItem = getCurrentItem(context.read<EditItemBloc>().state);
    final parsedAmount = double.tryParse(_amountSpentController.text);

    if (parsedAmount == null || parsedAmount < 0) {
      setState(() {
        _validationErrors['amount_spent'] = S.of(context).amountSpentFieldNotFilled;
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
        itemNameError: S.of(context).itemNameFieldNotFilled,
        amountSpentError: S.of(context).amountSpentFieldNotFilled,
        clothingTypeError: S.of(context).clothingTypeRequired,
        clothingLayerError: S.of(context).clothingLayerFieldNotFilled,
        accessoryTypeError: S.of(context).accessoryTypeRequired,
        shoesTypeError: S.of(context).shoesTypeRequired,
        colourVariationError: S.of(context).colourVariationFieldNotFilled,
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
    } else if (state is EditItemSubmitting) {
      _logger.i("EditItemUpdateSubmitting encountered. Returning an empty item.");
      return ClosetItemDetailed.empty(); // Return a default empty object to prevent crashes
    } else if (state is EditItemUpdateSuccess) {
      _logger.i("EditItemUpdateSuccess encountered. Returning an empty item.");
      return ClosetItemDetailed.empty(); // Return a default empty object to prevent crashes
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
              _logger.i("EditItemUpdateSuccess State. Navigate to myCloset");
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
      child: GestureDetector(
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
              // Image section remains outside BlocBuilder to avoid unnecessary refreshes.
              EditItemImageWithAdditionalFeatures(
                imageUrl: _imageUrl,
                isChanged: _isChanged,
                onImageTap: _navigateToPhotoProvider,
                onSwapPressed: _openSwapSheet,
                onMetadataPressed: _openMetadataSheet,
              ),

              // Metadata section is inside BlocBuilder to update when necessary.
              Expanded(
                child: BlocBuilder<EditItemBloc, EditItemState>(
                  builder: (context, state) {
                    if (state is EditItemInitial || state is EditItemLoading) {
                      return const Center(child: ClosetProgressIndicator());
                    }
                    if (state is EditItemLoadFailure) {
                      return const Center(child: Text('Failed to load item'));
                    }

                    final currentItem = getCurrentItem(state);
                    _itemNameController.text = currentItem.name;
                    if (!_amountSpentController.text.endsWith(".") &&
                        !_amountSpentFocusNode.hasFocus &&
                        _amountSpentController.text != currentItem.amountSpent.toString()) {
                      _amountSpentController.text = currentItem.amountSpent.toString();
                      _amountSpentController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _amountSpentController.text.length),
                      );
                    }

                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(16.0),
                      child: EditItemMetadata(
                        currentItem: currentItem, // ✅ ADD THIS LINE
                        itemNameController: _itemNameController,
                        amountSpentController: _amountSpentController,
                        theme: myClosetTheme,
                        validationErrors: _validationErrors,
                        onMetadataChanged: () {
                          setState(() {
                            _isChanged = true;
                          });
                        },
                        amountSpentFocusNode: _amountSpentFocusNode,
                      ),
                    );
                  },
                ),
              ),

              // Update Button
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
      ),
    );
  }
}
