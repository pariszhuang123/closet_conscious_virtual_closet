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

  late Future<int> crossAxisCountFuture;

  @override
  void initState() {
    super.initState();
    logger.i('CreateMultiClosetScreen initialized');
    crossAxisCountFuture = _getCrossAxisCount();
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

    return FutureBuilder<int>(
      future: crossAxisCountFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: ClosetProgressIndicator());
        } else if (snapshot.hasError) {
          logger.e("Error fetching crossAxisCount: ${snapshot.error}");
          return Center(child: Text(S.of(context).failedToLoadItems));
        } else {
          final crossAxisCount = snapshot.data ?? 3;

          return BlocListener<CreateMultiClosetBloc, CreateMultiClosetState>(
            listener: (context, state) {
              logger.d('BlocListener triggered with state: $state');

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
            child: BlocBuilder<CreateMultiClosetBloc, CreateMultiClosetState>(
              builder: (context, state) {
                logger.d('BlocBuilder triggered with state: $state');

                closetNameController.text = state.closetName;
                monthsController.text = state.monthsLater?.toString() ?? '';

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Metadata Form
                    CreateMultiClosetMetadata(
                      closetNameController: closetNameController,
                      monthsController: monthsController,
                      closetType: state.closetType,
                      isPublic: state.isPublic ?? false,
                      theme: theme,
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
                              items: viewState.items, // Pass the items from the ViewItemsBloc
                              scrollController: _scrollController,
                              logger: CustomLogger("ClosetGrid"),
                              crossAxisCount: crossAxisCount,
                              itemSelector: context.read<CreateMultiClosetBloc>(),
                            );
                          } else {
                            return Center(child: Text(S.of(context).noItemsInCloset));
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Save Button
                    ElevatedButton(
                      onPressed: () {
                        logger.i('Save button pressed');
                        context.read<CreateMultiClosetBloc>().add(
                            ValidateClosetDetails());
                      },
                      child: Text(S.of(context).create_closet),
                    ),
                  ],
                );
              },
            ),
          );
        }
      },
    );
  }
  }