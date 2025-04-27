import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/core_enums.dart';
import '../../../../../core/theme/my_closet_theme.dart';
import '../../../../../core/widgets/layout/grid/interactive_item_grid.dart';
import '../../../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/utilities/app_router.dart';
import '../../../../../generated/l10n.dart';
import '../../../../core/data/items_enums.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../view_items/presentation/bloc/view_items_bloc.dart';
import '../../../core/presentation/widgets/multi_closet_feature_container.dart';
import '../bloc/edit_closet_metadata_bloc/edit_closet_metadata_bloc.dart';
import '../bloc/edit_multi_closet_bloc/edit_multi_closet_bloc.dart';
import '../widgets/archive_bottom_sheet.dart';
import '../widgets/edit_closet_action_button.dart';
import '../widgets/edit_closet_image.dart';
import '../widgets/edit_multi_closet_metadata.dart';
import '../widgets/multi_closet_archive_feature_container.dart';

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

  Map<String, String> validationErrors = {};

  @override
  void initState() {
    super.initState();
    logger.i('EditMultiClosetScreen initialized');
    context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
    context.read<ViewItemsBloc>().add(FetchItemsEvent(0, isPending: false));
    context.read<EditClosetMetadataBloc>().add(FetchMetadataEvent());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        final viewItemsBloc = context.read<ViewItemsBloc>();
        final currentState = viewItemsBloc.state;

        if (currentState is ItemsLoaded) {
          context.read<ViewItemsBloc>().add(FetchItemsEvent(currentState.currentPage, isPending: false));
        }
      }
    });
  }

  void _navigateToMyCloset(BuildContext context) {
    if (mounted) {
      logger.i('Navigating back to MyCloset');
      context.goNamed(AppRoutesName.myCloset);
    }
  }

  void _navigateToPhotoProvider() {
    final metadataState = context.read<EditClosetMetadataBloc>().state;

    if (metadataState is EditClosetMetadataAvailable) {
      context.pushNamed(AppRoutesName.editClosetPhoto, extra: metadataState.metadata.closetId);
    } else {
      logger.e('Unable to navigate to PhotoProvider: Metadata not available.');
      CustomSnackbar(message: S.of(context).failedToLoadMetadata, theme: myClosetTheme).show(context);
    }
  }

  void _onFilterButtonPressed(BuildContext context) {
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

  void _onArrangeButtonPressed(BuildContext context) {
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
    context.read<MultiSelectionItemCubit>().clearSelection();
  }

  void _onSelectAllButtonPressed(BuildContext context) {
    final viewItemsState = context.read<ViewItemsBloc>().state;
    if (viewItemsState is ItemsLoaded) {
      final allItemIds = viewItemsState.items.map((item) => item.itemId).toList();
      context.read<MultiSelectionItemCubit>().selectAll(allItemIds);
    } else {
      logger.e('Unable to select all items.');
      CustomSnackbar(message: S.of(context).failedToLoadItems, theme: myClosetTheme).show(context);
    }
  }

  void _onArchiveButtonPressed() {
    final metadataState = context.read<EditClosetMetadataBloc>().state;

    if (metadataState is EditClosetMetadataAvailable) {
      showModalBottomSheet(
        context: context,
        builder: (context) => ArchiveBottomSheet(
          closetId: metadataState.metadata.closetId,
          theme: myClosetTheme,
        ),
      );
    } else {
      logger.e('Unable to archive: Metadata not available.');
      CustomSnackbar(message: S.of(context).failedToLoadMetadata, theme: myClosetTheme).show(context);
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
    final effectiveTheme = myClosetTheme;

    return Theme(
      data: effectiveTheme,
      child: PopScope(
        canPop: true,
        onPopInvokedWithResult: (bool didPop, Object? result) {
          logger.i('Pop invoked: didPop = $didPop, result = $result');
          if (!didPop) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.goNamed(AppRoutesName.myCloset);
            });
          }
        },
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: BackButton(
              onPressed: () async {
                final navigator = Navigator.of(context);
                if (navigator.canPop()) {
                  logger.i('BackButton: Navigator can pop, popping...');
                  navigator.pop();
                } else {
                  logger.i('BackButton: Navigator cannot pop, going to MyCloset.');
                  context.goNamed(AppRoutesName.myCloset);
                }
              },
            ),
            title: Text(
              S.of(context).multiClosetManagement,
              style: effectiveTheme.textTheme.titleMedium,
            ),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.translucent,
            child: BlocBuilder<CrossAxisCountCubit, int>(
              builder: (context, crossAxisCount) {
                return MultiBlocListener(
                    listeners: [
                    BlocListener<EditMultiClosetBloc, EditMultiClosetState>(
                listener: (context, state) {
                  final selectionState = context.read<MultiSelectionItemCubit>().state;

                  if (selectionState.selectedItemIds.isNotEmpty) {
                    if (state.status == ClosetStatus.valid) {
                      final metadataState = context.read<EditClosetMetadataBloc>().state;

                      String closetId = '';
                      String closetName = '';
                      String closetType = '';
                      bool isPublic = false;
                      DateTime validDate = DateTime.now();

                      if (metadataState is EditClosetMetadataAvailable) {
                        closetId = metadataState.metadata.closetId;
                        closetName = metadataState.metadata.closetName;
                        closetType = metadataState.metadata.closetType;
                        isPublic = metadataState.metadata.isPublic;
                        validDate = metadataState.metadata.validDate;
                      }

                      context.pushNamed(
                        AppRoutesName.swapCloset,
                        extra: {
                          'closetId': closetId,
                          'closetName': closetName,
                          'closetType': closetType,
                          'isPublic': isPublic,
                          'validDate': validDate,
                          'selectedItemIds': selectionState.selectedItemIds,
                        },
                      );
                    } else {
                      logger.w('ClosetStatus is not validWithItems, cannot navigate.');
                    }
                  } else {
                    if (state.status == ClosetStatus.valid) {
                      final metadata = context.read<EditClosetMetadataBloc>().state as EditClosetMetadataAvailable;

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

                  if (state.status == ClosetStatus.success) {
                    CustomSnackbar(
                      message: S.of(context).closet_edited_successfully,
                      theme: myClosetTheme,
                    ).show(context);
                    _navigateToMyCloset(context);
                  } else if (state.status == ClosetStatus.failure && state.validationErrors != null) {
                    CustomSnackbar(
                      message: S.of(context).fix_validation_errors,
                      theme: myClosetTheme,
                    ).show(context);
                  } else if (state.status == ClosetStatus.failure && state.error != null) {
                    CustomSnackbar(
                      message: S.of(context).error_creating_closet(state.error ?? ''),
                      theme: myClosetTheme,
                    ).show(context);
                  }
                },
                ),
                    BlocListener<EditClosetMetadataBloc, EditClosetMetadataState>(
                      listener: (context, metadataState) {
                        if (metadataState is EditClosetMetadataAvailable) {
                          closetNameController.text = metadataState.metadata.closetName;
                        }
                      },
                    ),
                  ],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: MultiClosetFeatureContainer(
                              theme: effectiveTheme,
                              onFilterButtonPressed: () => _onFilterButtonPressed(context),
                              onArrangeButtonPressed: () => _onArrangeButtonPressed(context),
                              onResetButtonPressed: () => _onResetButtonPressed(context),
                              onSelectAllButtonPressed: () => _onSelectAllButtonPressed(context),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            flex: 1,
                            child: BlocBuilder<EditClosetMetadataBloc, EditClosetMetadataState>(
                              builder: (context, metadataState) {
                                if (metadataState is EditClosetMetadataAvailable) {
                                  return MultiClosetArchiveFeatureContainer(
                                    theme: effectiveTheme,
                                    onArchiveButtonPressed: _onArchiveButtonPressed,
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
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
                                        theme: effectiveTheme,
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
                                    style: TextStyle(color: effectiveTheme.colorScheme.error),
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
                            }
                            return Center(child: Text(S.of(context).noItemsInCloset));
                          },
                        ),
                      ),
                      const SizedBox(height: 16),
                      const EditClosetActionButton(),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
