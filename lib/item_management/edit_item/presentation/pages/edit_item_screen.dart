import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../../../core/widgets/bottom_sheet/premium_bottom_sheet/swap_premium_bottom_sheet.dart';
import '../../../../core/widgets/bottom_sheet/premium_bottom_sheet/metadata_premium_bottom_sheet.dart';
import '../../../../core/utilities/app_router.dart';
import '../../../../core/utilities/logger.dart';
import '../../../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../presentation/bloc/edit_item_bloc.dart';
import '../../../../core/core_enums.dart';
import '../../../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../presentation/widgets/edit_item_image_with_additional_features.dart';
import '../widgets/edit_item_metadata_button.dart';
import '../../../../core/theme/my_closet_theme.dart';
import 'edit_item_listeners.dart';

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
  late FocusNode _amountSpentFocusNode;
  String? _imageUrl;

  final _logger = CustomLogger('EditItemScreen');

  @override
  void initState() {
    super.initState();
    _amountSpentFocusNode = FocusNode();
    context.read<TutorialBloc>().add(const CheckTutorialStatus(TutorialType.freeEditCamera));
    _logger.i('Initialized EditItemScreen with itemId: ${widget.itemId}');
  }

  @override
  void dispose() {
    _amountSpentFocusNode.dispose();
    _logger.i('Disposed controllers');
    super.dispose();
  }

  void _dismissKeyboard() {
    FocusScope.of(context).unfocus();
  }

  void _navigateToPhotoProvider() {
    _logger.d('Navigating to PhotoProvider for itemId: ${widget.itemId}');
    context.pushNamed(AppRoutesName.editPhoto, extra: widget.itemId);
  }

  void _openSwapSheet() {
    _logger.d('Opening swap sheet for itemId: ${widget.itemId}');
    showModalBottomSheet(
      context: context,
      builder: (context) => const SwapFeatureBottomSheet(isFromMyCloset: true),
    );
  }

  void _openMetadataSheet() {
    _logger.d('Opening metadata sheet for itemId: ${widget.itemId}');
    showModalBottomSheet(
      context: context,
      builder: (context) => const MetadataFeatureBottomSheet(isFromMyCloset: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building EditItemScreen');
    final theme = myClosetTheme; // ✅ Force myClosetTheme

    return Theme(
      data: theme,
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          _logger.i('Pop invoked: didPop = $didPop, result = $result');
          if (!didPop) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.goNamed(AppRoutesName.myCloset);
            });
          }
        },
        child: GestureDetector(
          onTap: _dismissKeyboard,
          behavior: HitTestBehavior.translucent,
          child: EditItemListeners(
            itemId: widget.itemId,
            logger: _logger,
            child: Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                leading: BackButton(
                  onPressed: () {
                    final navigator = Navigator.of(context);
                    if (navigator.canPop()) {
                      _logger.i('Navigator can pop, popping');
                      navigator.pop();
                    } else {
                      _logger.i('Navigator cannot pop, fallback to MyCloset');
                      context.goNamed(AppRoutesName.myCloset);
                    }
                  },
                ),
                title: Text(
                  S.of(context).editPageTitle,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              body: BlocBuilder<EditItemBloc, EditItemState>(
                builder: (context, state) {
                  if (state is EditItemLoading || state is EditItemInitial) {
                    _logger.i('Showing loading spinner while item is loading');
                    return const Center(child: ClosetProgressIndicator());
                  } else if (state is EditItemLoaded ||
                      state is EditItemMetadataChanged ||
                      state is EditItemValidationFailure ||
                      state is EditItemValidationSuccess) {
                    _logger.i('Building EditItemScreen content with loaded state');
                    return Column(
                      children: [
                        EditItemImageWithAdditionalFeatures(
                          imageUrl: _imageUrl,
                          onImageTap: _navigateToPhotoProvider,
                          onSwapPressed: _openSwapSheet,
                          onMetadataPressed: _openMetadataSheet,
                        ),
                        Expanded(
                          child: EditItemMetadataWithButton(
                            itemId: widget.itemId,
                            isPendingFlow: false,
                            onPostUpdate: () {
                              // Handle post-update if necessary
                            },
                          ),
                        ),
                      ],
                    );
                  } else {
                    _logger.e('Unexpected state, showing empty fallback');
                    return const SizedBox.shrink();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
