import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../bloc/summary_items_bloc.dart';
import '../../../../../theme/my_closet_theme.dart';
import '../../../../../theme/my_outfit_theme.dart';
import '../../../../../utilities/logger.dart';
import '../../../../../widgets/layout/grid/interactive_item_grid.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../widgets/container/summary_card.dart';
import '../../../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../../../generated/l10n.dart';
import '../widgets/summary_item_analytics_feature_container.dart';
import '../../../../../utilities/app_router.dart';
import '../../../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../../../item_management/view_items/presentation/bloc/view_items_bloc.dart';
import '../../../../../widgets/feedback/custom_snack_bar.dart';
import '../../../../../core_enums.dart';
import '../../../../../widgets/button/themed_elevated_button.dart';
import '../../../../core/presentation/bloc/focus_or_create_closet_bloc/focus_or_create_closet_bloc.dart';
import '../../../../../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';
import '../../../../../widgets/feedback/custom_tooltip.dart';
import 'summary_item_analytics_listeners.dart';
import '../../../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../../core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';


class SummaryItemsScreen extends StatefulWidget {
  final bool isFromMyCloset;
  final List<String> selectedItemIds;

  const SummaryItemsScreen({
    super.key,
    required this.isFromMyCloset,
    required this.selectedItemIds,
  });

  @override
  SummaryItemsScreenState createState() => SummaryItemsScreenState();
}

class SummaryItemsScreenState extends State<SummaryItemsScreen> {
  final ScrollController _scrollController = ScrollController();
  final CustomLogger logger = CustomLogger('SummaryItemsScreenLogger');

  @override
  void initState() {
    super.initState();
    logger.i('SummaryItemsScreen initialized with isFromMyCloset=${widget.isFromMyCloset}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<UsageAnalyticsNavigationBloc>().add(CheckUsageAnalyticsAccessEvent());
      context.read<TutorialBloc>().add(const CheckTutorialStatus(TutorialType.paidUsageAnalytics));
    });

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

  void _onFilterButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedItemIds = context.read<MultiSelectionItemCubit>().state.selectedItemIds;
    context.pushNamed(
      AppRoutesName.filter,
      extra: {
        'isFromMyCloset': true,
        'selectedItemIds': selectedItemIds,
        'returnRoute': AppRoutesName.summaryItemsAnalytics,
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
        'returnRoute': AppRoutesName.summaryItemsAnalytics,
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
        theme: Theme.of(context),
      ).show(context);
    }
  }

  void _onFocusButtonPressed(BuildContext context) {
    final state = context.read<FocusOrCreateClosetBloc>().state;
    if (state is FocusOrCreateClosetLoaded) {
      logger.i('Updating and saving state: isCalendarSelectable = true');

      context.read<FocusOrCreateClosetBloc>().add(
        UpdateFocusOrCreateCloset(true),
      );
    }
  }

  void _onCreateClosetButtonPressed(BuildContext context) {
    final state = context.read<FocusOrCreateClosetBloc>().state;
    if (state is FocusOrCreateClosetLoaded) {
      logger.i('Updating and saving state: isCalendarSelectable = false');

      context.read<FocusOrCreateClosetBloc>().add(
        UpdateFocusOrCreateCloset(false),
      );
    }
  }

  void _handleCreateCloset() {
    final selectedItemIds = context.read<MultiSelectionItemCubit>().state.selectedItemIds;
    if (selectedItemIds.isNotEmpty) {
      context.pushNamed(
        AppRoutesName.createMultiCloset,
        extra: {'selectedItemIds': selectedItemIds},
      );
    }
  }

  void _onItemSelected(BuildContext context) {
    final itemId = context.read<SingleSelectionItemCubit>().state.selectedItemId;

    if (itemId != null) {
      logger.i("Navigating to item details for itemId: $itemId");

      context.pushNamed(
        AppRoutesName.focusedItemsAnalytics,
        extra: itemId,
      );
    } else {
      logger.w("No item selected, navigation not triggered.");
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme;
    logger.d('Building SummaryItemsScreen UI');

    return BlocBuilder<UsageAnalyticsNavigationBloc, UsageAnalyticsNavigationState>(
        builder: (context, accessState) {
          if (accessState is UsageAnalyticsAccessState &&
              accessState.accessStatus == AccessStatus.pending) {
            return const Center(child: ClosetProgressIndicator());
          }

          return SummaryItemAnalyticsListeners(
            isFromMyCloset: widget.isFromMyCloset,
            selectedItemIds: widget.selectedItemIds,
            logger: logger,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  SummaryItemAnalyticsFeatureContainer(
                    theme: theme,
                    onFilterButtonPressed: () =>
                        _onFilterButtonPressed(context, false),
                    onArrangeButtonPressed: () =>
                        _onArrangeButtonPressed(context, false),
                    onResetButtonPressed: () => _onResetButtonPressed(context),
                    onSelectAllButtonPressed: () =>
                        _onSelectAllButtonPressed(context),
                    onFocusButtonPressed: () => _onFocusButtonPressed(context),
                    onCreateClosetButtonPressed: () =>
                        _onCreateClosetButtonPressed(context),
                  ),
                  const SizedBox(height: 12),
                  BlocBuilder<SummaryItemsBloc, SummaryItemsState>(
                    builder: (context, state) {
                      logger.d(
                          'BlocBuilder - Summary Section: Current state = ${state
                              .runtimeType}');

                      if (state is SummaryItemsLoading ||
                          state is SummaryItemsInitial) {
                        return const ClosetProgressIndicator();
                      } else if (state is SummaryItemsLoaded) {
                        logger.i('Summary data loaded: totalItems=${state
                            .totalItems}, totalCost=${state
                            .totalItemCost}, avgPricePerWear=${state
                            .avgPricePerWear}');
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomTooltip(
                              message: S
                                  .of(context)
                                  .totalItemsTooltip,
                              position: TooltipPosition.left,
                              theme: theme,
                              child: SummaryCard(
                                title: S
                                    .of(context)
                                    .totalItems,
                                value: state.totalItems,
                              ),
                            ),
                            CustomTooltip(
                              message: S
                                  .of(context)
                                  .totalCostTooltip,
                              position: TooltipPosition.center,
                              theme: theme,
                              child: SummaryCard(
                                title: S
                                    .of(context)
                                    .totalCost,
                                value: state.totalItemCost,
                              ),
                            ),
                            CustomTooltip(
                              message: S
                                  .of(context)
                                  .costPerWearTooltip,
                              position: TooltipPosition.right,
                              theme: theme,
                              child: SummaryCard(
                                title: S
                                    .of(context)
                                    .avgPricePerWear,
                                value: state.avgPricePerWear,
                              ),
                            ),
                          ],
                        );
                      } else if (state is SummaryItemsError) {
                        logger.e(
                            'Error loading summary items: ${state.message}');
                        return Center(
                          child: Text(
                            state.message,
                            style: theme.textTheme.bodyMedium,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: BlocBuilder<CrossAxisCountCubit, int>(
                      builder: (context, crossAxisCount) {
                        return BlocBuilder<ViewItemsBloc, ViewItemsState>(
                          builder: (context, viewState) {
                            return BlocBuilder<
                                FocusOrCreateClosetBloc,
                                FocusOrCreateClosetState>(
                              builder: (context, focusState) {
                                ItemSelectionMode itemSelectionMode = ItemSelectionMode
                                    .action;

                                if (focusState is FocusOrCreateClosetLoaded) {
                                  itemSelectionMode =
                                  focusState.isCalendarSelectable
                                      ? ItemSelectionMode.multiSelection
                                      : ItemSelectionMode.action;
                                }

                                if (viewState is ItemsLoading) {
                                  return const Center(
                                      child: ClosetProgressIndicator());
                                } else if (viewState is ItemsError) {
                                  return Center(child: Text(S
                                      .of(context)
                                      .failedToLoadItems));
                                } else if (viewState is ItemsLoaded) {
                                  return InteractiveItemGrid(
                                    items: viewState.items,
                                    scrollController: _scrollController,
                                    crossAxisCount: crossAxisCount,
                                    enablePricePerWear: true,
                                    itemSelectionMode: itemSelectionMode,
                                    selectedItemIds: widget.selectedItemIds,
                                    isOutfit: false,
                                    isLocalImage: false,
                                    onAction: () => _onItemSelected(context),
                                  );
                                } else {
                                  return Center(
                                    child: Text(
                                      S
                                          .of(context)
                                          .noItemsInCloset,
                                      textAlign: TextAlign.center,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<MultiSelectionItemCubit, MultiSelectionItemState>(
                    builder: (context, state) {
                      if (state.selectedItemIds.isNotEmpty) {
                        return SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: ThemedElevatedButton(
                              onPressed: _handleCreateCloset,
                              text: S
                                  .of(context)
                                  .createCloset,
                            ),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }
}
