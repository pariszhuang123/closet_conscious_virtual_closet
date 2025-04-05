import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../generated/l10n.dart';
import '../../../../theme/my_closet_theme.dart';
import '../../../../theme/my_outfit_theme.dart';
import '../../data/tutorial_feature_data.dart';
import '../../presentation/bloc/tutorial_bloc.dart';
import '../../presentation/widgets/tutorial_shorts_carousel.dart';
import '../../../../widgets/button/themed_elevated_button.dart';
import '../../../../utilities/app_router.dart';

class TutorialPopUpScreen extends StatefulWidget {
  final String tutorialInputKey;
  final String nextRoute;
  final bool isFromMyCloset;

  const TutorialPopUpScreen({
    super.key,
    required this.tutorialInputKey,
    required this.nextRoute,
    required this.isFromMyCloset,
  });

  @override
  State<TutorialPopUpScreen> createState() => _TutorialPopUpScreenState();
}

class _TutorialPopUpScreenState extends State<TutorialPopUpScreen> {
  late TutorialFeatureData featureData;
  int currentIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    featureData = TutorialFeatureList.getTutorials(context)
        .firstWhere((data) => data.tutorialInputKey == widget.tutorialInputKey);
  }

  void _onDismiss({required bool dismissedByButton}) {
    context.read<TutorialBloc>().add(
      SaveTutorialProgress(
        tutorialInput: widget.tutorialInputKey,
        dismissedByButton: dismissedByButton,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appliedTheme = widget.isFromMyCloset ? myClosetTheme : myOutfitTheme;

    return BlocListener<TutorialBloc, TutorialState>(
      listener: (context, state) {
        if (state is TutorialSaveSuccess) {
          if (state.dismissedByButton) {
            context.goNamed(widget.nextRoute); // ✅ Directly go to next screen
          } else {
            context.goNamed(AppRoutesName.tutorialHub); // ✅ Or go to tutorial hub
          }
        } else if (state is TutorialSaveFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(S.of(context).errorSavingTutorialProgress)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: appliedTheme.colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        featureData.getTitle(context),
                        style: appliedTheme.textTheme.displayLarge,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => _onDismiss(dismissedByButton: false),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: TutorialShortsCarousel(
                    youtubeIds: featureData.videos.map((v) => v.youtubeId).toList(),
                    descriptions: featureData.videos.map((v) => v.getDescription(context)).toList(),
                    theme: appliedTheme,
                  ),
                ),
                const SizedBox(height: 24),
                ThemedElevatedButton(
                  text: S.of(context).iAmReady,
                  onPressed: () => _onDismiss(dismissedByButton: true),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
