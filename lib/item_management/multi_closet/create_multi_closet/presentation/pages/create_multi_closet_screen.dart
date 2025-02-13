import 'package:closet_conscious/core/core_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/my_closet_theme.dart';
import '../bloc/create_multi_closet_bloc.dart';
import '../../../../view_items/presentation/bloc/view_items_bloc.dart';
import '../../../../../core/widgets/layout/grid/interactive_item_grid.dart';
import '../widgets/create_multi_closet_metadata.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../core/data/items_enums.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/routes.dart';
import '../../../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../core/presentation/bloc/update_closet_metadata_cubit/update_closet_metadata_cubit.dart';
import '../../../../core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../core/presentation/widgets/multi_closet_feature_container.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';
import '../../../../../core/paywall/data/feature_key.dart';

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

  Map<String, String> validationErrors = {}; // Add validation errors map

  void _onFilterButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedItemIds = context.read<MultiSelectionItemCubit>().state.selectedItemIds;
    Navigator.pushNamed(
      context,
      AppRoutes.filter,
      arguments: {
        'isFromMyCloset': true,
        'selectedItemIds': selectedItemIds,
        'returnRoute': AppRoutes.createMultiCloset,
      },
    );
  }

  void _onArrangeButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedItemIds = context.read<MultiSelectionItemCubit>().state.selectedItemIds;
    Navigator.pushNamed(
      context,
      AppRoutes.customize,
      arguments: {
        'isFromMyCloset': true,
        'selectedItemIds': selectedItemIds,
        'returnRoute': AppRoutes.createMultiCloset,
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

  @override
  void initState() {
    super.initState();
    logger.i('CreateMultiClosetScreen initialized');
    context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
    context.read<ViewItemsBloc>().add(FetchItemsEvent(0));
    context.read<MultiClosetNavigationBloc>().add(CheckMultiClosetAccessEvent());

    // Add scroll listener for infinite scrolling
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        final viewItemsBloc = context.read<ViewItemsBloc>();
        final currentState = viewItemsBloc.state;

        if (currentState is ItemsLoaded) {
          final currentPage = currentState.currentPage;
          context.read<ViewItemsBloc>().add(FetchItemsEvent(currentPage));
        }
      }
    });
  }

  void _navigateToMyCloset(BuildContext context) {
    if (mounted) {
      logger.i('Navigating back to MyCloset');
      Navigator.pushReplacementNamed(context, AppRoutes.myCloset);
    }
  }

  @override
  void dispose() {
    closetNameController.dispose();
    monthsController.dispose();
    _scrollController.dispose();
    logger.i('CreateMultiClosetScreen disposed');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.i('Building CreateMultiClosetScreen with selectedItemIds: ${widget.selectedItemIds}');

    final theme = Theme.of(context);

    return MultiBlocListener(
      listeners: [
        BlocListener<MultiClosetNavigationBloc, MultiClosetNavigationState>(
          listener: (context, state) {
            if (state is MultiClosetAccessState && state.accessStatus == AccessStatus.denied) {
              logger.w('Access denied: Navigating to payment page');
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.payment,
                arguments: {
                  'featureKey': FeatureKey.multicloset,
                  'isFromMyCloset': true,
                  'previousRoute': AppRoutes.monthlyCalendar,
                  'nextRoute': AppRoutes.createMultiCloset,
                },
              );
            }
          },
        ),
        BlocListener<CreateMultiClosetBloc, CreateMultiClosetState>(
          listener: (context, state) {
            if (state.status == ClosetStatus.valid) {
              logger.i('Validation succeeded. Triggering CreateMultiClosetRequested event.');
              final metadataState = context.read<UpdateClosetMetadataCubit>().state;
              context.read<CreateMultiClosetBloc>().add(CreateMultiClosetRequested(
                closetName: metadataState.closetName,
                closetType: metadataState.closetType,
                isPublic: metadataState.isPublic,
                monthsLater: metadataState.monthsLater,
                itemIds: context.read<MultiSelectionItemCubit>().state.selectedItemIds,
              ));
            } else if (state.status == ClosetStatus.failure && state.validationErrors != null) {
              logger.e('Validation errors: ${state.validationErrors}');
              CustomSnackbar(
                message: S.of(context).fix_validation_errors,
                theme: Theme.of(context),
              ).show(context);
            } else if (state.status == ClosetStatus.success) {
              logger.i('Closet created successfully.');
              CustomSnackbar(
                message: S.of(context).closet_created_successfully,
                theme: Theme.of(context),
              ).show(context);
              _navigateToMyCloset(context);
            } else if (state.status == ClosetStatus.failure && state.error != null) {
              logger.e('Error creating closet: ${state.error}');
              CustomSnackbar(
                message: S.of(context).error_creating_closet(state.error ?? ''),
                theme: Theme.of(context),
              ).show(context);
            }
          },
        ),
      ],
      child: GestureDetector(  // Wrap the UI inside the child parameter
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        behavior: HitTestBehavior.translucent,
        child: BlocBuilder<CrossAxisCountCubit, int>(
          builder: (context, crossAxisCount) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MultiClosetFeatureContainer(
                  theme: myClosetTheme,
                  onFilterButtonPressed: () => _onFilterButtonPressed(context, false),
                  onArrangeButtonPressed: () => _onArrangeButtonPressed(context, false),
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
                          theme: theme,
                          errorKeys: validationErrors,
                        );
                      },
                    );
                  },
                ),

                const SizedBox(height: 16),

                // Item Grid
                Expanded(
                  child: BlocBuilder<ViewItemsBloc, ViewItemsState>(
                    builder: (context, viewState) {
                      if (viewState is ItemsLoading) {
                        return const Center(child: ClosetProgressIndicator());
                      } else if (viewState is ItemsError) {
                        return Center(child: Text(S
                            .of(context)
                            .failedToLoadItems));
                      } else if (viewState is ItemsLoaded) {
                        return InteractiveItemGrid(
                          items: viewState.items,
                          scrollController: _scrollController,
                          crossAxisCount: crossAxisCount,
                          isDisliked: false,
                          selectionMode: SelectionMode.multiSelection,
                          selectedItemIds: widget.selectedItemIds,
                        );
                      } else {
                        return Center(child: Text(S
                            .of(context)
                            .noItemsInCloset));
                      }
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Save Button
                BlocBuilder<MultiSelectionItemCubit, MultiSelectionItemState>(
                  builder: (context, selectionItemState) {
                    if (!selectionItemState.hasSelectedItems) {
                      return const SizedBox.shrink();
                    }
                    return Padding(
                      padding: EdgeInsets.only(
                        left: 16,
                        right: 16,
                        bottom: MediaQuery
                            .of(context)
                            .viewInsets
                            .bottom + 20,
                      ),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ThemedElevatedButton(
                          text: S
                              .of(context)
                              .create_closet,
                          onPressed: () {
                            final metadataState = context
                                .read<UpdateClosetMetadataCubit>()
                                .state;
                            context.read<CreateMultiClosetBloc>().add(
                                CreateMultiClosetValidate(
                                  closetName: metadataState.closetName,
                                  closetType: metadataState.closetType,
                                  isPublic: metadataState.isPublic,
                                  monthsLater: metadataState.monthsLater,
                                ));

                          },
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}