import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utilities/logger.dart';
import '../../../../outfit_management/core/data/models/daily_calendar_outfit.dart';
import '../../../../outfit_management/core/data/models/outfit_data.dart';
import '../carousel/carousel_outfit.dart';
import '../../../utilities/helper_functions/selection_helper/outfit_selection_helper.dart';
import '../../../../outfit_management/core/presentation/bloc/single_selection_outfit_cubit/single_selection_outfit_cubit.dart';
import '../../../../outfit_management/core/presentation/bloc/multi_selection_outfit_cubit/multi_selection_outfit_cubit.dart';
import '../../../core_enums.dart';
import '../../container/selected_container.dart';

class OutfitList<T> extends StatelessWidget {
  final List<T> outfits;
  final int crossAxisCount;
  final Function(String outfitId) onAction;
  final OutfitSelectionMode outfitSelectionMode;
  final List<String> selectedOutfitIds; // ✅ Ensure this exists
  final double Function(OutfitSize) getHeightForOutfitSize; // ✅ Accepts function
  final OutfitSize outfitSize; // ✅ Accept from screen


  static final CustomLogger _logger = CustomLogger('OutfitList');

  const OutfitList({
    super.key,
    required this.outfits,
    required this.crossAxisCount,
    required this.onAction,
    required this.outfitSelectionMode,
    required this.selectedOutfitIds,
    required this.getHeightForOutfitSize, // ✅ Added function parameter
    required this.outfitSize, // ✅ Accept dynamically
  });

  @override
  Widget build(BuildContext context) {
    if (outfits.isEmpty) {
      _logger.w("No outfits available, returning an empty widget.");
      return const SizedBox.shrink();
    }

    _logger.d("Building OutfitList with ${outfits.length} outfits.");

    return SizedBox(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemCount: outfits.length,
        itemBuilder: (context, index) {
          final outfit = outfits[index];

          final outfitId = (outfit is DailyCalendarOutfit)
              ? outfit.outfitId
              : (outfit as OutfitData?)?.outfitId ?? '';

          return BlocSelector<MultiSelectionOutfitCubit, MultiSelectionOutfitState, bool>(
            selector: (state) {
              final isSelected = state.selectedOutfitIds.contains(outfitId);
              _logger.d("Multi Selection - Outfit ID: $outfitId, isSelected: $isSelected");
              return isSelected;
            },
            builder: (context, isSelected) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      key: ValueKey('${outfitId}_$isSelected'),
                      decoration: customBoxDecoration(
                        showBorder: isSelected,
                        borderColor: Theme.of(context).colorScheme.primary, // ✅ Uses theme's primary color
                        imageSize: ImageSize.itemGrid3, // ✅ Adjust based on your layout
                      ),
                      child: SizedBox(
                        width: 300, // ✅ Dynamically adjust width
                        child: CarouselOutfit<T>(
                          outfitSize: outfitSize,
                          getHeightForOutfitSize: getHeightForOutfitSize,
                          outfit: outfit,
                          crossAxisCount: crossAxisCount,
                          isSelected: isSelected,
                          onTap: () {
                            _logger.i("Outfit tapped: $outfitId");
                            OutfitSelectionHelper.handleTap(
                              context: context,
                              outfitId: outfitId,
                              outfitSelectionMode: outfitSelectionMode,
                              singleSelectionOutfitCubit: context.read<SingleSelectionOutfitCubit>(),
                              multiSelectionOutfitCubit: context.read<MultiSelectionOutfitCubit>(),
                              onAction: () {
                                _logger.d("Outfit action triggered: $outfitId");
                                onAction(outfitId);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
