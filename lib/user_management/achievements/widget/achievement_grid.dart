import 'package:flutter/material.dart';
import '../../../core/utilities/logger.dart';
import '../data/models/achievement_model.dart';

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
    return GridView.builder(
      controller: scrollController,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3 / 4,
      ),
      itemCount: achievements.length,
      itemBuilder: (context, index) {
        final achievement = achievements[index];
        return Container(
          color: Colors.transparent,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 5.0, left: 5.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: AspectRatio(
                    aspectRatio: 1.0, // Ensures the box is square
                    child: Image.network(achievement.badgeUrl, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                achievement.achievementName,
                style: Theme.of(context).textTheme.labelSmall,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        );
      },
    );
  }
}
