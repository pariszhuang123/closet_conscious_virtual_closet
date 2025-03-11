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
  final bool useLargeHeight; // ✅ New parameter to control layout
  final OutfitSelectionMode outfitSelectionMode; // NEW
  final List<String> selectedOutfitIds; // ✅ Ensure this exists

  static final CustomLogger _logger = CustomLogger('OutfitList');

  const OutfitList({
    super.key,
    required this.outfits,
    required this.crossAxisCount,
    required this.onAction,
    required this.useLargeHeight, // ✅ Require boolean from parent
    required this.outfitSelectionMode, // NEW
    required this.selectedOutfitIds, // ✅ Add this
  });

  @override
  Widget build(BuildContext context) {
    if (outfits.isEmpty) {
      _logger.w("No outfits available, returning an empty widget.");
      return const SizedBox.shrink();
    }

    _logger.d("Building OutfitList with ${outfits.length} outfits.");

    return SizedBox(
      height: 200, // ✅ Constrain height for horizontal scrolling
      child: ListView.builder(
        scrollDirection: Axis.horizontal, // ✅ Enable horizontal scrolling
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        itemCount: outfits.length,
        itemBuilder: (context, index) {
          final outfit = outfits[index];

          final outfitId = (outfit is DailyCalendarOutfit)
              ? outfit.outfitId
              : (outfit as OutfitData?)?.outfitId ?? '';

          _logger.d("Rendering OutfitList item at index $index with outfitId: $outfitId");

          if (outfitSelectionMode == OutfitSelectionMode.multiSelection) {
          } else if (outfitSelectionMode == OutfitSelectionMode.singleSelection) {
          }
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: customBoxDecoration(
                    showBorder: selectedOutfitIds.contains(outfitId),
                    borderColor: Colors.teal, // Use your theme color or customize
                    imageSize: ImageSize.itemGrid3, // Adjust according to your use case
                  ),
                  child: SizedBox(
                    width: 300, // ✅ Set a width for horizontal layout
                    child: CarouselOutfit<T>(
                      useLargeHeight: useLargeHeight,
                      outfit: outfit,
                      crossAxisCount: crossAxisCount,
                      isSelected: selectedOutfitIds.contains(outfitId),
                      onTap: () {
                        OutfitSelectionHelper.handleTap(
                          context: context,
                          outfitId: outfitId,
                          outfitSelectionMode: outfitSelectionMode,
                          singleSelectionOutfitCubit: context.read<SingleSelectionOutfitCubit>(),
                          multiSelectionOutfitCubit: context.read<MultiSelectionOutfitCubit>(),
                          onAction: () {
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
      ),
    );
  }
}

