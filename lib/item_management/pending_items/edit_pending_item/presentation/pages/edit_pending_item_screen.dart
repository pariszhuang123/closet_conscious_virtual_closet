import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../edit_item/presentation/bloc/edit_item_bloc.dart';
import '../../../../../core/widgets/bottom_sheet/premium_bottom_sheet/swap_premium_bottom_sheet.dart';
import '../../../../../core/widgets/bottom_sheet/premium_bottom_sheet/metadata_premium_bottom_sheet.dart';
import '../../../../../core/utilities/app_router.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../edit_item/presentation/widgets/edit_item_image_with_additional_features.dart';
import '../../../../../core/photo_library/presentation/bloc/photo_library_bloc.dart';
import '../widgets/show_edit_pending_success_dialog.dart';
import '../../../../edit_item/presentation/widgets/edit_item_metadata_button.dart';

class EditPendingItemScreen extends StatefulWidget {
  final String itemId;

  const EditPendingItemScreen({
    super.key,
    required this.itemId,
  });

  @override
  State<EditPendingItemScreen> createState() => _EditPendingItemScreenState();
}

class _EditPendingItemScreenState extends State<EditPendingItemScreen> {
  late FocusNode _amountSpentFocusNode;  // <-- Add this line
  String? _imageUrl;

  final _logger = CustomLogger('EditPendingItemScreen');

  @override
  void initState() {

    super.initState();
    _amountSpentFocusNode = FocusNode(); // <-- Initialize FocusNode here
    _logger.i('Initialized EditPendingItemScreen with itemId: ${widget.itemId}');
  }

  @override
  void dispose() {
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
    context.pushNamed(
      AppRoutesName.editPhoto,
      extra: widget.itemId,
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
  }



  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [

        BlocListener<PhotoLibraryBloc, PhotoLibraryState>(
          listener: (context, state) {
            if (state is PhotoLibraryPendingItem) {
              showEditPendingSuccessDialog(
                context,
                Theme.of(context),
                onConfirm: () {
                  context.read<EditItemBloc>().add(FetchMostRecentPendingItemIdEvent());
                },
              );
            } else if (state is PhotoLibraryNoPendingItem) {
              context.goNamed(AppRoutesName.myCloset);
            }
          },
        ),
        BlocListener<EditItemBloc, EditItemState>(
          listener: (context, state) {
            if (state is EditItemPendingItemIdFetched) {
              context.goNamed(
                  AppRoutesName.editPendingItem,
                  extra: {
                    'itemId': state.itemId,
                  }
              );
            }
          },
        ),
      ],
      child: GestureDetector(
        onTap: _dismissKeyboard,
        behavior: HitTestBehavior.translucent,
          child: Column(
            children: [
              // Image section remains outside BlocBuilder to avoid unnecessary refreshes.
              EditItemImageWithAdditionalFeatures(
                imageUrl: _imageUrl,
                onImageTap: _navigateToPhotoProvider,
                onSwapPressed: _openSwapSheet,
                onMetadataPressed: _openMetadataSheet,
              ),

              // Metadata section is inside BlocBuilder to update when necessary.
        Expanded(
          child: EditItemMetadataWithButton(
            itemId: widget.itemId,
            isPendingFlow: true,
            onPostUpdate: () {
              // This will wait for PhotoLibraryBloc to respond
            },
              ),
        )
            ],
          ),
        ),
      );
  }
}
