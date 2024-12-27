import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/swap_closet_bloc.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../core/data/services/item_save_service.dart';
import '../../../../../core/data/services/core_fetch_services.dart';
import 'swap_closet_screen.dart';


class SwapClosetProvider extends StatelessWidget {
  final List<String> selectedItemIds;
  final String? closetId;
  final String? closetName;
  final String? closetType;
  final bool? isPublic;
  final DateTime? validDate; // Keep validDate as DateTime

  final CustomLogger logger = CustomLogger('SwapClosetProvider');

  SwapClosetProvider({
    super.key,
    required this.selectedItemIds,
    this.closetId,
    this.closetName,
    this.closetType,
    this.isPublic,
    this.validDate,
  }) {
    logger.i('SwapClosetProvider initialized with:');
    logger.i('selectedItemIds: $selectedItemIds');
    logger.i('closetId: $closetId');
    logger.i('closetName: $closetName');
    logger.i('closetType: $closetType');
    logger.i('isPublic: $isPublic');
    logger.i("validDate (DateTime): $validDate");

  }


  @override
  Widget build(BuildContext context) {
    final itemSaveService = ItemSaveService(); // Create an instance here
    final coreFetchService = CoreFetchService(); // Create an instance here

    return MultiBlocProvider(
      providers: [
        // Bloc for saving the multi-closet
        BlocProvider<SwapClosetBloc>(
          create: (context) => SwapClosetBloc(
            itemSaveService: itemSaveService,
            fetchService: coreFetchService, // Ensure name matches 'fetchService'
          ),
        ),
      ],
      child: SwapClosetScreen(
        selectedItemIds: selectedItemIds,
        currentClosetId: closetId,
        closetName: closetName,
        closetType: closetType,
        isPublic: isPublic,
        validDate: validDate,
      ),
    );
  }
}
