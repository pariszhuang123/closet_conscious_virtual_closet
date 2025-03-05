import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../item_management/core/data/services/item_fetch_service.dart';
import '../../../../../data/services/core_save_services.dart';
import '../../../../../../item_management/core/presentation/bloc/fetch_item_image_cubit/fetch_item_image_cubit.dart';
import '../../../../core/presentation/bloc/navigate_to_item_cubit/navigate_to_item_cubit.dart';
import '../../../../../utilities/logger.dart';
import 'focused_items_analytics_screen.dart';
import '../../../../../core_service_locator.dart';
import '../../../../../../item_management/item_service_locator.dart';

class FocusedItemsAnalyticsProvider extends StatelessWidget {
  final bool isFromMyCloset; // Determines the theme
  final String itemId;

  const FocusedItemsAnalyticsProvider({
    super.key,
    required this.isFromMyCloset,
    required this.itemId,
  });

  @override
  Widget build(BuildContext context) {
    final itemFetchService = itemLocator<ItemFetchService>();
    final coreSaveService = coreLocator<CoreSaveService>();

    final logger = CustomLogger('FocusedItemsAnalyticsProvider');

    logger.i('Initializing FocusedItemsAnalyticsProvider for item ID: $itemId');

    return MultiBlocProvider(
      providers: [
        BlocProvider<FetchItemImageCubit>(
          create: (_) {
            logger.i('Creating FetchItemImageCubit...');
            final cubit = FetchItemImageCubit(itemFetchService);
            cubit.fetchItemImage(itemId);
            return cubit;
          },
        ),
        BlocProvider<NavigateToItemCubit>(
          create: (_) => NavigateToItemCubit(coreSaveService),
        ),
      ],
      child: FocusedItemsAnalyticsScreen(
          isFromMyCloset: isFromMyCloset,
          itemId: itemId),
    );
  }
}
