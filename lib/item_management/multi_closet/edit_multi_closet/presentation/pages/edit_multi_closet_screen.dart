import 'package:closet_conscious/core/core_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/edit_multi_closet_bloc/edit_multi_closet_bloc.dart';
import '../../../../view_items/presentation/bloc/view_items_bloc.dart';
import '../../../../../core/widgets/layout/grid/interactive_item_grid.dart';
import '../widgets/edit_multi_closet_metadata.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../core/data/items_enums.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/app_router.dart';
import '../../../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../widgets/edit_closet_action_button.dart';
import '../../../../core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../core/presentation/widgets/multi_closet_feature_container.dart';
import '../bloc/edit_closet_metadata_bloc/edit_closet_metadata_bloc.dart';
import '../widgets/multi_closet_archive_feature_container.dart';
import '../widgets/archive_bottom_sheet.dart';
import '../widgets/edit_closet_image.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';

class EditMultiClosetScreen extends StatefulWidget {
  final List<String> selectedItemIds;

  const EditMultiClosetScreen({
    super.key,
    required this.selectedItemIds,
  });

  @override
  State<EditMultiClosetScreen> createState() => _EditMultiClosetScreenState();
}

class _EditMultiClosetScreenState extends State<EditMultiClosetScreen> {
  final TextEditingController closetNameController = TextEditingController();
  final TextEditingController monthsController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final CustomLogger logger = CustomLogger('EditMultiClosetScreen');

  Map<String, String> validationErrors = {}; // Add validation errors map

  @override
  void initState() {
    super.initState();
    logger.i('EditMultiClosetScreen initialized');
    context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
    context.read<ViewItemsBloc>().add(FetchItemsEvent(0, isPending: false));
    context.read<EditClosetMetadataBloc>().add(FetchMetadataEvent());

    // Add scroll listener for infinite scrolling
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        final viewItemsBloc = context.read<ViewItemsBloc>();
        final currentState = viewItemsBloc.state;

        if (currentState is ItemsLoaded) {
          final currentPage = currentState.currentPage;
          context.read<ViewItemsBloc>().add(FetchItemsEvent(currentPage, isPending: false));
        }
      }
    });
  }

  void _navigateToPhotoProvider() {
    final metadataState = context.read<EditClosetMetadataBloc>().state;

    if (metadataState is EditClosetMetadataAvailable) {
      final closetId = metadataState.metadata.closetId;
      logger.d('Navigating to PhotoProvider with closetId: $closetId');
      context.pushNamed(
        AppRoutesName.editClosetPhoto,
        extra: closetId, // Pass the correct closetId
      );
    } else {
      logger.e('Unable to navigate to PhotoProvider: Metadata not available.');
      CustomSnackbar(
        message: S.of(context).failedToLoadMetadata,
        theme: Theme.of(context),
      ).show(context);
    }
  }

  void _onFilterButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedItemIds = context.read<MultiSelectionItemCubit>().state.selectedItemIds;
    context.pushNamed(
      AppRoutesName.filter,
      extra: {
        'isFromMyCloset': true,
        'selectedItemIds': selectedItemIds,
        'returnRoute': AppRoutesName.editMultiCloset,
      },
    );
  }

  void _onArrangeButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedItemIds = context.read<MultiSelectionItemCubit>().state.selectedItemIds;
    context.pushNamed(
      AppRoutesName.customize,
      extra: {
        'isFromMyCloset': true,
        'selectedItemIds': selectedItemIds,
        'returnRoute': AppRoutesName.editMultiCloset,
      },
    );
  }


  void _onResetButtonPressed(BuildContext context) {
    // Trigger clearSelection in SelectionItemCubit
    context.read<MultiSelectionItemCubit>().clearSelection();
  }

  void _onSelectAllButtonPressed(BuildContext context) {
    // Retrieve the list of all items from the ViewItemsBloc
    final viewItemsState = context.read<ViewItemsBloc>().state;

    if (viewItemsState is ItemsLoaded) {
      // Extract all item IDs from the loaded items
      final allItemIds = viewItemsState.items.map((item) => item.itemId).toList();

      // Trigger the "Select All" functionality
      context.read<MultiSelectionItemCubit>().selectAll(allItemIds);
    } else {
      logger.e('Unable to select all items. Items not loaded.');
      CustomSnackbar(
        message: S.of(context).failedToLoadItems,
        theme: Theme.of(context),
      ).show(context);
    }
  }

  void _onArchiveButtonPressed() {
    final metadataState = context.read<EditClosetMetadataBloc>().state;

    if (metadataState is EditClosetMetadataAvailable) {
      final closetId = metadataState.metadata.closetId; // Get closetId from state
      logger.d('Opening archive sheet for closetId: $closetId');

      showModalBottomSheet(
        context: context,
        builder: (context) => ArchiveBottomSheet(
          closetId: closetId, // Pass the closetId
          theme: Theme.of(context),
        ),
      );
    } else {
      logger.e('Unable to archive: Metadata not available.');
      CustomSnackbar(
        message: S.of(context).failedToLoadMetadata,
        theme: Theme.of(context),
      ).show(context);
    }
  }

  void _navigateToMyCloset(BuildContext context) {
    if (mounted) {
      logger.i('Navigating back to MyCloset');
      context.goNamed(AppRoutesName.myCloset);
    }
  }

  @override
  void dispose() {
    closetNameController.dispose();
    monthsController.dispose();
    _scrollController.dispose();
    logger.i('EditMultiClosetScreen disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.i('EditMultiClosetScreen initialized with selectedItemIds: ${widget.selectedItemIds}');

    final theme = Theme.of(context);
    logger.d('Building EditMultiClosetScreen UI');

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
        child: BlocBuilder<CrossAxisCountCubit, int>(
        builder: (context, crossAxisCount) {

            return MultiBlocListener(
              listeners: [
                BlocListener<EditMultiClosetBloc, EditMultiClosetState>(
                  listener: (context, state) {
                    // Fetch selected items from MultiSelectionItemCubit
                    final selectionState = context.read<MultiSelectionItemCubit>().state;

                    if (selectionState.selectedItemIds.isNotEmpty) {
                      // Case: Items are selected
                      logger.i('Items selected. Evaluating ClosetStatus...');
                      if (state.status == ClosetStatus.valid) {
                        logger.i('ClosetStatus.validWithItems. Navigating to SwapCloset.');

                        // Fetch metadata
                        final metadataState = context.read<EditClosetMetadataBloc>().state;

                        String closetId = '';
                        String closetName = '';
                        String closetType = '';
                        bool isPublic = false;
                        DateTime validDate = DateTime.now();

                        if (metadataState is EditClosetMetadataAvailable) {
                          // Metadata is available, use actual values
                          closetId = metadataState.metadata.closetId;
                          closetName = metadataState.metadata.closetName;
                          closetType = metadataState.metadata.closetType;
                          isPublic = metadataState.metadata.isPublic;
                          validDate = metadataState.metadata.validDate;
                        } else {
                          // Metadata not available, log and use blank/default values
                          logger.w('Metadata not available. Proceeding with blank/default values.');
                        }

                        context.goNamed(
                          AppRoutesName.swapCloset,
                          extra: {
                            'closetId': closetId,
                            'closetName': closetName,
                            'closetType': closetType,
                            'isPublic': isPublic,
                            'validDate': validDate,
                            'selectedItemIds': selectionState.selectedItemIds, // Pass selected items
                          },
                        );
                      } else {
                        logger.w('ClosetStatus is not validWithItems, cannot navigate.');
                      }
                    } else {
                      // Case: No items selected
                      logger.i('No items selected. Evaluating ClosetStatus...');

                      if (state.status == ClosetStatus.valid) {
                        logger.i('ClosetStatus.validWithoutItems. Triggering EditMultiClosetUpdate event.');

                        // Fetch metadata
                        final metadata = context.read<EditClosetMetadataBloc>().state as EditClosetMetadataAvailable;

                        // Trigger EditMultiClosetUpdate event
                        context.read<EditMultiClosetBloc>().add(EditMultiClosetUpdate(
                          closetId: metadata.metadata.closetId,
                          closetName: metadata.metadata.closetName,
                          closetType: metadata.metadata.closetType,
                          isPublic: metadata.metadata.isPublic,
                          validDate: metadata.metadata.validDate,
                        ));
                      } else {
                        logger.w('ClosetStatus is not validWithoutItems, no action taken.');
                      }
                    }

                    // Handle success and error states
                    if (state.status == ClosetStatus.success) {
                      logger.i('Closet created successfully.');
                      CustomSnackbar(
                        message: S.of(context).closet_edited_successfully,
                        theme: Theme.of(context),
                      ).show(context);
                      _navigateToMyCloset(context);
                    } else if (state.status == ClosetStatus.failure && state.validationErrors != null) {
                      logger.e('Validation errors: ${state.validationErrors}');
                      CustomSnackbar(
                        message: S.of(context).fix_validation_errors,
                        theme: Theme.of(context),
                      ).show(context);
                    } else if (state.status == ClosetStatus.failure && state.error != null) {
                      logger.e('Error creating closet: ${state.error}');
                      CustomSnackbar(
                        message: S.of(context).error_creating_closet(state.error ?? ''),
                        theme: Theme.of(context),
                      ).show(context);
                    }
                  },
                ),
                BlocListener<EditClosetMetadataBloc, EditClosetMetadataState>(
                    listener: (context, metadataState) {
                      if (metadataState is EditClosetMetadataAvailable) {
                        final newName = metadataState.metadata.closetName;
                        if (closetNameController.text != newName) {
                          closetNameController.text = newName;
                        }
                      }
                    },
                )],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: MultiClosetFeatureContainer(
                          theme: theme,
                          onFilterButtonPressed: () => _onFilterButtonPressed(context, false),
                          onArrangeButtonPressed: () => _onArrangeButtonPressed(context, false),
                          onResetButtonPressed: () => _onResetButtonPressed(context),
                          onSelectAllButtonPressed: () => _onSelectAllButtonPressed(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // BlocBuilder for conditional rendering of MultiClosetArchiveFeatureContainer
                      BlocBuilder<EditClosetMetadataBloc, EditClosetMetadataState>(
                        builder: (context, metadataState) {
                          if (metadataState is EditClosetMetadataAvailable) {
                            closetNameController.text = metadataState.metadata.closetName;
                            return Expanded(
                              flex: 1,
                              child: MultiClosetArchiveFeatureContainer(
                                theme: theme,
                                onArchiveButtonPressed: () => _onArchiveButtonPressed(),
                              ),
                            );
                          } else {
                            return const SizedBox.shrink(); // Return empty widget if metadata isn't available
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
              BlocBuilder<EditMultiClosetBloc, EditMultiClosetState>(
                builder: (context, multiClosetState) {
                  // Pull out the validationErrors from EditMultiClosetBloc state:
                  final validationErrors = multiClosetState.validationErrors;

                  return BlocBuilder<EditClosetMetadataBloc, EditClosetMetadataState>(
                    builder: (context, metadataState) {
                      if (metadataState is EditClosetMetadataAvailable) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Profile Photo on the Left
                            EditClosetImage(
                              closetImage: metadataState.metadata.closetImage,
                              onImageTap: () {
                                  _navigateToPhotoProvider();
                              },
                            ),
                            const SizedBox(width: 5),

                            // Edit Closet Metadata on the Right
                            Expanded(
                              child: EditMultiClosetMetadata(
                                closetNameController: closetNameController,
                                theme: theme,
                                // Pass the multiClosetState's validationErrors here
                                errorKeys: validationErrors,
                              ),
                            ),
                          ],
                        );
                      } else if (metadataState is EditClosetMetadataLoading) {
                        return const Center(child: ClosetProgressIndicator());
                      } else if (metadataState is EditClosetMetadataFailure) {
                        return Center(
                          child: Text(
                            metadataState.errorMessage,
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  );
                },
              ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: BlocBuilder<ViewItemsBloc, ViewItemsState>(
                      builder: (context, viewState) {
                        if (viewState is ItemsLoading) {
                          return const Center(child: ClosetProgressIndicator());
                        } else if (viewState is ItemsError) {
                          return Center(child: Text(S.of(context).failedToLoadItems));
                        } else if (viewState is ItemsLoaded) {
                          return InteractiveItemGrid(
                            items: viewState.items,
                            scrollController: _scrollController,
                            crossAxisCount: crossAxisCount,
                            itemSelectionMode: ItemSelectionMode.multiSelection,
                            selectedItemIds: widget.selectedItemIds,
                            isOutfit: false,
                            isLocalImage: false,
                          );
                        } else {
                          return Center(child: Text(S.of(context).noItemsInCloset));
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const EditClosetActionButton(),

                ],
              ),
            );
          }
      ),
    );
  }
}
