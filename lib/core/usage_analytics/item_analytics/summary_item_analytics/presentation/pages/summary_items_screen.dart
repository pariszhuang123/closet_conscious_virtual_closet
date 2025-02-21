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
import '../../../../core/presentation/bloc/usage_analytics_navigation_bloc.dart';
import '../../../../../paywall/data/feature_key.dart';

class SummaryItemsScreen extends StatefulWidget {
  final bool isFromMyCloset; // Determines the theme
  final List<String> selectedItemIds;

  const SummaryItemsScreen({
    super.key,
    required this.isFromMyCloset,
    required this.selectedItemIds
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

  void _onFilterButtonPressed(BuildContext context, bool isFromMyCloset) {
    final selectedItemIds = context.read<MultiSelectionItemCubit>().state.selectedItemIds;
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
    final selectedItemIds = context.read<MultiSelectionItemCubit>().state.selectedItemIds;
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

  void _handleCreateCloset() {
    final selectedItemIds = context.read<MultiSelectionItemCubit>().state.selectedItemIds;
    if (selectedItemIds.isNotEmpty) {
      Navigator.pushNamed(
        context,
        AppRoutes.createMultiCloset,
        arguments: {'selectedItemIds': selectedItemIds},
      );
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

        child:  BlocProvider(
      create: (context) => MultiSelectionItemCubit()..initializeSelection(widget.selectedItemIds),
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
            ),

            const SizedBox(height: 12),

            // Summary Section
            BlocBuilder<SummaryItemsBloc, SummaryItemsState>(
              builder: (context, state) {
                logger.d('BlocBuilder - Summary Section: Current state = ${state.runtimeType}');

                if (state is SummaryItemsLoading) {
                  return const CircularProgressIndicator();
                } else if (state is SummaryItemsLoaded) {
                  logger.i('Summary data loaded: totalItems=${state.totalItems}, totalCost=${state.totalItemCost}, avgPricePerWear=${state.avgPricePerWear}');
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SummaryCard(title: S.of(context).totalItems, value: state.totalItems.toString()),
                      SummaryCard(title: S.of(context).totalCost, value: "\$${state.totalItemCost.toStringAsFixed(2)}"),
                      SummaryCard(title: S.of(context).avgPricePerWear, value: "\$${state.avgPricePerWear.toStringAsFixed(2)}"),
                    ],
                  );
                } else if (state is SummaryItemsError) {
                  logger.e('Error loading summary items: ${state.message}');
                  return Center(child: Text(state.message, style: theme.textTheme.bodyMedium));
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
                      if (viewState is ItemsLoading) {
                        return const Center(child: ClosetProgressIndicator());
                      } else if (viewState is ItemsError) {
                        return Center(child: Text(S.of(context).failedToLoadItems));
                      } else if (viewState is ItemsLoaded) {
                        return InteractiveItemGrid(
                          items: viewState.items,
                          scrollController: _scrollController,
                          crossAxisCount: crossAxisCount,
                          selectionMode: SelectionMode.multiSelection,
                          selectedItemIds: context.watch<MultiSelectionItemCubit>().state.selectedItemIds,
                        );
                      } else {
                        return Center(child: Text(S.of(context).noItemsInCloset));
                      }
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

    SafeArea(
    child: Padding(
    padding: const EdgeInsets.all(16.0),

    // Integrated Button (Now Below the Grid)
            child: BlocBuilder<MultiSelectionItemCubit, MultiSelectionItemState>(
              builder: (context, state) {
                if (state.selectedItemIds.isNotEmpty) {
                  return ThemedElevatedButton(
                    onPressed: _handleCreateCloset,
                    text: S.of(context).createCloset,
                  );
                }
                return const SizedBox.shrink(); // Hides the button when no outfits are selected
              },
            ),
    )
    )
          ],
        ),
      ),
        )

    );
  }
}

