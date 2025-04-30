import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../../core/data/models/closet_item_detailed.dart';
import '../../presentation/bloc/edit_item_bloc.dart';
import '../../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../core/widgets/button/upload_button_with_progress.dart';
import '../../presentation/widgets/edit_item_metadata.dart';
import '../../../../core/utilities/app_router.dart';
import '../../../declutter_items/presentation/widgets/declutter_options_bottom_sheet.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/photo_library/presentation/bloc/photo_library_bloc/photo_library_bloc.dart';

class EditItemMetadataWithButton extends StatefulWidget {
  final String itemId;
  final bool isPendingFlow;
  final VoidCallback? onPostUpdate;

  const EditItemMetadataWithButton({
    super.key,
    required this.itemId,
    required this.isPendingFlow,
    required this.onPostUpdate
  });

  @override
  State<EditItemMetadataWithButton> createState() => _EditItemMetadataWithButtonState();
}

class _EditItemMetadataWithButtonState extends State<EditItemMetadataWithButton> {
  late TextEditingController _itemNameController;
  late TextEditingController _amountSpentController;
  late FocusNode _amountSpentFocusNode;

  bool _metadataChanged = false;
  bool _isSubmitting = false;
  final _logger = CustomLogger('EditItemMetadataWithButton');

  Map<String, String> _validationErrors = {};

  @override
  void initState() {
    super.initState();
    _itemNameController = TextEditingController();
    _amountSpentController = TextEditingController();
    _amountSpentFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _amountSpentController.dispose();
    _amountSpentFocusNode.dispose();
    super.dispose();
  }

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

  ClosetItemDetailed getCurrentItem(EditItemState state) {
    if (state is EditItemLoaded) return state.item;
    if (state is EditItemMetadataChanged) return state.updatedItem;
    if (state is EditItemValidationFailure) return state.updatedItem;
    if (state is EditItemValidationSuccess) return state.validatedItem;
    if (state is EditItemSubmitting || state is EditItemUpdateSuccess) {
      return ClosetItemDetailed.empty();
    }
    return ClosetItemDetailed.empty(); // Prevent crash on EditItemInitial
  }

  void _handleUpdate() {
    final bloc = context.read<EditItemBloc>();
    final currentItem = getCurrentItem(bloc.state);
    final parsedAmount = double.tryParse(_amountSpentController.text);

    if (parsedAmount == null || parsedAmount < 0) {
      setState(() {
        _validationErrors['amount_spent'] = S.of(context).amountSpentFieldNotFilled;
        _metadataChanged = true;
      });
      return;
    }

    bloc.add(
      ValidateFormEvent(
        updatedItem: currentItem.copyWith(
          name: _itemNameController.text,
          amountSpent: parsedAmount,
        ),
        name: _itemNameController.text,
        amountSpent: parsedAmount,
        itemNameError: S.of(context).itemNameFieldNotFilled,
        amountSpentError: S.of(context).amountSpentFieldNotFilled,
        itemTypeError: S.of(context).itemTypeFieldNotFilled,
        occasionError: S.of(context).occasionFieldNotFilled,
        seasonError: S.of(context).seasonFieldNotFilled,
        colourError: S.of(context).colourFieldNotFilled,
        clothingTypeError: S.of(context).clothingTypeRequired,
        clothingLayerError: S.of(context).clothingLayerFieldNotFilled,
        accessoryTypeError: S.of(context).accessoryTypeRequired,
        shoesTypeError: S.of(context).shoesTypeRequired,
        colourVariationError: S.of(context).colourVariationFieldNotFilled,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<EditItemBloc, EditItemState>(
      listener: (context, state) {
        if (state is EditItemValidationFailure) {
          setState(() {
            _validationErrors = state.validationErrors;
            _metadataChanged = true;
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
        } else if (state is EditItemSubmitting) {
          setState(() => _isSubmitting = true);
        } else if (state is EditItemUpdateSuccess) {
          if (widget.isPendingFlow) {
            context.read<PhotoLibraryBloc>().add(CheckForPendingItems());
            widget.onPostUpdate?.call(); // trigger post-update callback if present
          } else {
            context.goNamed(AppRoutesName.myCloset);
          }
        } else if (state is EditItemUpdateFailure) {
          setState(() => _isSubmitting = false);
          CustomSnackbar(message: state.errorMessage, theme: theme).show(context);
        }
      },
      child: BlocBuilder<EditItemBloc, EditItemState>(
        builder: (context, state) {
          if (state is EditItemInitial || state is EditItemLoading || state is EditItemLoadFailure) {
            return const Center(child: ClosetProgressIndicator());
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

          final shouldShowUpdate = _metadataChanged || _validationErrors.isNotEmpty;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: EditItemMetadata(
                    currentItem: currentItem,
                    itemNameController: _itemNameController,
                    amountSpentController: _amountSpentController,
                    theme: theme,
                    validationErrors: _validationErrors,
                    onMetadataChanged: () => setState(() => _metadataChanged = true),
                    amountSpentFocusNode: _amountSpentFocusNode,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SafeArea(
                minimum: const EdgeInsets.only(bottom: 16.0), // adds extra space above system navbar
                child: Align(
                  alignment: Alignment.center,
                  child: UploadButtonWithProgress(
                    isLoading: _isSubmitting,
                    onPressed: widget.isPendingFlow
                        ? _handleUpdate
                        : (shouldShowUpdate ? _handleUpdate : _openDeclutterSheet),
                    text: widget.isPendingFlow
                        ? S.of(context).update
                        : (shouldShowUpdate ? S.of(context).update : S.of(context).declutter),
                    isFromMyCloset: true,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
