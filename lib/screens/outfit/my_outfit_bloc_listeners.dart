import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/widgets/feedback/custom_snack_bar.dart';
import '../../generated/l10n.dart';
import '../../core/utilities/logger.dart';
import '../../outfit_management/user_nps_feedback/presentation/nps_dialog.dart';
import '../../outfit_management/save_outfit_items/presentation/bloc/save_outfit_items_bloc.dart';
import '../../outfit_management/core/presentation/bloc/navigate_outfit_bloc/navigate_outfit_bloc.dart';
import '../../outfit_management/fetch_outfit_items/presentation/bloc/fetch_outfit_item_bloc.dart';
import '../../core/presentation/bloc/navigation_status_cubit/navigation_status_cubit.dart';
import '../../core/core_enums.dart';
import '../../core/utilities/app_router.dart';

class MyOutfitBlocListeners extends StatelessWidget {
  final Widget child;
  final CustomLogger logger;
  final int newOutfitCount;

  const MyOutfitBlocListeners({
    super.key,
    required this.child,
    required this.logger,
    required this.newOutfitCount,
  });

  @override
  Widget build(BuildContext context) {

    return MultiBlocListener(
      listeners: [
        BlocListener<NavigateOutfitBloc, NavigateOutfitState>(
          listener: (context, state) {
            logger.i('NavigateOutfitBloc listener triggered with state: $state');
            if (state is NpsSurveyTriggeredState) {
              logger.i('NPS Survey triggered for milestone: ${state.milestone}');
              NpsDialog.show(context, state.milestone);
            }
          },
        ),
        BlocListener<SaveOutfitItemsBloc, SaveOutfitItemsState>(
          listener: (context, state) {
            if (state.saveStatus == SaveStatus.success && state.outfitId != null) {
              logger.i('Navigating to OutfitWearProvider for outfitId: ${state.outfitId}');
              context.goNamed(AppRoutesName.wearOutfit, extra: state.outfitId);
            }
            if (state.saveStatus == SaveStatus.failure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.of(context).failedToSaveOutfit)),
              );
            }
          },
        ),
        BlocListener<FetchOutfitItemBloc, FetchOutfitItemState>(
          listener: (context, state) {
            logger.i('CreateOutfitItemBloc listener triggered with state: $state');

            final navigationStatus = context.read<NavigationStatusCubit>().state;

            if (!state.hasSelectedItems &&
                !navigationStatus.snackBarShown &&
                !navigationStatus.isNavigating &&
                newOutfitCount == 0) {
              context.read<NavigationStatusCubit>().setNavigating(true);

              WidgetsBinding.instance.addPostFrameCallback((_) {
                final snackBar = CustomSnackbar(
                  message: S.of(context).selectItemsToCreateOutfit,
                  theme: Theme.of(context),
                );
                snackBar.show(context);
                context.read<NavigationStatusCubit>().setSnackBarShown(true);
                context.read<NavigationStatusCubit>().setNavigating(false);
              });
            }
          },
        ),
      ],
      child: child,
    );
  }
}
