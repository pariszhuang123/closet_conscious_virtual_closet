import 'package:flutter/material.dart';
import '../../../core/utilities/logger.dart';
import '../widget/achievement_grid.dart';
import '../data/models/achievement_model.dart';
import '../../core/data/services/user_fetch_service.dart';
import '../../../core/theme/my_closet_theme.dart';
import '../../../core/theme/my_outfit_theme.dart';
import '../../../../generated/l10n.dart';

final CustomLogger logger = CustomLogger('AchievementsPage');

class AchievementsPage extends StatefulWidget {
  final bool isFromMyCloset;
  final String userId;

  const AchievementsPage({
    super.key,
    required this.isFromMyCloset,
    required this.userId,
  });

  @override
  AchievementsPageState createState() => AchievementsPageState();
}

class AchievementsPageState extends State<AchievementsPage> {
  final ScrollController _scrollController = ScrollController();
  final CustomLogger _logger = CustomLogger('AchievementsPage');
  late Future<List<Achievement>> _futureAchievements;

  @override
  void initState() {
    super.initState();
    _logger.d('initState: Fetching achievements for user ${widget.userId}');
    _futureAchievements = fetchUserAchievements(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme;
    _logger.d('Building AchievementsGrid');

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Achievements'),
          backgroundColor: theme.appBarTheme.backgroundColor,
        ),
        body: Container(
          color: Colors.white,
          child: FutureBuilder<List<Achievement>>(
            future: _futureAchievements,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                _logger.e('Error fetching achievements: ${snapshot.error}');
                return const Center(child: Text('Error loading achievements'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                _logger.d('No achievements to display');
                return Center(child: Text(S.of(context).noAchievementFound,
                ));
              } else {
                final achievements = snapshot.data!;
                return AchievementGrid(
                  achievements: achievements,
                  scrollController: _scrollController,
                  logger: _logger,
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
