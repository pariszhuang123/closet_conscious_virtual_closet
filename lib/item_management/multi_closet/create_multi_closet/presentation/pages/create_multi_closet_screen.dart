import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/create_multi_closet_bloc.dart';
import '../../../../view_items/presentation/bloc/view_items_bloc.dart';
import '../widgets/multi_closet_item_grid.dart';
import '../widgets/create_multi_closet_metadata.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../core/data/items_enums.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/utilities/routes.dart';
import '../../../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../../../core/widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../../core/data/services/core_fetch_services.dart';
import '../../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../core/presentation/bloc/closet_metadata_validation_cubit/closet_metadata_validation_cubit.dart';
import '../../../../core/presentation/bloc/selection_item_cubit/selection_item_cubit.dart';

class CreateMultiClosetScreen extends StatefulWidget {
  const CreateMultiClosetScreen({super.key});

  @override
  State<CreateMultiClosetScreen> createState() => _CreateMultiClosetScreenState();
}

class _CreateMultiClosetScreenState extends State<CreateMultiClosetScreen> {
  final TextEditingController closetNameController = TextEditingController();
  final TextEditingController monthsController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final CustomLogger logger = CustomLogger('CreateMultiClosetScreen');

  late final Future<int> crossAxisCountFuture;

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
    final theme = Theme.of(context);
    logger.d('Building CreateMultiClosetScreen UI');

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
                BlocListener<ClosetMetadataValidationCubit, ClosetMetadataValidationState>(
                  listener: (context, validationState) {
                    logger.d('ValidationListener triggered with state: $validationState');

                    if (validationState.errorKeys == null) {
                      // Validation succeeded, dispatch event to CreateMultiClosetBloc
                      final createMultiClosetBloc = context.read<CreateMultiClosetBloc>();
                      createMultiClosetBloc.add(CreateMultiClosetRequested(
                        closetName: validationState.closetName,
                        closetType: validationState.closetType,
                        itemIds: context.read<SelectionItemCubit>().state.selectedItemIds,
                        monthsLater: validationState.monthsLater,
                        isPublic: validationState.isPublic,
                      ));
                    } else {
                      // Handle validation errors, e.g., show snackbar or highlight fields
                      CustomSnackbar(
                        message: S.of(context).validation_error,
                        theme: theme,
                      ).show(context);
                    }
                  },
                ),
                BlocListener<CreateMultiClosetBloc, CreateMultiClosetState>(
                  listener: (context, state) {
                    logger.d('CreateMultiClosetBlocListener triggered with state: $state');

                    if (state.status == ClosetStatus.success) {
                      logger.i('Closet created successfully');
                      CustomSnackbar(
                        message: S.of(context).closet_created_successfully,
                        theme: theme,
                      ).show(context);
                      _navigateToMyCloset(context);
                    } else if (state.status == ClosetStatus.failure) {
                      logger.e('Error creating closet: ${state.error}');
                      CustomSnackbar(
                        message: S.of(context).error_creating_closet(
                            state.error ?? ''),
                        theme: theme,
                      ).show(context);
                    }
                  },
                ),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Metadata Form
                  BlocBuilder<ClosetMetadataValidationCubit, ClosetMetadataValidationState>(
                    builder: (context, state) {
                      closetNameController.text = state.closetName;
                      monthsController.text = state.monthsLater?.toString() ?? '';
                      return CreateMultiClosetMetadata(
                        closetNameController: closetNameController,
                        monthsController: monthsController,
                        closetType: state.closetType,
                        isPublic: state.isPublic ?? false,
                        theme: theme,
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
                          return ClosetItemGrid(
                            items: viewState.items,
                            scrollController: _scrollController,
                            crossAxisCount: crossAxisCount,
                          );
                        } else {
                          return Center(child: Text(S.of(context).noItemsInCloset));
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Save Button Section
                BlocBuilder<SelectionItemCubit, SelectionItemState>(
                  builder: (context, selectionItemState) {
                    if (!selectionItemState.hasSelectedItems) {
                      return const SizedBox.shrink(); // Hide padding and button if no items selected
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: ThemedElevatedButton(
                          text: S.of(context).create_closet, // Provide text parameter
                          onPressed: () {
                            logger.i('Save button pressed');

                            // Validate metadata
                            context.read<ClosetMetadataValidationCubit>().validateFields();

                            final validationState =
                                context.read<ClosetMetadataValidationCubit>().state;
                            if (validationState.errorKeys != null) {
                              CustomSnackbar(
                                message: S.of(context).fix_validation_errors,
                                theme: theme,
                              ).show(context);
                              return;
                            }

                            // Dispatch save event
                            context.read<CreateMultiClosetBloc>().add(CreateMultiClosetRequested(
                              closetName: validationState.closetName,
                              closetType: validationState.closetType,
                              isPublic: validationState.isPublic,
                              monthsLater: validationState.monthsLater,
                              itemIds: selectionItemState.selectedItemIds,
                            ));
                          },
                        ),
                      ),
                    );
                  }
                )],
              ),
            );
          }
        },
      ),
    );
  }
}
