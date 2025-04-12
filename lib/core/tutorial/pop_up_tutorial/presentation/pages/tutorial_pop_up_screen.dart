import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../../generated/l10n.dart';
import '../../../../theme/my_closet_theme.dart';
import '../../../../theme/my_outfit_theme.dart';
import '../../data/tutorial_feature_data.dart';
import '../../presentation/bloc/tutorial_bloc.dart';
import '../../presentation/widgets/tutorial_shorts_carousel.dart';
import '../../../../widgets/button/themed_elevated_button.dart';
import '../../../../utilities/app_router.dart';
import '../../../../utilities/helper_functions/tutorial_helper.dart';
import '../../../../presentation/bloc/personalization_flow_cubit/personalization_flow_cubit.dart';

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
  TutorialFeatureData? featureData;
  int currentIndex = 0;

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

    return MultiBlocListener(
      listeners: [
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, state) {
            if (state is TutorialSaveSuccess) {
              if (state.dismissedByButton) {
                context.goNamed(widget.nextRoute);
              } else {
                context.goNamed(AppRoutesName.tutorialHub);
              }
            } else if (state is TutorialSaveFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.of(context).errorSavingTutorialProgress)),
              );
            }
          },
        ),
        BlocListener<PersonalizationFlowCubit, String>(
          listener: (context, state) {
            final onboardingJourneyType = state.toOnboardingJourneyType();
            final tutorialType = widget.tutorialInputKey.toTutorialType();

            final tutorials = TutorialFeatureList.getTutorials(context);
            final feature = tutorials.firstWhere(
                  (data) => data.tutorialType == tutorialType,
              orElse: () => throw Exception('Tutorial type not found'),
            );

            setState(() {
              featureData = TutorialFeatureData(
                getTitle: feature.getTitle,
                tutorialType: feature.tutorialType,
                videos: feature.videos
                    .where((v) => v.journeyType == onboardingJourneyType)
                    .toList(),
              );
            });
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: appliedTheme.colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: featureData == null
                ? const Center(child: ClosetProgressIndicator())
                : Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        featureData!.getTitle(context),
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
                    youtubeIds: featureData!.videos.map((v) => v.youtubeId).toList(),
                    descriptions: featureData!.videos
                        .map((v) => v.getDescription(context))
                        .toList(),
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
