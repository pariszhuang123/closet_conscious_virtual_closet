import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/core_enums.dart';
import '../../../../../core/theme/my_closet_theme.dart';
import '../../../../../core/widgets/layout/grid/interactive_item_grid.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/utilities/app_router.dart';
import '../../../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../../../generated/l10n.dart';
import '../../../core/presentation/bloc/update_closet_metadata_cubit/update_closet_metadata_cubit.dart';
import '../../../core/presentation/widgets/multi_closet_feature_container.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../view_items/presentation/bloc/view_items_bloc.dart';
import '../bloc/create_multi_closet_bloc.dart';
import '../../../core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';
import '../widgets/create_multi_closet_metadata.dart';
import 'create_multi_closet_listeners.dart'; // ✅ Extracted listeners

class CreateMultiClosetScreen extends StatefulWidget {
  final List<String> selectedItemIds;

  const CreateMultiClosetScreen({
    super.key,
    required this.selectedItemIds,
  });

  @override
  State<CreateMultiClosetScreen> createState() => _CreateMultiClosetScreenState();
}

class _CreateMultiClosetScreenState extends State<CreateMultiClosetScreen> {
  final TextEditingController closetNameController = TextEditingController();
  final TextEditingController monthsController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final CustomLogger logger = CustomLogger('CreateMultiClosetScreen');

  Map<String, String> validationErrors = {};

  @override
  void initState() {
    super.initState();
    logger.i('CreateMultiClosetScreen initialized');
    context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
    context.read<MultiClosetNavigationBloc>().add(CheckMultiClosetAccessEvent());

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

  @override
  void dispose() {
    closetNameController.dispose();
    monthsController.dispose();
    _scrollController.dispose();
    logger.i('CreateMultiClosetScreen disposed');
    super.dispose();
  }

  void _onFilterButtonPressed(BuildContext context) {
    final selectedItemIds = context.read<MultiSelectionItemCubit>().state.selectedItemIds;
    context.pushNamed(
      AppRoutesName.filter,
      extra: {
        'isFromMyCloset': true,
        'selectedItemIds': selectedItemIds,
        'returnRoute': AppRoutesName.createMultiCloset,
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
        'returnRoute': AppRoutesName.createMultiCloset,
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
      logger.e('Unable to select all items. Items not loaded.');
      CustomSnackbar(
        message: S.of(context).failedToLoadItems,
        theme: myClosetTheme,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    logger.i('Building CreateMultiClosetScreen with selectedItemIds: ${widget.selectedItemIds}');
    final effectiveTheme = myClosetTheme;

    return Theme(
      data: effectiveTheme,
      child: CreateMultiClosetListeners( // ✅ BlocListeners above Scaffold
        logger: logger,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            leading: BackButton(
              onPressed: () {
                final navigator = Navigator.of(context);
                if (navigator.canPop()) {
                  logger.i('BackButton: Navigator can pop, popping...');
                  navigator.pop();
                } else {
                  logger.i('BackButton: Navigator cannot pop, going to MyCloset.');
                  context.goNamed(AppRoutesName.viewMultiCloset);
                }
              },
            ),
            title: Text(
              S.of(context).multiClosetManagement,
              style: effectiveTheme.textTheme.titleMedium,
            ),
          ),
          body: PopScope(
            canPop: true,
            onPopInvokedWithResult: (bool didPop, Object? result) {
              logger.i('Pop invoked: didPop = $didPop, result = $result');
              if (!didPop) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.goNamed(AppRoutesName.viewMultiCloset);
                });
              }
            },
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              behavior: HitTestBehavior.translucent,
              child: BlocBuilder<CrossAxisCountCubit, int>(
                builder: (context, crossAxisCount) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MultiClosetFeatureContainer(
                        theme: effectiveTheme,
                        onFilterButtonPressed: () => _onFilterButtonPressed(context),
                        onArrangeButtonPressed: () => _onArrangeButtonPressed(context),
                        onResetButtonPressed: () => _onResetButtonPressed(context),
                        onSelectAllButtonPressed: () => _onSelectAllButtonPressed(context),
                      ),
                      const SizedBox(height: 10),
                      BlocBuilder<CreateMultiClosetBloc, CreateMultiClosetState>(
                        builder: (context, createClosetState) {
                          validationErrors = createClosetState.validationErrors ?? {};
                          return BlocBuilder<UpdateClosetMetadataCubit, UpdateClosetMetadataState>(
                            builder: (context, metadataState) {
                              closetNameController.text = metadataState.closetName;
                              monthsController.text = metadataState.monthsLater?.toString() ?? '';
                              return CreateMultiClosetMetadata(
                                closetNameController: closetNameController,
                                monthsController: monthsController,
                                closetType: metadataState.closetType,
                                isPublic: metadataState.isPublic ?? false,
                                theme: effectiveTheme,
                                errorKeys: validationErrors,
                              );
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
                      BlocBuilder<MultiSelectionItemCubit, MultiSelectionItemState>(
                        builder: (context, selectionItemState) {
                          if (!selectionItemState.hasSelectedItems) return const SizedBox.shrink();
                          return Padding(
                            padding: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                            ),
                            child: Center(
                              child: ThemedElevatedButton(
                                text: S.of(context).create_closet,
                                onPressed: () {
                                  final metadataState = context.read<UpdateClosetMetadataCubit>().state;
                                  context.read<CreateMultiClosetBloc>().add(
                                    CreateMultiClosetValidate(
                                      closetName: metadataState.closetName,
                                      closetType: metadataState.closetType,
                                      isPublic: metadataState.isPublic,
                                      monthsLater: metadataState.monthsLater,
                                  ),
                                );
                              },
                            ),
                            )
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
