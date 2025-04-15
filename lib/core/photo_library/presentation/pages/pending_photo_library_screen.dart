import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:go_router/go_router.dart';

import '../../../utilities/log_bread_crumb.dart';
import '../../../widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../utilities/logger.dart';
import '../bloc/photo_library_bloc.dart';
import '../../../../generated/l10n.dart';
import '../../../user_photo/presentation/widgets/base/user_photo.dart';
import '../widgets/pending_interactive_item_grid.dart';
import '../../../widgets/feedback/custom_snack_bar.dart';
import '../../../presentation/bloc/navigate_core_bloc/navigate_core_bloc.dart';
import '../../../utilities/app_router.dart';
import '../../../widgets/button/upload_button_with_progress.dart';
import '../widgets/show_upload_success_dialog.dart';
import '../widgets/photo_library_container.dart';
import '../widgets/show_photo_permission_dialog.dart';
import '../../../utilities/helper_functions/permission_helper/library_permission_helper.dart';
import '../../../utilities/helper_functions/tutorial_helper.dart';
import '../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../core_enums.dart';

class PendingPhotoLibraryScreen extends StatefulWidget {
  const PendingPhotoLibraryScreen({super.key});

  @override
  State<PendingPhotoLibraryScreen> createState() => _PendingPhotoLibraryScreen();
}

class _PendingPhotoLibraryScreen extends State<PendingPhotoLibraryScreen> with WidgetsBindingObserver {
  final _logger = CustomLogger('PendingPhotoLibraryScreen');
  final LibraryPermissionHelper _libraryPermissionHelper = LibraryPermissionHelper();
  bool _libraryInitialized = false;
  bool _libraryAccessGranted = false;

  @override
  void initState() {
    super.initState();
    _logger.i('initState: Requesting photo library permission');
    context.read<PhotoLibraryBloc>().add(RequestLibraryPermission());
    context.read<NavigateCoreBloc>().add(const CheckUploadItemCreationAccessEvent());
    context.read<TutorialBloc>().add(
      const CheckTutorialStatus(TutorialType.freeUploadPhotoLibrary),
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_libraryInitialized && _libraryAccessGranted) {
      _logger.d('Dependencies changed: checking camera permission');
      _handleLibraryPermission(context); // Safe to call here
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !_libraryInitialized && _libraryAccessGranted) {
      _logger.d('App resumed, checking camera permission again');
      _handleLibraryPermission(context);
    }
  }

  @override
  void dispose() {
    _logger.i('dispose: Clearing UserPhoto cache');
    UserPhoto.clearCache();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  FeatureKey _getFeatureKeyForState(NavigateCoreState state) {
    if (state is BronzeUploadItemDeniedState) return FeatureKey.uploadItemBronze;
    if (state is SilverUploadItemDeniedState) return FeatureKey.uploadItemSilver;
    if (state is GoldUploadItemDeniedState) return FeatureKey.uploadItemGold;
    return FeatureKey.uploadItemBronze;
  }

  void _handleLibraryPermission(BuildContext context) {
    _logger.d('Handling library permission');

    _libraryPermissionHelper.checkAndRequestPermission(
      context: context,
      theme: Theme.of(context),
      onClose: () {
        _logger.i('Permission handling closed. Navigate to myCloset.');
        _navigateToMyCloset();
      },
    );
  }

  void _navigateSafely(String routeName, {Object? arguments}) {
    if (mounted) {
      _logger.d('Navigating to $routeName with arguments: $arguments');
      context.pushNamed(routeName, extra: arguments);
    } else {
      _logger.e("Cannot navigate to $routeName, widget is not mounted");
    }
  }

  void _navigateToMyCloset() {
    _logger.d('Navigating to MyCloset');
    _navigateSafely (
        AppRoutesName.myCloset
    );
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building screen...');

    return MultiBlocListener(
      listeners: [
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, tutorialState) {
            if (tutorialState is ShowTutorial) {
              _logger.i('Tutorial trigger detected, navigating to tutorial video pop-up');
              context.goNamed(
                AppRoutesName.tutorialVideoPopUp,
                extra: {
                  'nextRoute': AppRoutesName.pendingPhotoLibrary,
                  'tutorialInputKey': TutorialType.freeUploadPhotoLibrary.value,
                  'isFromMyCloset': true,
                },
              );
            }
          },
        ),
        BlocListener<PhotoLibraryBloc, PhotoLibraryState>(
          listener: (context, state) {
            if (state is PhotoLibraryMaxSelectionReached) {
              _logger.w('Listener: Max image selection reached (${state.maxAllowed})');
              final isApproachingLimit = state.maxAllowed < 5;

              final message = isApproachingLimit
                  ? S.of(context).approachingLimitSnackbar(state.maxAllowed)
                  : S.of(context).maxPendingItemsSnackbar(state.maxAllowed);

              CustomSnackbar(
                message: message,
                theme: Theme.of(context),
              ).show(context);
            }
            if (state is PhotoLibraryNoAvailableImages) {
              _logger.w(
                  'No accessible images available under current permissions.');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                showPhotoPermissionDialog(
                  context: context,
                );
              });
            }
            if (state is PhotoLibraryPermissionDenied) {
              _logger.w('Photo library permission denied. Triggering permission helper.');
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _handleLibraryPermission(context);
              });
            }
            if (state is PhotoLibraryPermissionGranted && !_libraryInitialized) {
              _logger.i('Library permission granted');
              _libraryInitialized = true;

              // ✅ now dispatch initialization after user has interacted
              context.read<PhotoLibraryBloc>().add(InitializePhotoLibrary());
              context.read<PhotoLibraryBloc>().add(CheckForPendingItems());
            }

              if (state is PhotoLibraryUploadSuccess) {
              _logger.i(
                  'Listener: Upload success — showing continue upload dialog');

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
              _logger.i('Listener: Access denied — navigating to payment with featureKey: $featureKey');

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
            } else if (state is ItemAccessGrantedState) {
              _libraryAccessGranted = true;
              _logger.i('Library access granted');
            }
          },
        ),
      ],

      child: BlocBuilder<PhotoLibraryBloc, PhotoLibraryState>(
        builder: (context, state) {
          _logger.i('Builder: Current PhotoLibraryBloc state: ${state.runtimeType}');

          if (state is PhotoLibraryInitial) {
            return const Center(child: OutfitProgressIndicator());
          }

          if (state is PhotoLibraryFailure) {
            _logger.e('Failure: ${state.error}');
            return Center(child: Text(S.of(context).failedToLoadImages));
          }

            final selectedAssets = context.select<PhotoLibraryBloc, List<AssetEntity>>(
                  (bloc) => bloc.selectedImages,
            );

            _logger.d('Rendering item grid with ${selectedAssets.length} selected images');

          return Column(
            children: [
              if (state is PhotoLibraryPendingItem)
                PhotoLibraryContainer(
                  theme: Theme.of(context),
                  onViewPendingUploadButtonPressed: () {
                    context.goNamed(AppRoutesName.viewPendingItem);
                  },
                ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 4.0,
                  ),
                  child: PendingInteractiveItemGrid(
                    crossAxisCount: 3,
                    enablePricePerWear: false,
                    enableItemName: false,
                    isOutfit: false,
                    isLocalImage: true,
                  ),
                ),
              ),
              BlocBuilder<PhotoLibraryBloc, PhotoLibraryState>(
                builder: (context, state) {
                  final isLoading = state is PhotoLibraryUploading;
                  final selectedAssets = context.watch<PhotoLibraryBloc>().selectedImages;
                  if (selectedAssets.isEmpty) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: UploadButtonWithProgress(
                      isLoading: isLoading,
                      onPressed: () {
                        logBreadcrumb('Upload button pressed', category: 'photo.upload', data: {'selectedCount': 3});

                        context.read<PhotoLibraryBloc>().add(
                          UploadSelectedLibraryImages(assets: selectedAssets),
                        );
                      },
                      text: S.of(context).upload,
                      isFromMyCloset: true,
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
