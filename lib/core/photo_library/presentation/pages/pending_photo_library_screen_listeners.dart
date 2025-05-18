import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';
import '../../../utilities/logger.dart';
import '../../../utilities/app_router.dart';
import '../../../widgets/feedback/custom_snack_bar.dart';
import '../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../bloc/photo_library_bloc/photo_library_bloc.dart';
import '../../../paywall/presentation/bloc/premium_feature_access_bloc/premium_feature_access_bloc.dart';
import '../widgets/show_photo_permission_dialog.dart';
import '../../../utilities/helper_functions/tutorial_helper.dart';
import '../../../core_enums.dart';
import '../widgets/show_upload_success_dialog.dart';
import '../../../utilities/helper_functions/navigate_once_helper.dart';

class PendingPhotoLibraryScreenListeners extends StatefulWidget {
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

  @override
  State<PendingPhotoLibraryScreenListeners> createState() => _PendingPhotoLibraryScreenListenersState();
}

class _PendingPhotoLibraryScreenListenersState extends State<PendingPhotoLibraryScreenListeners> with NavigateOnceHelper {

  FeatureKey _getFeatureKeyForState(PremiumFeatureAccessState state) {
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
              widget.logger.i('ShowTutorial → navigating to popup');
              navigateOnce(() {
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
              widget.logger.w('No images → showing permission dialog');
              navigateOnce(() {
                showPhotoPermissionDialog(context: context);
              });
            }

            if (state is PhotoLibraryNoPendingItem) {
              widget.logger.i('No pending items → checking feature access');
              context.read<PremiumFeatureAccessBloc>().add(const CheckUploadItemCreationAccessEvent());
            }

            if (state is PhotoLibraryPermissionDenied) {
              widget.logger.w('Permission denied → triggering handler');
              navigateOnce(() {
                widget.handleLibraryPermission(context);
              });
            }

            if (state is PhotoLibraryPermissionGranted && !widget.libraryInitialized) {
              widget.logger.i('Permission granted → initializing');
              widget.grantLibraryAccess(); // ✅ only now
              widget.markLibraryInitialized();
              context.read<PhotoLibraryBloc>().add(InitializePhotoLibrary());
            }

            if (state is PhotoLibraryUploadSuccess) {
              context.read<PhotoLibraryBloc>().add(CheckPostUploadApparelCount());
            }

            if (state is PhotoLibraryViewPendingLibrary) {
              navigateOnce(() {
                context.goNamed(AppRoutesName.viewPendingItem);
              });
            }

            if (state is PhotoLibraryUploadSuccessShowDialog) {
              showUploadSuccessDialog(context, Theme.of(context));
            }
          },
        ),
        BlocListener<PremiumFeatureAccessBloc, PremiumFeatureAccessState>(
          listener: (context, state) {
            if (state is BronzeUploadItemDeniedState ||
                state is SilverUploadItemDeniedState ||
                state is GoldUploadItemDeniedState) {
              final featureKey = _getFeatureKeyForState(state);
              widget.logger.i('Access denied → navigating to payment');
              navigateOnce(() {
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
              widget.logger.i('Item access granted → now request system permission');
              context.read<PhotoLibraryBloc>().add(PhotoLibraryPermissionRequested());
            }
          },
        ),
      ],
      child: widget.child,
    );
  }
}
