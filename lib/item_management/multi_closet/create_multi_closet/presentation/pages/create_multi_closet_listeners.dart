import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/core_enums.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../core/utilities/app_router.dart';
import '../../../../../core/widgets/feedback/custom_snack_bar.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/theme/my_closet_theme.dart';
import '../../../core/presentation/bloc/update_closet_metadata_cubit/update_closet_metadata_cubit.dart';
import '../../../core/presentation/bloc/multi_closet_navigation_bloc/multi_closet_navigation_bloc.dart';
import '../bloc/create_multi_closet_bloc.dart';
import '../../../../core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../../../core/data/items_enums.dart';
import '../../../../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../../../core/utilities/helper_functions/tutorial_helper.dart';
import '../../../../view_items/presentation/bloc/view_items_bloc.dart';

class CreateMultiClosetListeners extends StatelessWidget {
  final Widget child;
  final CustomLogger logger;

  const CreateMultiClosetListeners({
    super.key,
    required this.child,
    required this.logger,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MultiClosetNavigationBloc, MultiClosetNavigationState>(
          listener: (context, state) {
            if (state is MultiClosetAccessState) {
              if (state.accessStatus == AccessStatus.trialPending) {
                logger.i('Trial pending: Navigating to trialStarted screen');
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.goNamed(
                    AppRoutesName.trialStarted,
                    extra: {
                      'selectedFeatureRoute': AppRoutesName.createMultiCloset,
                      'isFromMyCloset': true,
                    },
                  );
                });
              } else if (state.accessStatus == AccessStatus.denied) {
                logger.w('Access denied: Navigating to payment page');
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  context.goNamed(
                    AppRoutesName.payment,
                    extra: {
                      'featureKey': FeatureKey.multicloset,
                      'isFromMyCloset': true,
                      'previousRoute': AppRoutesName.myCloset,
                      'nextRoute': AppRoutesName.createMultiCloset,
                    },
                  );
                });
              } else if (state.accessStatus == AccessStatus.granted) {
                logger.i('Access granted: Fetching closet items.');
                context.read<ViewItemsBloc>().add(FetchItemsEvent(0, isPending: false));
              }
            }
          },
        ),
        BlocListener<CreateMultiClosetBloc, CreateMultiClosetState>(
          listener: (context, state) {
            final theme = myClosetTheme;

            if (state.status == ClosetStatus.valid) {
              logger.i('Validation succeeded. Creating closet.');
              final metadataState = context.read<UpdateClosetMetadataCubit>().state;

              context.read<CreateMultiClosetBloc>().add(
                CreateMultiClosetRequested(
                  closetName: metadataState.closetName,
                  closetType: metadataState.closetType,
                  isPublic: metadataState.isPublic,
                  monthsLater: metadataState.monthsLater,
                  itemIds: context
                      .read<MultiSelectionItemCubit>()
                      .state
                      .selectedItemIds,
                ),
              );
            } else if (state.status == ClosetStatus.success) {
              logger.i('Closet created successfully.');
              CustomSnackbar(
                message: S.of(context).closet_created_successfully,
                theme: theme,
              ).show(context);

              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.goNamed(AppRoutesName.myCloset);
              });
            } else if (state.status == ClosetStatus.failure) {
              logger.e('Error creating closet.');
              CustomSnackbar(
                message: state.error != null
                    ? S.of(context).error_creating_closet(state.error!)
                    : S.of(context).fix_validation_errors,
                theme: theme,
              ).show(context);
            }
          },
        ),
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, tutorialState) {
            if (tutorialState is ShowTutorial) {
              logger.i('Tutorial trigger detected, navigating to tutorial video pop-up');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.goNamed(
                  AppRoutesName.tutorialVideoPopUp,
                  extra: {
                    'nextRoute': AppRoutesName.createMultiCloset,
                    'tutorialInputKey': TutorialType.paidMultiCloset.value,
                    'isFromMyCloset': true,
                  },
                );
              });
            }
          },
        ),
      ],
      child: child,
    );
  }
}
