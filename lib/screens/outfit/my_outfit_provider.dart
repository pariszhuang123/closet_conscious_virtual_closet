import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../outfit_management/save_outfit_items/presentation/bloc/save_outfit_items_bloc.dart';
import '../../outfit_management/core/data/services/outfits_fetch_services.dart';
import '../../outfit_management/core/data/services/outfits_save_services.dart';
import '../../outfit_management/core/outfit_enums.dart';
import '../../outfit_management/core/presentation/bloc/navigate_outfit_bloc/navigate_outfit_bloc.dart';
import '../../outfit_management/outfit_lottery/outfit_lottery_result/presentation/bloc/outfit_lottery_bloc.dart';
import '../../outfit_management/outfit_service_locator.dart';
import '../../outfit_management/outfit_ai_stylist/presentation/bloc/ai_stylist_bloc.dart';
import '../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import 'my_outfit_screen.dart';
import 'my_outfit_access_wrapper.dart';
import 'achievement_wrapper.dart';
import 'my_outfit_review_wrapper.dart';
import '../../core/utilities/logger.dart';
import '../../item_management/core/presentation/bloc/multi_selection_item_cubit/multi_selection_item_cubit.dart';
import '../../item_management/core/presentation/bloc/single_selection_item_cubit/single_selection_item_cubit.dart';
import '../../core/data/services/core_fetch_services.dart';
import '../../core/data/services/core_save_services.dart';
import '../../core/tutorial/pop_up_tutorial/presentation/bloc/tutorial_bloc.dart';
import '../../core/presentation/bloc/navigation_status_cubit/navigation_status_cubit.dart';
import '../../core/achievement_celebration/presentation/bloc/achievement_celebration_bloc/achievement_celebration_bloc.dart';
import '../../core/presentation/bloc/trial_bloc/trial_bloc.dart';
import '../../core/paywall/presentation/bloc/premium_feature_access_bloc/premium_feature_access_bloc.dart';
import '../../core/presentation/bloc/grid_pagination_cubit/grid_pagination_cubit.dart';
import '../../item_management/core/data/models/closet_item_minimal.dart';
import '../../core/core_service_locator.dart';


class MyOutfitProvider extends StatelessWidget {
  final ThemeData myOutfitTheme;
  final List<String> selectedItemIds;


  // Initialize logger for MyOutfitProvider
  final CustomLogger _logger = CustomLogger('MyOutfitProvider');

  MyOutfitProvider({
    super.key,
    required this.myOutfitTheme,
    required this.selectedItemIds,

  }) {
    _logger.i('MyOutfitProvider initialized with selectedItemIds: $selectedItemIds');
  }

  @override
  Widget build(BuildContext context) {
    _logger.d('Building MyOutfitProvider widgets');

    final outfitFetchService = outfitLocator<OutfitFetchService>();
    final outfitSaveService = outfitLocator<OutfitSaveService>();
    final coreFetchService = coreLocator<CoreFetchService>();
    final coreSaveService = coreLocator<CoreSaveService>();


    return MultiBlocProvider(
      providers: [
        BlocProvider<MultiSelectionItemCubit>(
          create: (context) => MultiSelectionItemCubit()..initializeSelection(selectedItemIds),
        ),

        BlocProvider<SingleSelectionItemCubit>(
          create: (context) => SingleSelectionItemCubit(),
        ),

        BlocProvider(
          create: (context) {
            _logger.d('Initializing NavigateOutfitBloc');
            return NavigateOutfitBloc(outfitFetchService: outfitFetchService, outfitSaveService: outfitSaveService, coreFetchService: coreFetchService);
          },
        ),
        BlocProvider(
          create: (context) {
            _logger.d('Initializing OutfitSaveBloc');
            return SaveOutfitItemsBloc(outfitSaveService);
          },
        ),
        BlocProvider(
          create: (context) {
            _logger.d('Initializing CrossAxisCountCubit');
            final crossAxisCountCubit = CrossAxisCountCubit(coreFetchService: coreFetchService);
            crossAxisCountCubit.fetchCrossAxisCount(); // Trigger initial fetch
            return crossAxisCountCubit;
          },
        ),
        BlocProvider<TutorialBloc>(
          create: (context) {
            _logger.d('Creating TutorialBloc with core services');
            return TutorialBloc(
              coreFetchService: coreFetchService,
              coreSaveService: coreSaveService,
            );
          },
        ),
        BlocProvider(
          create: (context) => NavigationStatusCubit(),
        ),
        BlocProvider<AchievementCelebrationBloc>(
          create: (_) => AchievementCelebrationBloc(
            outfitFetchService: outfitFetchService,
          ),
        ),
        BlocProvider<TrialBloc>(
          create: (_) => TrialBloc(coreFetchService),
        ),
        BlocProvider(
          create: (_) => PremiumFeatureAccessBloc(
            coreFetchService: coreFetchService,
            coreSaveService: coreSaveService,
          ),
        ),
        BlocProvider<OutfitLotteryBloc>(
          create: (context) {
            _logger.d('Initializing OutfitLotteryBloc');
            return OutfitLotteryBloc(outfitFetchService: outfitFetchService);
          },
        ),
        BlocProvider<AiStylistBloc>(
          create: (context) {
            _logger.d('Initializing AiStylistBloc');
            return AiStylistBloc(outfitFetchService: outfitFetchService);
          },
        ),
        BlocProvider<GridPaginationCubit<ClosetItemMinimal>>(
          create: (_) => GridPaginationCubit<ClosetItemMinimal>(
            fetchPage: ({
              required int pageKey,
              OutfitItemCategory? category,
            }) => outfitFetchService.fetchCreateOutfitItemsRPC(pageKey, category!),
            initialCategory: OutfitItemCategory.clothing,
          ),
        ),
      ],
      child: MyOutfitAccessWrapper(
        child: AchievementWrapper(
          isFromMyCloset: false,
          child: MyOutfitReviewWrapper(
            child: MyOutfitScreen(
              myOutfitTheme: myOutfitTheme,
              selectedItemIds: selectedItemIds,
            ),
          ),
        ),
      ),
    );
  }
}
