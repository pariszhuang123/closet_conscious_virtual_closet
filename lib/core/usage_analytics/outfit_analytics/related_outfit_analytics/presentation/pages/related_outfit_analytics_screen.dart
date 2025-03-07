import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../utilities/logger.dart';
import '../../../../../presentation/bloc/cross_axis_core_cubit/cross_axis_count_cubit.dart';
import '../../../../core/presentation/bloc/single_outfit_focused_date_cubit/outfit_focused_date_cubit.dart';
import '../bloc/single_outfit_cubit/single_outfit_cubit.dart';
import '../bloc/related_outfits_cubit/related_outfits_cubit.dart';
import '../../../../../../outfit_management/core/data/models/outfit_data.dart';
import '../../../../../../outfit_management/outfit_calendar/daily_calendar/presentation/widgets/carousel_outfit.dart';
import '../../../../../widgets/layout/list/outfit_list.dart';
import '../../../../../widgets/progress_indicator/outfit_progress_indicator.dart';
import '../../../../../utilities/routes.dart';


class RelatedOutfitAnalyticsScreen extends StatelessWidget {
  final bool isFromMyCloset;
  final String outfitId;

  static final _logger = CustomLogger('RelatedOutfitAnalyticsScreen');

  const RelatedOutfitAnalyticsScreen({
    super.key,
    required this.isFromMyCloset,
    required this.outfitId,
  });

  @override
  Widget build(BuildContext context) {
    _logger.d('Building RelatedOutfitAnalyticsScreen for outfitId: $outfitId');
    return BlocListener<OutfitFocusedDateCubit, OutfitFocusedDateState>(
        listener: (context, state) {
          if (state is OutfitFocusedDateSuccess) {
            _logger.i('✅ Focused date set successfully for outfitId: ${state.outfitId}');
            Navigator.pushReplacementNamed(
              context,
              AppRoutes.dailyCalendar,
              arguments: {'outfitId': state.outfitId}, // ✅ Pass as a Map
            );
          } else if (state is OutfitFocusedDateFailure) {
            _logger.e('❌ Failed to set focused date: ${state.error}');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },

    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ✅ Fetch & Display Main Outfit
        BlocBuilder<SingleOutfitCubit, SingleOutfitState>(
          builder: (context, outfitState) {
            if (outfitState is FetchOutfitLoading) {
              return const Center(child: OutfitProgressIndicator());
            } else if (outfitState is FetchOutfitFailure) {
              return Center(child: Text('Error: ${outfitState.error}'));
            } else if (outfitState is FetchOutfitSuccess) {
              final mainOutfit = outfitState.outfit;

              return BlocBuilder<CrossAxisCountCubit, int>(
                builder: (context, crossAxisCount) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: CarouselOutfit(
                      outfit: mainOutfit,
                      crossAxisCount: crossAxisCount,
                      isSelected: true,
                      onTap: () {
                        _logger.d('Tapped on main outfit: $outfitId');
                        context.read<OutfitFocusedDateCubit>().setFocusedDateForOutfit(outfitId);
                      },
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),

        const SizedBox(height: 16),

        // ✅ Fetch & Display Related Outfits
        BlocBuilder<RelatedOutfitsCubit, RelatedOutfitsState>(
          builder: (context, relatedState) {
            if (relatedState is RelatedOutfitsLoading) {
              return const Center(child: OutfitProgressIndicator());
            } else if (relatedState is RelatedOutfitsFailure) {
              return Center(child: Text('Error: ${relatedState.error}'));
            } else if (relatedState is NoRelatedOutfitState) {
              return const Center(child: Text('No related outfits found.'));
            } else if (relatedState is RelatedOutfitsSuccess) {
              final relatedOutfits = relatedState.relatedOutfits;

              return BlocBuilder<CrossAxisCountCubit, int>(
                builder: (context, crossAxisCount) {
                  return OutfitList<OutfitData>(
                    outfits: relatedOutfits,
                    crossAxisCount: crossAxisCount,
                    onOutfitTap: (selectedOutfitId) {
                      _logger.d('Tapped related outfit: $selectedOutfitId');
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.relatedOutfitAnalytics,
                        arguments: selectedOutfitId,
                      );
                    },
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    )
    );
  }
}
