import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../widgets/progress_indicator/closet_progress_indicator.dart';
import '../../../../../generated/l10n.dart';
import '../../../../theme/my_closet_theme.dart';
import '../../../../theme/my_outfit_theme.dart';
import '../../presentation/bloc/tutorial_bloc.dart';
import '../../presentation/widgets/tutorial_shorts_carousel.dart';
import '../../../../widgets/button/themed_elevated_button.dart';
import '../../../../utilities/app_router.dart';
import '../../../../utilities/helper_functions/tutorial_helper.dart';
import '../../../../presentation/bloc/personalization_flow_cubit/personalization_flow_cubit.dart';
import '../../../../utilities/logger.dart';
import '../../../../core_enums.dart';

class TutorialPopUpScreen extends StatelessWidget {
  final String tutorialInputKey;
  final String nextRoute;
  final bool isFromMyCloset;

  const TutorialPopUpScreen({
    super.key,
    required this.tutorialInputKey,
    required this.nextRoute,
    required this.isFromMyCloset,
  });

  void _onDismiss(BuildContext context, CustomLogger logger, TutorialDismissType type) {
    logger.i('Tutorial dismissed with type: ${type.name}');
    context.read<TutorialBloc>().add(
      SaveTutorialProgress(
        tutorialInput: tutorialInputKey,
        dismissType: type,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CustomLogger logger = CustomLogger('TutorialPopUpScreen');
    final appliedTheme = isFromMyCloset ? myClosetTheme : myOutfitTheme;

    logger.d('🧱 build: Using theme = ${isFromMyCloset ? "Closet" : "Outfit"}');

    return MultiBlocListener(
      listeners: [
        BlocListener<TutorialBloc, TutorialState>(
          listener: (context, state) {
            if (state is TutorialSaveSuccess) {
              logger.i('✅ Tutorial saved. Dismiss type: ${state.dismissType}');
              switch (state.dismissType) {
                case TutorialDismissType.confirmed:
                  context.goNamed(nextRoute);
                  break;
                case TutorialDismissType.dismissed:
                  context.goNamed(AppRoutesName.tutorialHub);
                  break;
              }
            } else if (state is TutorialSaveFailure) {
              logger.e('❌ Failed to save tutorial progress.');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(S.of(context).errorSavingTutorialProgress)),
              );
            }
          },
        ),
        BlocListener<PersonalizationFlowCubit, String>(
          listener: (context, state) {
            final tutorialType = tutorialInputKey.toTutorialType();
            final journeyType = state.toOnboardingJourneyType();
            logger.d('📦 Dispatching LoadTutorialFeatureData: $tutorialType, $journeyType');
            context.read<TutorialBloc>().add(
              LoadTutorialFeatureData(
                tutorialType: tutorialType,
                journeyType: journeyType,
              ),
            );
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: appliedTheme.colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<TutorialBloc, TutorialState>(
              builder: (context, state) {
                if (state is TutorialFeatureLoading) {
                  logger.d('⏳ TutorialFeatureLoading: Showing loading spinner.');
                  return const Center(child: ClosetProgressIndicator());
                }

                if (state is TutorialFeatureLoaded) {
                  logger.i('📽️ TutorialFeatureLoaded: Showing tutorial content.');
                  final featureData = state.featureData;

                  return Column(
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
                            onPressed: () => _onDismiss(context, logger, TutorialDismissType.dismissed),
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
                        onPressed: () => _onDismiss(context, logger, TutorialDismissType.confirmed),
                      ),
                    ],
                  );
                }

                if (state is TutorialFeatureLoadFailure) {
                  logger.e('⚠️ TutorialFeatureLoadFailure: Could not load tutorial.');
                  return const Center(child: ClosetProgressIndicator());
                }

                logger.d('🔄 Waiting for initial state...');
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }
}
