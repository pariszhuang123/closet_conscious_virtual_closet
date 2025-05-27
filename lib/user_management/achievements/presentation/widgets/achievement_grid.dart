import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/utilities/logger.dart';
import '../../data/models/achievement_model.dart';

class AchievementGrid extends StatelessWidget {
  final List<Achievement> achievements;
  final CustomLogger logger;

  const AchievementGrid({
    super.key,
    required this.achievements,
    required this.logger,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = DateFormat('yyyy-MM-dd');

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 4 / 5,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        logger.d('AchievementGrid: Rendering achievement ${achievement.achievementName}');
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: AspectRatio(
                  aspectRatio: 1.0,
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
              const SizedBox(height: 6),
              Text(
                dateFormatter.format(achievement.awardedAt),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        );
      },
    );
  }
}
