import 'package:flutter/material.dart';
import '../widgets/tutorial_feature_navigation.dart';
import '../../../../theme/my_closet_theme.dart';
import '../../../../../generated/l10n.dart';

class TutorialHubScreen extends StatelessWidget {
  const TutorialHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: myClosetTheme, // or a custom theme for tutorial
      child: Scaffold(
        appBar: AppBar(
          title: Text(S.of(context).tutorialHubTitle),
        ),
        body: const SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TutorialFeatureNavigation(),
            ],
          ),
        ),
      ),
    );
  }
}
