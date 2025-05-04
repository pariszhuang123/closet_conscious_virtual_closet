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
import '../../../../../core/utilities/helper_functions/navigate_once_helper.dart';

class CreateMultiClosetListeners extends StatefulWidget {
  final Widget child;
  final CustomLogger logger;

  const CreateMultiClosetListeners({
    super.key,
    required this.child,
    required this.logger,
  });

  @override
  State<CreateMultiClosetListeners> createState() => _CreateMultiClosetListenersState();
}

class _CreateMultiClosetListenersState extends State<CreateMultiClosetListeners> with NavigateOnceHelper {
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<MultiClosetNavigationBloc, MultiClosetNavigationState>(
          listener: (context, state) {
            if (state is MultiClosetAccessState) {
              if (state.accessStatus == AccessStatus.trialPending) {
                widget.logger.i('Trial pending: Navigating to trialStarted');
                navigateOnce(() {
                  context.goNamed(
                    AppRoutesName.trialStarted,
                    extra: {
                      'selectedFeatureRoute': AppRoutesName.createMultiCloset,
                      'isFromMyCloset': true,
                    },
                  );
                });
              } else if (state.accessStatus == AccessStatus.denied) {
                widget.logger.w('Access denied: Navigating to payment');
                navigateOnce(() {
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
                widget.logger.i('Access granted: Fetching items');
                context.read<ViewItemsBloc>().add(FetchItemsEvent(0, isPending: false));
              }
            }
          },
        ),
        BlocListener<CreateMultiClosetBloc, CreateMultiClosetState>(
          listener: (context, state) {
            final theme = myClosetTheme;

            if (state.status == ClosetStatus.valid) {
              widget.logger.i('Valid metadata: triggering creation');
              final metadataState = context.read<UpdateClosetMetadataCubit>().state;
              context.read<CreateMultiClosetBloc>().add(
                CreateMultiClosetRequested(
                  closetName: metadataState.closetName,
                  closetType: metadataState.closetType,
                  isPublic: metadataState.isPublic,
                  monthsLater: metadataState.monthsLater,
                  itemIds: context.read<MultiSelectionItemCubit>().state.selectedItemIds,
                ),
              );
            } else if (state.status == ClosetStatus.success) {
              widget.logger.i('Closet created → navigating to MyCloset');
              CustomSnackbar(
                message: S.of(context).closet_created_successfully,
                theme: theme,
              ).show(context);

              navigateOnce(() {
                context.goNamed(AppRoutesName.myCloset);
              });
            } else if (state.status == ClosetStatus.failure) {
              widget.logger.e('Failed to create closet');
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
              widget.logger.i('Tutorial detected → navigating to tutorial popup');
              navigateOnce(() {
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
      child: widget.child,
    );
  }
}
