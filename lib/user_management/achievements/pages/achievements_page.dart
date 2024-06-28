import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../item_management/core/data/models/closet_item_minimal.dart';
import '../../../core/utilities/logger.dart';
import '../../../item_management/view_items/widget/item_grid.dart';
import '../../../core/theme/bloc/theme_bloc.dart';
import '../../../core/theme/bloc/theme_state.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  AchievementsPageState createState() => AchievementsPageState();
}

class AchievementsPageState extends State<AchievementsPage> {
  final ScrollController _scrollController = ScrollController();
  final CustomLogger _logger = CustomLogger('AchievementsPage');
  final List<ClosetItemMinimal> _achievements = [];
  final bool _isLoading = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Achievements'),
            backgroundColor: state.themeData.primaryColor,
          ),
          body: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ItemGrid(
            items: _achievements,
            scrollController: _scrollController,
            myClosetTheme: state.themeData,
            logger: _logger,
          ),
        );
      },
    );
  }
}
