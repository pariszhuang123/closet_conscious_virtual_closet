import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
import '../../../../../utilities/routes.dart';
import '../../../../../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../../../item_management/view_items/presentation/bloc/view_items_bloc.dart';
import '../../../../../widgets/feedback/custom_snack_bar.dart';
import '../../../../../core_enums.dart';
import '../../../../../widgets/button/themed_elevated_button.dart';
import '../../../../core/presentation/bloc/usage_analytics_navigation_bloc/usage_analytics_navigation_bloc.dart';
import '../../../../core/presentation/bloc/focus_or_create_closet_bloc/focus_or_create_closet_bloc.dart';
import '../../../../../paywall/data/feature_key.dart';
import '../../../../../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';

class SummaryItemsScreen extends StatefulWidget {
  final bool isFromMyCloset; // Determines the theme
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
    logger.i(
        'SummaryItemsScreen initialized with isFromMyCloset=${widget.isFromMyCloset}'
    );

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        final viewItemsBloc = context.read<ViewItemsBloc>();
        final currentState = viewItemsBloc.state;
        if (currentState is ItemsLoaded) {
          final currentPage = currentState.currentPage;
          context.read<ViewItemsBloc>().add(FetchItemsEvent(currentPage));
        }
      }
    });
  }

  void _onFilterButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedItemIds =
        context.read<MultiSelectionItemCubit>().state.selectedItemIds;
    Navigator.pushNamed(
      context,
      AppRoutes.filter,
      arguments: {
        'isFromMyCloset': true,
        'selectedItemIds': selectedItemIds,
        'returnRoute': AppRoutes.summaryItemsAnalytics,
      },
    );
  }

  void _onArrangeButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedItemIds =
        context.read<MultiSelectionItemCubit>().state.selectedItemIds;
    Navigator.pushNamed(
      context,
      AppRoutes.customize,
      arguments: {
        'isFromMyCloset': true,
        'selectedItemIds': selectedItemIds,
        'returnRoute': AppRoutes.summaryItemsAnalytics,
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
      logger.i('Updating and saving state: isCalendarSelectable = false');

      context.read<FocusOrCreateClosetBloc>().add(
        UpdateFocusOrCreateCloset(false),
      );
    }
  }

  void _onCreateClosetButtonPressed(BuildContext context) {
    final state = context.read<FocusOrCreateClosetBloc>().state;
    if (state is FocusOrCreateClosetLoaded) {
      logger.i('Updating and saving state: isCalendarSelectable = true');

      context.read<FocusOrCreateClosetBloc>().add(
        UpdateFocusOrCreateCloset(true),
      );
    }
  }

  void _handleCreateCloset() {
    final selectedItemIds =
        context.read<MultiSelectionItemCubit>().state.selectedItemIds;
    if (selectedItemIds.isNotEmpty) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.createMultiCloset,
        arguments: {'selectedItemIds': selectedItemIds},
      );
    }
  }

  void _onItemSelected(BuildContext context) {
    final itemId = context.read<SingleSelectionItemCubit>().state.selectedItemId;

    if (itemId != null) {
      logger.i("Navigating to item details for itemId: $itemId");

      Navigator.pushNamed(
        context,
        AppRoutes.focusedItemsAnalytics, // ✅ Ensure this route exists
        arguments: itemId,
      );
    } else {
      logger.w("No item selected, navigation not triggered.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme;
    logger.d('Building SummaryItemsScreen UI');

    return MultiBlocListener(
      listeners: [
        // Usage Analytics Access Listener
        BlocListener<UsageAnalyticsNavigationBloc, UsageAnalyticsNavigationState>(
          listener: (context, state) {
            if (state is UsageAnalyticsAccessState) {
              if (state.accessStatus == AccessStatus.denied) {
                logger.w('Access denied: Navigating to payment page');
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.payment,
                  arguments: {
                    'featureKey': FeatureKey.usageAnalytics,
                    'isFromMyCloset': widget.isFromMyCloset,
                    'previousRoute': AppRoutes.myCloset,
                    'nextRoute': AppRoutes.summaryItemsAnalytics,
                  },
                );
              } else if (state.accessStatus == AccessStatus.trialPending) {
                logger.i('Trial pending, navigating to trialStarted screen');
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.trialStarted,
                  arguments: {
                    'selectedFeatureRoute': AppRoutes.summaryItemsAnalytics,
                    'isFromMyCloset': widget.isFromMyCloset,
                  },
                );
              }
            }
          },
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SummaryItemAnalyticsFeatureContainer(
              theme: theme,
              onFilterButtonPressed: () => _onFilterButtonPressed(context, false),
              onArrangeButtonPressed: () => _onArrangeButtonPressed(context, false),
              onResetButtonPressed: () => _onResetButtonPressed(context),
              onSelectAllButtonPressed: () => _onSelectAllButtonPressed(context),
              onFocusButtonPressed: () => _onFocusButtonPressed(context),
              onCreateClosetButtonPressed: () => _onCreateClosetButtonPressed(context),
            ),
            const SizedBox(height: 12),

            // Summary Section
            BlocBuilder<SummaryItemsBloc, SummaryItemsState>(
              builder: (context, state) {
                logger.d(
                    'BlocBuilder - Summary Section: Current state = ${state.runtimeType}'
                );

                if (state is SummaryItemsLoading) {
                  return const ClosetProgressIndicator();
                } else if (state is SummaryItemsLoaded) {
                  logger.i(
                      'Summary data loaded: '
                          'totalItems=${state.totalItems}, '
                          'totalCost=${state.totalItemCost}, '
                          'avgPricePerWear=${state.avgPricePerWear}'
                  );
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SummaryCard(
                        title: S.of(context).totalItems,
                        value: state.totalItems,
                      ),
                      SummaryCard(
                        title: S.of(context).totalCost,
                        value: state.totalItemCost,
                      ),
                      SummaryCard(
                        title: S.of(context).avgPricePerWear,
                        value: state.avgPricePerWear,
                      ),
                    ],
                  );
                } else if (state is SummaryItemsError) {
                  logger.e('Error loading summary items: ${state.message}');
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

            // Items Grid
            Expanded(
              child: BlocBuilder<CrossAxisCountCubit, int>(
                builder: (context, crossAxisCount) {
                  return BlocBuilder<ViewItemsBloc, ViewItemsState>(
                    builder: (context, viewState) {
                      return BlocBuilder<FocusOrCreateClosetBloc, FocusOrCreateClosetState>(
                        builder: (context, focusState) {
                          ItemSelectionMode itemSelectionMode = ItemSelectionMode.action; // Default

                          if (focusState is FocusOrCreateClosetLoaded) {
                            itemSelectionMode = focusState.isCalendarSelectable
                                ? ItemSelectionMode.multiSelection
                                : ItemSelectionMode.action;
                          }

                          if (viewState is ItemsLoading) {
                            return const Center(child: ClosetProgressIndicator());
                          } else if (viewState is ItemsError) {
                            return Center(
                              child: Text(S.of(context).failedToLoadItems),
                            );
                          } else if (viewState is ItemsLoaded) {
                            return InteractiveItemGrid(
                              items: viewState.items,
                              scrollController: _scrollController,
                              crossAxisCount: crossAxisCount,
                              enablePricePerWear: true,
                              itemSelectionMode: itemSelectionMode,
                              selectedItemIds: widget.selectedItemIds,
                              onAction: () {
                                _onItemSelected(
                                    context); // ✅ Call when an item is tapped
                              }
                                );
                          } else {
                            return Center(
                              child: Text(S.of(context).noItemsInCloset),
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
                        text: S.of(context).createCloset,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink(); // Completely removes SafeArea if no items are selected
              },
            ),
          ],
        ),
      ),
    );
  }
}
