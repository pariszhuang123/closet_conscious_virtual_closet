import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utilities/routes.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/widgets/layout/grid/interactive_item_grid.dart';
import '../../../../../item_management/view_items/presentation/bloc/view_items_bloc.dart'; // Import ViewItemsBloc
import '../../../../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../core/core_enums.dart';
import '../../../../core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';


class ViewPendingItemScreen extends StatefulWidget {
  final ThemeData myClosetTheme;

  const ViewPendingItemScreen({super.key, required this.myClosetTheme});

  @override
  ViewPendingItemScreenState createState() => ViewPendingItemScreenState();
}

class ViewPendingItemScreenState extends State<ViewPendingItemScreen> {
  final ScrollController _scrollController = ScrollController();
  final CustomLogger logger = CustomLogger('MyClosetPage');

  @override
  void initState() {
    super.initState();
    // Dispatch initial item fetch event
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        final currentState = context
            .read<ViewItemsBloc>()
            .state;
        if (currentState is ItemsLoaded) {
          final currentPage = currentState.currentPage;
          context.read<ViewItemsBloc>().add(FetchItemsEvent(currentPage, isPending: false));
        }
      }
    });
  }

  void _onItemSelected(BuildContext context) {
    final itemId = context.read<SingleSelectionItemCubit>().state.selectedItemId;

    if (itemId != null) {
      logger.i("Navigating to edit Item for itemId: $itemId");

      Navigator.pushNamed(
        context,
        AppRoutes.editPendingItem, // ✅ Ensure this route exists
        arguments: {'itemId': itemId},
      );
    } else {
      logger.w("No item selected, navigation not triggered.");
    }
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<CrossAxisCountCubit, int>(
        builder: (context, crossAxisCount) {
                  return BlocBuilder<ViewItemsBloc, ViewItemsState>(
                    builder: (context, viewItemsState) {
                      ItemSelectionMode itemSelectionMode = ItemSelectionMode.action; // Default

                      if (viewItemsState is ItemsLoading) {
                        return const Center(child: ClosetProgressIndicator());
                      } else if (viewItemsState is ItemsLoaded) {
                        return Column(
                                  children: [
                                    Expanded(
                                      child: InteractiveItemGrid(
                                        items: viewItemsState.items,
                                        scrollController: _scrollController,
                                        crossAxisCount: crossAxisCount,
                                        selectedItemIds: const [], // Adjust based on selection logic
                                        itemSelectionMode: itemSelectionMode,
                                        enablePricePerWear: false, // Set to true if price per wear should be visible
                                        enableItemName: false, // Set to false if you don't want item names displayed
                                        isOutfit: false,
                                          onAction: () {
                                          _onItemSelected(
                                              context); // ✅ Call when an item is tapped
                                        }
                                      ),
                                    ),
                                  ],
                        );
                      } else if (viewItemsState is ItemsError) {
                        return Center(child: Text('Error fetching items: ${viewItemsState.error}'));
                      } else {
                        return const Center(child: ClosetProgressIndicator());
                      }
                    },
                  );
                }
          );
        }
  }
