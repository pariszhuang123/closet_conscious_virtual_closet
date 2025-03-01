import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../usage_analytics/outfit_analytics/summary_outfit_analytics/presentation/bloc/summary_outfit_analytics_bloc/summary_outfit_analytics_bloc.dart';

class PercentageOverlay extends StatelessWidget {
  final String percentageType; // "like_percentage", "alright_percentage", "dislike_percentage"

  const PercentageOverlay({super.key, required this.percentageType});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SummaryOutfitAnalyticsBloc, SummaryOutfitAnalyticsState>(
      builder: (context, state) {
        if (state is SummaryOutfitAnalyticsLoading) {
          return const SizedBox.shrink(); // Hide when loading
        } else if (state is SummaryOutfitAnalyticsFailure) {
          return Text(
            '-%',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          );
        } else if (state is SummaryOutfitAnalyticsSuccess) {
          double percentage = 0.0;

          switch (percentageType) {
            case "like_percentage":
              percentage = state.likePercentage;
              break;
            case "alright_percentage":
              percentage = state.alrightPercentage;
              break;
            case "dislike_percentage":
              percentage = state.dislikePercentage;
              break;
            default:
              percentage = 0.0;
          }

          return Text(
            '${percentage.toStringAsFixed(1)}%', // Keep 1 decimal place
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
