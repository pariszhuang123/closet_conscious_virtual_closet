import 'package:closet_conscious/core/core_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/my_closet_theme.dart';
import '../bloc/edit_multi_closet_bloc.dart';
import '../../../../view_items/presentation/bloc/view_items_bloc.dart';
import '../../../../../core/widgets/layout/grid/interactive_item_grid.dart';
import '../../../create_multi_closet/presentation/widgets/create_multi_closet_metadata.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../core/data/items_enums.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/routes.dart';
import '../../../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../../core/data/services/core_fetch_services.dart';
import '../../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../core/presentation/bloc/closet_metadata_cubit/closet_metadata_cubit.dart';
import '../../../../core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../core/presentation/widgets/multi_closet_feature_container.dart';


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


  late final Future<int> crossAxisCountFuture;
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

  @override
  void initState() {
    super.initState();
    logger.i('CreateMultiClosetScreen initialized');
    crossAxisCountFuture = _getCrossAxisCount();
    context.read<ViewItemsBloc>().add(FetchItemsEvent(0));

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

  Future<int> _getCrossAxisCount() async {
    final coreFetchService = CoreFetchService();
    return await coreFetchService.fetchCrossAxisCount();
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
    logger.i('CreateMultiClosetScreen initialized with selectedItemIds: ${widget.selectedItemIds}');

    final theme = Theme.of(context);
    logger.d('Building EditMultiClosetScreen UI');

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.translucent,
      child: FutureBuilder<int>(
        future: crossAxisCountFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: ClosetProgressIndicator());
          } else if (snapshot.hasError) {
            logger.e("Error fetching crossAxisCount: ${snapshot.error}");
            return Center(child: Text(S.of(context).failedToLoadItems));
          } else {
            final crossAxisCount = snapshot.data ?? 3;

            return MultiBlocListener(
              listeners: [
                BlocListener<EditMultiClosetBloc, EditMultiClosetState>(
                  listener: (context, state) {
                    if (state.status == ClosetStatus.valid) {
                      logger.i('Validation succeeded. Triggering EditMultiClosetRequested event.');

                      final metadataState = context.read<ClosetMetadataCubit>().state;
                      context.read<EditMultiClosetBloc>().add(EditMultiClosetSwapped(
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MultiClosetFeatureContainer(
                    theme: myClosetTheme,
                    onFilterButtonPressed:  () => _onFilterButtonPressed(context, false),
                    onArrangeButtonPressed: () => _onArrangeButtonPressed(context, false),
                    onResetButtonPressed: () => _onResetButtonPressed(context),
                  ),
                  const SizedBox(height: 10),

                  BlocBuilder<ClosetMetadataCubit, ClosetMetadataState>(
                    builder: (context, metadataState) {
                      closetNameController.text = metadataState.closetName;
                      monthsController.text = metadataState.monthsLater?.toString() ?? '';
                      return CreateMultiClosetMetadata(
                        closetNameController: closetNameController,
                        monthsController: monthsController,
                        closetType: metadataState.closetType,
                        isPublic: metadataState.isPublic ?? false,
                        theme: theme,
                        errorKeys: validationErrors, // Pass validation errors
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
                          return Center(child: Text(S.of(context).failedToLoadItems));
                        } else if (viewState is ItemsLoaded) {
                          return InteractiveItemGrid(
                            items: viewState.items,
                            scrollController: _scrollController,
                            crossAxisCount: crossAxisCount,
                            isDisliked: false,
                            selectionMode: SelectionMode.multiSelection,
                            selectedItemIds: widget.selectedItemIds, // Pass the selectedItemIds
                          );
                        } else {
                          return Center(child: Text(S.of(context).noItemsInCloset));
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
                          bottom: MediaQuery.of(context).viewInsets.bottom + 20, // Adjust padding for keyboard
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: ThemedElevatedButton(
                            text: S.of(context).create_closet,
                            onPressed: () {
                              final metadataState = context.read<ClosetMetadataCubit>().state;
                              context.read<EditMultiClosetBloc>().add(EditMultiClosetValidate(
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
              ),
            );
          }
        },
      ),
    );
  }
}
