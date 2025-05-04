import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:go_router/go_router.dart';

import '../../../utilities/log_bread_crumb.dart';
import '../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../utilities/logger.dart';
import '../bloc/photo_library_bloc/photo_library_bloc.dart';
import '../../../../generated/l10n.dart';
import '../../../user_photo/presentation/widgets/base/user_photo.dart';
import '../widgets/pending_interactive_item_grid.dart';
import '../../../widgets/button/upload_button_with_progress.dart';
import '../widgets/photo_library_container.dart';
import '../../../utilities/app_router.dart';
import '../../../utilities/helper_functions/permission_helper/library_permission_helper.dart';
import '../../../tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../../core_enums.dart';
import 'pending_photo_library_screen_listeners.dart';

class PendingPhotoLibraryScreen extends StatefulWidget {
  const PendingPhotoLibraryScreen({super.key});

  @override
  State<PendingPhotoLibraryScreen> createState() => _PendingPhotoLibraryScreenState();
}

class _PendingPhotoLibraryScreenState extends State<PendingPhotoLibraryScreen> with WidgetsBindingObserver {
  final _logger = CustomLogger('PendingPhotoLibraryScreen');
  final LibraryPermissionHelper _libraryPermissionHelper = LibraryPermissionHelper();

  bool _libraryInitialized = false;
  bool _libraryAccessGranted = false;

  @override
  void initState() {
    super.initState();
    _logger.i('initState: Requesting photo library permission');
    context.read<PhotoLibraryBloc>().add(PhotoLibraryStarted());
    context.read<TutorialBloc>().add(
      const CheckTutorialStatus(TutorialType.freeUploadPhotoLibrary),
    );
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_libraryInitialized && _libraryAccessGranted) {
      _logger.d('Dependencies changed: checking permission again');
      _handleLibraryPermission(context);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed && !_libraryInitialized && _libraryAccessGranted) {
      _logger.d('App resumed, checking permission again');
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

  void _handleLibraryPermission(BuildContext context) {
    _logger.d('Handling library permission');
    _libraryPermissionHelper.checkAndRequestPermission(
      context: context,
      theme: Theme.of(context),
      onClose: _navigateToMyCloset,
    );
  }

  void _navigateToMyCloset() {
    _logger.d('Navigating to MyCloset');
    if (mounted) {
      context.pushNamed(AppRoutesName.myCloset);
    }
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building PendingPhotoLibraryScreen...');

    return PendingPhotoLibraryScreenListeners(
      logger: _logger,
      handleLibraryPermission: _handleLibraryPermission,
      navigateToMyCloset: _navigateToMyCloset,
      libraryInitialized: _libraryInitialized,
      markLibraryInitialized: () => _libraryInitialized = true,
      grantLibraryAccess: () => _libraryAccessGranted = true,
      child: BlocBuilder<PhotoLibraryBloc, PhotoLibraryState>(
        builder: (context, state) {
          _logger.i('Builder: Current state = ${state.runtimeType}');

          if (state is PhotoLibraryInitial) {
            return const Center(child: ClosetProgressIndicator());
          }

          if (state is PhotoLibraryFailure) {
            _logger.e('Failure: ${state.error}');
            return Center(child: Text(S.of(context).failedToLoadImages));
          }

          if (state is PhotoLibraryLoadingImages ||
              state is PhotoLibraryReady ||
              state is PhotoLibraryPendingItem ||
              state is PhotoLibraryNoPendingItem ||
              state is PhotoLibraryMaxSelectionReached ||
              state is PhotoLibraryUploading) {
            final selectedAssets = context.select<PhotoLibraryBloc, List<AssetEntity>>(
                  (bloc) => bloc.selectedImages,
            );
            final isLoading = state is PhotoLibraryUploading;

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
                    padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
                    child: PendingInteractiveItemGrid(
                      crossAxisCount: 3,
                      enablePricePerWear: false,
                      enableItemName: false,
                      isOutfit: false,
                      isLocalImage: true,
                    ),
                  ),
                ),
                if (selectedAssets.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: UploadButtonWithProgress(
                      isLoading: isLoading,
                      onPressed: () {
                        logBreadcrumb(
                          'Upload button pressed',
                          category: 'photo.upload',
                          data: {'selectedCount': selectedAssets.length},
                        );

                        context.read<PhotoLibraryBloc>().add(
                          UploadSelectedLibraryImages(assets: selectedAssets),
                        );
                      },
                      text: S.of(context).upload,
                      isFromMyCloset: true,
                    ),
                  ),
              ],
            );
          }

          _logger.w('Unhandled state: ${state.runtimeType}');
          return const Center(child: ClosetProgressIndicator());
        },
      ),
    );
  }
}
