import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../utilities/logger.dart';
import '../bloc/photo_library_bloc.dart';
import '../../../../generated/l10n.dart';
import '../../../user_photo/presentation/widgets/base/user_photo.dart';
import '../widgets/pending_interactive_item_grid.dart';
import '../../../widgets/feedback/custom_snack_bar.dart';
import '../../../presentation/bloc/navigate_core_bloc/navigate_core_bloc.dart';
import '../../../paywall/data/feature_key.dart';
import '../../../utilities/routes.dart';
import '../../../widgets/button/upload_button_with_progress.dart';
import '../widgets/show_upload_success_dialog.dart';
import '../widgets/photo_library_container.dart';

class PendingPhotoLibraryScreen extends StatefulWidget {
  const PendingPhotoLibraryScreen({super.key});

  @override
  State<PendingPhotoLibraryScreen> createState() => _PendingPhotoLibraryScreen();
}

class _PendingPhotoLibraryScreen extends State<PendingPhotoLibraryScreen> {
  final _logger = CustomLogger('PendingPhotoLibraryScreen');

  @override
  void initState() {
    super.initState();
    _logger.i('initState: Requesting photo library permission');
    context.read<PhotoLibraryBloc>().add(RequestLibraryPermission());
    context.read<PhotoLibraryBloc>().add(CheckForPendingItems());
  }

  @override
  void dispose() {
    _logger.i('dispose: Clearing UserPhoto cache');
    UserPhoto.clearCache();
    super.dispose();
  }

  FeatureKey _getFeatureKeyForState(NavigateCoreState state) {
    if (state is BronzeUploadItemDeniedState) return FeatureKey.uploadItemBronze;
    if (state is SilverUploadItemDeniedState) return FeatureKey.uploadItemSilver;
    if (state is GoldUploadItemDeniedState) return FeatureKey.uploadItemGold;
    return FeatureKey.uploadItemBronze;
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building screen...');

    return MultiBlocListener(
      listeners: [
        BlocListener<PhotoLibraryBloc, PhotoLibraryState>(
          listener: (context, state) {
            if (state is PhotoLibraryMaxSelectionReached) {
              _logger.w('Listener: Max image selection reached (${state.maxAllowed})');
              CustomSnackbar(
                message: S.of(context).maxPendingItemsSnackbar(state.maxAllowed),
                theme: Theme.of(context),
              ).show(context);
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

              Navigator.pushReplacementNamed(
                context,
                AppRoutes.payment,
                arguments: {
                  'featureKey': featureKey,
                  'isFromMyCloset': true,
                  'previousRoute': AppRoutes.myCloset,
                  'nextRoute': AppRoutes.pendingPhotoLibrary,
                },
              );
            } else if (state is ItemAccessGrantedState) {
              final selectedAssets = context.read<PhotoLibraryBloc>().selectedImages;
              _logger.i('Listener: Access granted — dispatching upload for ${selectedAssets.length} assets');
              context.read<PhotoLibraryBloc>().add(UploadSelectedLibraryImages(assets: selectedAssets));
            }
          },
        ),
      ],

      child: BlocBuilder<PhotoLibraryBloc, PhotoLibraryState>(
        builder: (context, state) {
          _logger.i('Builder: Current PhotoLibraryBloc state: ${state.runtimeType}');

          if (state is PhotoLibraryFailure) {
            _logger.e('Failure: ${state.error}');
            return Center(child: Text(S.of(context).failedToLoadImages));
          }

          if (state is PhotoLibraryPermissionDenied) {
            _logger.w('Permission denied. Showing permission prompt UI.');
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Permission denied. Please grant photo library access.'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _logger.i('Permission button clicked — re-requesting permission');
                      context.read<PhotoLibraryBloc>().add(RequestLibraryPermission());
                    },
                      child: Text(S.of(context).photo_library_permission_explanation)
                  ),
                ],
              ),
            );
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
                    Navigator.pushReplacementNamed(context, AppRoutes.viewPendingItem);
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
              ValueListenableBuilder<List<AssetEntity>>(
                valueListenable: context.read<PhotoLibraryBloc>().selectedImagesNotifier,
                builder: (context, selectedAssets, _) {
                  if (selectedAssets.isEmpty) return const SizedBox.shrink();

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: UploadButtonWithProgress(
                      isLoading: state is PhotoLibraryUploading,
                      onPressed: () {
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
