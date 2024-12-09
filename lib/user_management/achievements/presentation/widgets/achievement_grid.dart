import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utilities/logger.dart';
import '../../data/models/achievement_model.dart';
import '../../../../core/widgets/layout/base_layout/base_grid.dart';

class AchievementGrid extends StatelessWidget {
  final List<Achievement> achievements;
  final ScrollController scrollController;
  final CustomLogger logger;

  const AchievementGrid({
    super.key,
    required this.achievements,
    required this.scrollController,
    required this.logger,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('yyyy-MM-dd');

    return BaseGrid<Achievement>(
      items: achievements,
      scrollController: scrollController,
      crossAxisCount: 3,
      childAspectRatio: 3 / 4,
      itemBuilder: (context, achievement, index) {
        logger.d('AchievementGrid: Rendering achievement ${achievement.achievementName}');
        return Container(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,  // Aligns children to the start of the Column
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 5.0, left: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: AspectRatio(
                    aspectRatio: 1.0, // Ensures the box is square
                    child: Image.network(
                      achievement.badgeUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        logger.e('AchievementGrid: Error loading image for ${achievement.achievementName}');
                        return const Icon(Icons.error);
                      },
                    ),
                  ),
                ),
              ),
              // Use the text style from the theme
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  dateFormatter.format(achievement.awardedAt),  // Format the DateTime to String
                  style: Theme.of(context).textTheme.bodyMedium,  // Use the bodyMedium style from the theme
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
