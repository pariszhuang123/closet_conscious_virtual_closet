import 'package:flutter/material.dart';
import '../../../core/utilities/logger.dart';
import '../widget/achievement_grid.dart';
import '../data/models/achievement_model.dart';

class AchievementsPage extends StatefulWidget {
  final bool isFromMyCloset;
  final List<Achievement> achievements;

  const AchievementsPage({
    super.key,
    required this.isFromMyCloset,
    required this.achievements,
  });

  @override
  AchievementsPageState createState() => AchievementsPageState();
}

class AchievementsPageState extends State<AchievementsPage> {
  final ScrollController _scrollController = ScrollController();
  final CustomLogger _logger = CustomLogger('AchievementsPage');
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate data loading
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : AchievementGrid(
        achievements: widget.achievements,
        scrollController: _scrollController,
        logger: _logger,
      ),
    );
  }
}
