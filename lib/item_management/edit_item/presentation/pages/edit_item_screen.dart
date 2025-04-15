import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../../../core/widgets/bottom_sheet/premium_bottom_sheet/swap_premium_bottom_sheet.dart';
import '../../../../core/widgets/bottom_sheet/premium_bottom_sheet/metadata_premium_bottom_sheet.dart';
import '../../../../core/utilities/app_router.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/utilities/helper_functions/tutorial_helper.dart';
import '../../../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../../core/core_enums.dart';
import '../../presentation/widgets/edit_item_image_with_additional_features.dart';
import '../widgets/edit_item_metadata_button.dart';

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
  late FocusNode _amountSpentFocusNode;  // <-- Add this line
  String? _imageUrl;

  final _logger = CustomLogger('EditItemScreen');

  @override
  void initState() {
    super.initState();
    _amountSpentFocusNode = FocusNode();
    context.read<TutorialBloc>().add(
      const CheckTutorialStatus(TutorialType.freeEditCamera),
    );
    _logger.i('Initialized EditItemScreen with itemId: ${widget.itemId}');
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
    _logger.d('EditItemScreen build() called');
    final ThemeData myClosetTheme = Theme.of(context);

    return GestureDetector(
        onTap: _dismissKeyboard,
        behavior: HitTestBehavior.translucent,
        child: MultiBlocListener(
        listeners: [
        BlocListener<TutorialBloc, TutorialState>(
        listener: (context, tutorialState) {
      if (tutorialState is ShowTutorial) {
        _logger.i('Tutorial trigger detected, navigating to tutorial video pop-up');
        context.goNamed(
          AppRoutesName.tutorialVideoPopUp,
          extra: {
            'nextRoute': AppRoutesName.editItem,
            'tutorialInputKey': TutorialType.freeEditCamera.value,
            'isFromMyCloset': true,
            'itemId': widget.itemId,
          },
        );
      }
    },
    ),
    ],

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
                onImageTap: _navigateToPhotoProvider,
                onSwapPressed: _openSwapSheet,
                onMetadataPressed: _openMetadataSheet,
              ),

              // Metadata section is inside BlocBuilder to update when necessary.
              Expanded(
                  child: EditItemMetadataWithButton(
                    itemId: widget.itemId,
                    isPendingFlow: false,
                    onPostUpdate: () {
                      // This will wait for PhotoLibraryBloc to respond
                    },
                  )
          ),
        ]),
      ),
        )
    );
  }
}
