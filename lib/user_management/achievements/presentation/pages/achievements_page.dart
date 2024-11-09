import 'package:flutter/material.dart';
import '../../../../core/utilities/logger.dart';
import '../widgets/achievement_grid.dart';
import '../../data/models/achievement_model.dart';
import '../../../core/data/services/user_fetch_service.dart';
import '../../../../core/theme/my_closet_theme.dart';
import '../../../../core/theme/my_outfit_theme.dart';
import '../../../../../generated/l10n.dart';
import '../../../../core/widgets/progress_indicator/closet_progress_indicator.dart';

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
  final userFetchService = UserFetchSupabaseService();
  late Future<List<Achievement>> _futureAchievements;

  @override
  void initState() {
    super.initState();
    _logger.d('initState: Fetching achievements for user');
    _futureAchievements = userFetchService.fetchUserAchievements();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme;
    _logger.d('Building AchievementsGrid');

    return Theme(
      data: theme,
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).achievements),
          backgroundColor: theme.appBarTheme.backgroundColor,
        ),
        body: Container(
          color: theme.colorScheme.surface,
          child: FutureBuilder<List<Achievement>>(
            future: _futureAchievements,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: ClosetProgressIndicator());
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
