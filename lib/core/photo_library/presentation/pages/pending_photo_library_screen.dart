import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/logger.dart';
import '../bloc/photo_library_bloc.dart';
import '../../../widgets/button/themed_elevated_button.dart';
import '../../../../generated/l10n.dart';
import '../../../user_photo/presentation/widgets/base/user_photo.dart';
import '../widgets/pending_interactive_item_grid.dart';
import '../../../widgets/feedback/custom_snack_bar.dart';
import '../../../presentation/bloc/navigate_core_bloc/navigate_core_bloc.dart';
import '../../../paywall/data/feature_key.dart';
import '../../../utilities/routes.dart';


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
            return Center(
              child: Text('Failed to load or upload images: ${state.error}'),
            );
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
                    child: const Text('Request Permission Again'),
                  ),
                ],
              ),
            );
          }

          final bloc = context.read<PhotoLibraryBloc>();
          final selectedAssets = bloc.selectedImages;
          _logger.d('Rendering item grid with ${selectedAssets.length} selected images');

          return Column(
            children: [
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
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ThemedElevatedButton(
                  onPressed: selectedAssets.isNotEmpty
                      ? () {
                    _logger.i('Upload button clicked — assets selected: ${selectedAssets.length}');
                    context.read<PhotoLibraryBloc>().add(
                      UploadSelectedLibraryImages(assets: selectedAssets),
                    );
                  }
                      : null,
                  text: S.of(context).upload,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
