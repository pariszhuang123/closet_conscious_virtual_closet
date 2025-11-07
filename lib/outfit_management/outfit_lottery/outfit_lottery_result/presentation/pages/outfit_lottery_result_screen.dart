import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/widgets/layout/grid/interactive_item_grid.dart';
import '../../../../../core/widgets/button/themed_elevated_button.dart';
import '../../../../../core/widgets/progress_indicator/outfit_progress_indicator.dart';

import '../../../../../core/core_enums.dart';
import '../../../../../core/utilities/logger.dart';
import '../../../../../generated/l10n.dart';
import '../../../../../core/presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../../core/utilities/app_router.dart';
import '../../../outfit_lottery_result/presentation/bloc/outfit_lottery_bloc.dart';
import '../../../../save_outfit_items/presentation/bloc/save_outfit_items_bloc.dart';
import '../../../../../core/utilities/helper_functions/suggestion_message_helper.dart';


class OutfitLotteryResultScreen extends StatefulWidget {
  final String? occasion;
  final String? season;
  final bool useAllClosets;

  const OutfitLotteryResultScreen({
    super.key,
    this.occasion,
    this.season,
    required this.useAllClosets,
  });

  @override
  State<OutfitLotteryResultScreen> createState() => _OutfitLotteryResultScreenState();
}

class _OutfitLotteryResultScreenState extends State<OutfitLotteryResultScreen> {
  final CustomLogger logger = CustomLogger('OutfitLotteryResultScreen');

  @override
  void initState() {
    super.initState();
    logger.d(
      'Running outfit lottery with occasion=${widget.occasion}, '
          'season=${widget.season}, useAllClosets=${widget.useAllClosets}',
    );
    context.read<OutfitLotteryBloc>().add(RunOutfitLottery(
      occasion: widget.occasion,
      season: widget.season,
      useAllClosets: widget.useAllClosets,
    ));
    context.read<CrossAxisCountCubit>().fetchCrossAxisCount();
  }

  void _onCreateOutfit(List<String> itemIds) {
    logger.d('Create outfit pressed with itemIds: $itemIds');
    context.pushNamed(
      AppRoutesName.createOutfit,
      extra: {
        'selectedItemIds': itemIds,
      },
    );
  }

  void _onSaveOutfit() {
    final state = context.read<OutfitLotteryBloc>().state;
    if (state is OutfitLotterySuccess) {
      final itemIds = state.items.map((e) => e.itemId).toList();
      context.read<SaveOutfitItemsBloc>().add(SaveOutfitEvent(itemIds));
    } else {
      logger.e('OutfitLotteryBloc is not in success state, cannot save.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SaveOutfitItemsBloc, SaveOutfitItemsState>(
        listener: (context, state) {
          if (state.saveStatus == SaveStatus.success && state.outfitId != null) {
            logger.i('Navigating to OutfitWearProvider for outfitId: ${state.outfitId}');
            context.goNamed(AppRoutesName.wearOutfit, extra: state.outfitId);
          }

          if (state.saveStatus == SaveStatus.failure) {
            logger.e('Failed to save outfit.');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(S.of(context).failedToSaveOutfit)),
            );
          }
        },
  child: Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).outfitLotteryResult),
        actions: [
          BlocBuilder<OutfitLotteryBloc, OutfitLotteryState>(
            builder: (context, state) {
              if (state is OutfitLotterySuccess) {
                final itemIds = state.items.map((e) => e.itemId).toList();
                return IconButton(
                  icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface),
                  onPressed: () => _onCreateOutfit(itemIds),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<OutfitLotteryBloc, OutfitLotteryState>(
        builder: (context, state) {
          if (state is OutfitLotteryLoading) {
            logger.d('State: OutfitLotteryLoading');
            return const Center(child: OutfitProgressIndicator());
          } else if (state is OutfitLotterySuccess) {
            final items = state.items;
            final itemIds = items.map((e) => e.itemId).toList();
            final suggestions = state.suggestions;

            final suggestionText = SuggestionMessageHelper.buildSuggestionMessage(context, suggestions);

            logger.d('State: OutfitLotterySuccess with ${items.length} items');

            return BlocBuilder<CrossAxisCountCubit, int>(
              builder: (context, crossAxisCount) {
                return Column(
                  children: [
                    Expanded(
                      child: InteractiveItemGrid(
                        crossAxisCount: crossAxisCount,
                        selectedItemIds: itemIds,
                        itemSelectionMode: ItemSelectionMode.disabled,
                        isOutfit: true,
                        isLocalImage: false,
                        usePagination: false,
                        items: items,
                      ),
                    ),

                    if (suggestions.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              S.of(context).suggestionsTitle, // e.g., "To improve your winter outfit..."
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              suggestionText,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ThemedElevatedButton(
                        onPressed: () => _onSaveOutfit(),
                        text: S.of(context).OutfitDay,
                      ),
                    ),
                  ],
                );
              },
            );
          } else if (state is OutfitLotteryFailure) {
            logger.e('State: OutfitLotteryFailure with message: ${state.message}');
            return Center(child: Text(state.message));
          } else {
            logger.d('State: Unknown or unhandled');
            return const Center(child: Text('No outfit lottery result.'));
          }
        },
      ),
  )
    );
  }
}
