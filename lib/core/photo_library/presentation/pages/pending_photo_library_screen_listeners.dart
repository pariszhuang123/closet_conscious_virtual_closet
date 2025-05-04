import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../../utilities/logger.dart';
import '../../../utilities/app_router.dart';
import '../../../widgets/feedback/custom_snack_bar.dart';
import '../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../bloc/photo_library_bloc/photo_library_bloc.dart';
import '../../../presentation/bloc/navigate_core_bloc/navigate_core_bloc.dart';
import '../widgets/show_photo_permission_dialog.dart';
import '../../../utilities/helper_functions/tutorial_helper.dart';
import '../../../core_enums.dart';
import '../widgets/show_upload_success_dialog.dart';

class PendingPhotoLibraryScreenListeners extends StatelessWidget {
  final CustomLogger logger;
  final Widget child;
  final void Function(BuildContext context) handleLibraryPermission;
  final void Function() navigateToMyCloset;
  final bool libraryInitialized;
  final Function() markLibraryInitialized;
  final Function() grantLibraryAccess;

  const PendingPhotoLibraryScreenListeners({
    super.key,
    required this.logger,
    required this.child,
    required this.handleLibraryPermission,
    required this.navigateToMyCloset,
    required this.libraryInitialized,
    required this.markLibraryInitialized,
    required this.grantLibraryAccess,
  });

  FeatureKey _getFeatureKeyForState(NavigateCoreState state) {
    if (state is BronzeUploadItemDeniedState) return FeatureKey.uploadItemBronze;
    if (state is SilverUploadItemDeniedState) return FeatureKey.uploadItemSilver;
    if (state is GoldUploadItemDeniedState) return FeatureKey.uploadItemGold;
    return FeatureKey.uploadItemBronze;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, tutorialState) {
            if (tutorialState is ShowTutorial) {
              logger.i('Tutorial trigger detected → navigating to tutorial pop-up');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.goNamed(
                  AppRoutesName.tutorialVideoPopUp,
                  extra: {
                    'nextRoute': AppRoutesName.pendingPhotoLibrary,
                    'tutorialInputKey': TutorialType.freeUploadPhotoLibrary.value,
                    'isFromMyCloset': true,
                  },
                );
              });
            }
          },
        ),
        BlocListener<PhotoLibraryBloc, PhotoLibraryState>(
          listener: (context, state) {
            if (state is PhotoLibraryMaxSelectionReached) {
              final isApproachingLimit = state.maxAllowed < 5;
              final message = isApproachingLimit
                  ? S.of(context).approachingLimitSnackbar(state.maxAllowed)
                  : S.of(context).maxPendingItemsSnackbar(state.maxAllowed);
              CustomSnackbar(message: message, theme: Theme.of(context)).show(context);
            }

            if (state is PhotoLibraryNoAvailableImages) {
              logger.w('No available images → show permission dialog');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showPhotoPermissionDialog(context: context);
              });
            }

            if (state is PhotoLibraryNoPendingItem) {
              logger.i('No pending item → dispatch access check');
              context.read<NavigateCoreBloc>().add(const CheckUploadItemCreationAccessEvent());
            }

            if (state is PhotoLibraryPermissionDenied) {
              logger.w('Permission denied → triggering permission helper');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                handleLibraryPermission(context);
              });
            }

            if (state is PhotoLibraryPermissionGranted && !libraryInitialized) {
              logger.i('Permission granted → initializing library');
              markLibraryInitialized();
              context.read<PhotoLibraryBloc>().add(InitializePhotoLibrary());
            }

            if (state is PhotoLibraryUploadSuccess) {
              context.read<PhotoLibraryBloc>().add(CheckPostUploadApparelCount());
            } else if (state is PhotoLibraryViewPendingLibrary) {
              context.goNamed(AppRoutesName.viewPendingItem);
            } else if (state is PhotoLibraryUploadSuccessShowDialog) {
              showUploadSuccessDialog(context, Theme.of(context));
            }
          },
        ),
        BlocListener<NavigateCoreBloc, NavigateCoreState>(
          listener: (context, state) {
            if (state is BronzeUploadItemDeniedState ||
                state is SilverUploadItemDeniedState ||
                state is GoldUploadItemDeniedState) {
              final featureKey = _getFeatureKeyForState(state);
              logger.i('Access denied → navigating to payment');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context.goNamed(
                  AppRoutesName.payment,
                  extra: {
                    'featureKey': featureKey,
                    'isFromMyCloset': true,
                    'previousRoute': AppRoutesName.myCloset,
                    'nextRoute': AppRoutesName.pendingPhotoLibrary,
                    'uploadSource': UploadSource.photoLibrary,
                  },
                );
              });
            } else if (state is ItemAccessGrantedState) {
              logger.i('Access granted');
              grantLibraryAccess();
            }
          },
        ),
      ],
      child: child,
    );
  }
}
